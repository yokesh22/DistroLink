import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class OrdersRepository {
  const OrdersRepository(this._client);
  final SupabaseClient _client;

  // ─── Queries ──────────────────────────────────────────────────────

  Future<List<Order>> recentForSalesman(
    String salesmanId, {
    int limit = 20,
  }) async {
    final rows = await _client
        .from('orders')
        .select('*, shops!inner(shop_name, shop_number)')
        .eq('salesman_id', salesmanId)
        .order('created_at', ascending: false)
        .limit(limit);

    return rows.map((dynamic row) {
      final r = row as Map<String, dynamic>;
      final flat = Map<String, dynamic>.from(r);
      final shop =
          (r['shops'] as Map<String, dynamic>?) ?? <String, dynamic>{};
      flat['shop_name'] = shop['shop_name'];
      flat['shop_number'] = shop['shop_number'];
      return Order.fromJson(flat);
    }).toList();
  }

  Future<SalesmanStats> salesmanStats(String salesmanId) async {
    final today = DateTime.now();
    final todayStr = _dateStr(today);

    final rows = await _client
        .from('orders')
        .select('grand_total, shop_id')
        .eq('salesman_id', salesmanId)
        .eq('order_date', todayStr);

    final ordersToday = rows.length;
    final revenueToday = rows.fold<double>(
      0,
      (s, dynamic r) =>
          s + ((r as Map<String, dynamic>)['grand_total'] as num).toDouble(),
    );
    final shopsVisited = rows
        .map((dynamic r) =>
            (r as Map<String, dynamic>)['shop_id'] as String)
        .toSet()
        .length;

    return SalesmanStats(
      ordersToday: ordersToday,
      revenueToday: revenueToday,
      shopsVisited: shopsVisited,
    );
  }

  Future<AnalyticsData> analyticsForSalesman(
    String salesmanId, {
    required int year,
    required int month,
  }) async {
    final from = '$year-${_pad(month)}-01';
    final toMonth = month == 12 ? 1 : month + 1;
    final toYear = month == 12 ? year + 1 : year;
    final to = '$toYear-${_pad(toMonth)}-01';

    final rows = await _client
        .from('orders')
        .select('grand_total, shop_id, order_date')
        .eq('salesman_id', salesmanId)
        .gte('order_date', from)
        .lt('order_date', to);

    final totalRevenue = rows.fold<double>(
      0,
      (s, dynamic r) =>
          s + ((r as Map<String, dynamic>)['grand_total'] as num).toDouble(),
    );
    final orderCount = rows.length;
    final avgOrderValue =
        orderCount > 0 ? totalRevenue / orderCount : 0.0;
    final shopsVisited = rows
        .map((dynamic r) =>
            (r as Map<String, dynamic>)['shop_id'] as String)
        .toSet()
        .length;

    final dailyRevenue = <String, double>{};
    for (final dynamic raw in rows) {
      final r = raw as Map<String, dynamic>;
      final d = (r['order_date'] as String).substring(0, 10);
      dailyRevenue[d] =
          (dailyRevenue[d] ?? 0) + (r['grand_total'] as num).toDouble();
    }

    return AnalyticsData(
      revenue: totalRevenue,
      orderCount: orderCount,
      avgOrderValue: avgOrderValue,
      shopsVisited: shopsVisited,
      dailyRevenue: dailyRevenue,
    );
  }

  Future<List<TopProduct>> topProductsForSalesman(
    String salesmanId, {
    int limit = 5,
  }) async {
    final rows = await _client
        .from('order_items')
        .select(
          'item_name, item_code, quantity, line_total,'
          ' orders!inner(salesman_id)',
        )
        .eq('orders.salesman_id', salesmanId)
        .limit(200);

    final map = <String, _ProductAcc>{};
    for (final dynamic raw in rows) {
      final r = raw as Map<String, dynamic>;
      final code = r['item_code'] as String;
      (map[code] ??= _ProductAcc(r['item_name'] as String, code))
        ..units += (r['quantity'] as num).toInt()
        ..revenue += (r['line_total'] as num).toDouble();
    }

    return (map.values.toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue)))
        .take(limit)
        .map(
          (a) => TopProduct(
            itemName: a.name,
            itemCode: a.code,
            totalUnits: a.units,
            totalRevenue: a.revenue,
          ),
        )
        .toList();
  }

  // ─── Mutations ────────────────────────────────────────────────────

  /// Submits a completed [OrderDraftState] to Supabase.
  ///
  /// Two-step insert (header then items). Phase 2: migrate to a Postgres RPC.
  Future<String> submit({
    required OrderDraftState draft,
    required String salesmanId,
    required String distributorId,
  }) async {
    assert(draft.isValid, 'OrderDraft must be valid before submit');

    final today = DateTime.now();
    final orderRow = await _client
        .from('orders')
        .insert({
          'order_number': _generateOrderNumber(),
          'distributor_id': distributorId,
          'salesman_id': salesmanId,
          'shop_id': draft.shop!.id,
          'area_id': draft.area!.id,
          'subtotal': draft.subtotal,
          'gst_total': draft.gstTotal,
          'grand_total': draft.grandTotal,
          'notes': draft.notes.isEmpty ? null : draft.notes,
          'order_date': _dateStr(today),
        })
        .select('id')
        .single();

    final orderId = orderRow['id'] as String;

    await _client.from('order_items').insert(
          draft.items
              .map(
                (item) => <String, dynamic>{
                  'order_id': orderId,
                  'product_id': item.productId,
                  'item_code': item.itemCode,
                  'item_name': item.itemName,
                  'mrp': item.mrp,
                  'selling_rate': item.sellingRate,
                  'quantity': item.quantity,
                  'gst_percent': item.gstPercent,
                  'line_total': item.lineTotal,
                },
              )
              .toList(),
        );

    return orderId;
  }

  /// Returns item names from the salesman's last order for "Quick Add" chips.
  Future<List<String>> lastOrderItemNames(String salesmanId) async {
    final order = await _client
        .from('orders')
        .select('id')
        .eq('salesman_id', salesmanId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (order == null) return [];

    final items = await _client
        .from('order_items')
        .select('item_name')
        .eq('order_id', order['id'] as String)
        .limit(6);

    return items
        .map((dynamic r) =>
            (r as Map<String, dynamic>)['item_name'] as String)
        .toList();
  }

  // ─── Helpers ─────────────────────────────────────────────────────

  /// Format: ORD-YYYYMMDD-XXXX. Phase 2: replace with server-side sequence.
  String _generateOrderNumber() {
    final now = DateTime.now();
    final date =
        '${now.year}${_pad(now.month)}${_pad(now.day)}';
    final suffix = const Uuid().v4().substring(0, 4).toUpperCase();
    return 'ORD-$date-$suffix';
  }

  String _dateStr(DateTime d) =>
      '${d.year}-${_pad(d.month)}-${_pad(d.day)}';

  String _pad(int n) => n.toString().padLeft(2, '0');
}

// ─── Supporting types ─────────────────────────────────────────────

class AnalyticsData {
  const AnalyticsData({
    required this.revenue,
    required this.orderCount,
    required this.avgOrderValue,
    required this.shopsVisited,
    required this.dailyRevenue,
  });

  final double revenue;
  final int orderCount;
  final double avgOrderValue;
  final int shopsVisited;

  /// Maps date string (yyyy-MM-dd) → total revenue for that day.
  final Map<String, double> dailyRevenue;

  static const empty = AnalyticsData(
    revenue: 0,
    orderCount: 0,
    avgOrderValue: 0,
    shopsVisited: 0,
    dailyRevenue: {},
  );
}

class TopProduct {
  const TopProduct({
    required this.itemName,
    required this.itemCode,
    required this.totalUnits,
    required this.totalRevenue,
  });

  final String itemName;
  final String itemCode;
  final int totalUnits;
  final double totalRevenue;
}

class _ProductAcc {
  _ProductAcc(this.name, this.code);
  final String name;
  final String code;
  int units = 0;
  double revenue = 0;
}
