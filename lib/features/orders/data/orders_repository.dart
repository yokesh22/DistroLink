import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/orders/domain/order_item.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:distro_link/services/hive/hive_service.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class OrdersRepository {
  OrdersRepository(this._client, this._hive);

  final SupabaseClient _client;
  final HiveService _hive;

  // ─── Queries ──────────────────────────────────────────────────────

  Future<List<OrderWithItems>> ordersInRange(
    String salesmanId,
    DateTime from,
    DateTime to,
  ) async {
    final fromStr = _dateStr(from);
    final toStr = _dateStr(to.add(const Duration(days: 1)));

    final rows = await _client
        .from('orders')
        .select(
          '*, '
          'shops!inner(shop_name, shop_number, shop_address), '
          'areas!inner(name), '
          'salesmen!inner(name, phone), '
          'distributors!inner(name, phone, email), '
          'order_items(*)',
        )
        .eq('salesman_id', salesmanId)
        .gte('order_date', fromStr)
        .lt('order_date', toStr)
        .order('order_date', ascending: true);

    return rows.map((dynamic raw) {
      final r = raw as Map<String, dynamic>;
      final flat = Map<String, dynamic>.from(r);
      final shop = (r['shops'] as Map<String, dynamic>?) ?? {};
      final area = (r['areas'] as Map<String, dynamic>?) ?? {};
      final salesman = (r['salesmen'] as Map<String, dynamic>?) ?? {};
      final distributor = (r['distributors'] as Map<String, dynamic>?) ?? {};
      flat
        ..['shop_name'] = shop['shop_name']
        ..['shop_number'] = shop['shop_number']
        ..['shop_address'] = shop['shop_address']
        ..['area_name'] = area['name']
        ..['salesman_name'] = salesman['name']
        ..['salesman_phone'] = salesman['phone']
        ..['distributor_name'] = distributor['name']
        ..['distributor_phone'] = distributor['phone']
        ..['distributor_email'] = distributor['email']
        ..remove('shops')
        ..remove('areas')
        ..remove('salesmen')
        ..remove('distributors')
        ..remove('order_items');

      final itemsRaw = (r['order_items'] as List<dynamic>?) ?? [];
      final items = itemsRaw
          .map((dynamic i) => OrderItem.fromJson(
                Map<String, dynamic>.from(i as Map),
              ))
          .toList();

      return OrderWithItems(
        order: Order.fromJson(flat),
        items: items,
      );
    }).toList();
  }

  Future<OrderWithItems> fetchOrderById(String orderId) async {
    final raw = await _client
        .from('orders')
        .select(
          '*, '
          'shops!inner(shop_name, shop_number, shop_address), '
          'areas!inner(name), '
          'salesmen!inner(name, phone), '
          'distributors!inner(name, phone, email), '
          'order_items(*)',
        )
        .eq('id', orderId)
        .single();

    final r = raw;
    final flat = Map<String, dynamic>.from(r);
    final shop = (r['shops'] as Map<String, dynamic>?) ?? {};
    final area = (r['areas'] as Map<String, dynamic>?) ?? {};
    final salesman = (r['salesmen'] as Map<String, dynamic>?) ?? {};
    final distributor = (r['distributors'] as Map<String, dynamic>?) ?? {};
    flat
      ..['shop_name'] = shop['shop_name']
      ..['shop_number'] = shop['shop_number']
      ..['shop_address'] = shop['shop_address']
      ..['area_name'] = area['name']
      ..['salesman_name'] = salesman['name']
      ..['salesman_phone'] = salesman['phone']
      ..['distributor_name'] = distributor['name']
      ..['distributor_phone'] = distributor['phone']
      ..['distributor_email'] = distributor['email']
      ..remove('shops')
      ..remove('areas')
      ..remove('salesmen')
      ..remove('distributors')
      ..remove('order_items');

    final itemsRaw = (r['order_items'] as List<dynamic>?) ?? [];
    final items = itemsRaw
        .map(
          (dynamic i) =>
              OrderItem.fromJson(Map<String, dynamic>.from(i as Map)),
        )
        .toList();

    return OrderWithItems(order: Order.fromJson(flat), items: items);
  }

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

    final pendingSync = _pendingCount();

    return SalesmanStats(
      ordersToday: ordersToday,
      revenueToday: revenueToday,
      shopsVisited: shopsVisited,
      pendingSync: pendingSync,
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
        .map(
          (dynamic r) =>
              (r as Map<String, dynamic>)['item_name'] as String,
        )
        .toList();
  }

  // ─── Outbox queries ───────────────────────────────────────────────

  List<OutboxOrder> pendingOutboxOrders() => _hive.outboxBox.values
      .where(
        (dynamic m) =>
            (m as Map<dynamic, dynamic>)['status'] ==
            OutboxStatus.pending.name,
      )
      .map(_toOutboxOrder)
      .toList();

  List<OutboxOrder> allPendingOrFailed() => _hive.outboxBox.values
      .where((dynamic m) {
        final status = (m as Map<dynamic, dynamic>)['status'] as String;
        return status == OutboxStatus.pending.name ||
            status == OutboxStatus.failed.name;
      })
      .map(_toOutboxOrder)
      .toList();

  // ─── Mutations ────────────────────────────────────────────────────

  Future<String> submit({
    required OrderDraftState draft,
    required String salesmanId,
    required String distributorId,
  }) async {
    assert(draft.isValid, 'OrderDraft must be valid before submit');

    final online = await _isOnline();
    if (!online) {
      return _enqueueOffline(
        draft: draft,
        salesmanId: salesmanId,
        distributorId: distributorId,
      );
    }
    try {
      return await _submitOnline(
        draft: draft,
        salesmanId: salesmanId,
        distributorId: distributorId,
      );
    } on Exception {
      return _enqueueOffline(
        draft: draft,
        salesmanId: salesmanId,
        distributorId: distributorId,
      );
    }
  }

  /// Updates an existing order in place (edit flow). Online-only — the edit
  /// UI is disabled offline, so we let any [PostgrestException] propagate.
  ///
  /// Preserves `order_number`, `created_at`, `order_date`, `salesman_id`
  /// and `distributor_id`; replaces line items wholesale (delete + re-insert).
  /// Not wrapped in a transaction — same non-atomic tradeoff as
  /// [_submitOnline].
  Future<void> updateOrder({
    required String orderId,
    required OrderDraftState draft,
  }) async {
    assert(
      draft.editingOrderId != null,
      'updateOrder requires a draft seeded for edit',
    );

    await _client
        .from('orders')
        .update({
          'shop_id': draft.shop!.id,
          'area_id': draft.area!.id,
          'subtotal': draft.subtotal,
          'gst_total': draft.gstTotal,
          'grand_total': draft.grandTotal,
          'notes': draft.notes.isEmpty ? null : draft.notes,
        })
        .eq('id', orderId);

    await _client.from('order_items').delete().eq('order_id', orderId);

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
                  'discount_percent': item.discountPercent,
                  'free_qty': item.freeQty,
                },
              )
              .toList(),
        );
  }

  /// Syncs a single outbox entry to Supabase. Called by the sync worker.
  Future<void> syncOutboxOrder(OutboxOrder entry) async {
    await _hive.outboxBox.put(
      entry.localId,
      entry.copyWith(status: OutboxStatus.syncing).toJson(),
    );

    try {
      final orderRow = await _client
          .from('orders')
          .insert({
            'order_number': entry.orderNumber,
            'distributor_id': entry.distributorId,
            'salesman_id': entry.salesmanId,
            'shop_id': entry.shopId,
            'area_id': entry.areaId,
            'subtotal': entry.subtotal,
            'gst_total': entry.gstTotal,
            'grand_total': entry.grandTotal,
            'notes': entry.notes,
            'order_date': entry.orderDate,
          })
          .select('id')
          .single();

      final orderId = orderRow['id'] as String;
      await _client.from('order_items').insert(
            entry.items
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
                    'discount_percent': item.discountPercent,
                    'free_qty': item.freeQty,
                  },
                )
                .toList(),
          );

      await _hive.outboxBox.put(
        entry.localId,
        entry.copyWith(status: OutboxStatus.synced).toJson(),
      );
    } on Exception {
      await _hive.outboxBox.put(
        entry.localId,
        entry
            .copyWith(
              status: OutboxStatus.failed,
              retryCount: entry.retryCount + 1,
            )
            .toJson(),
      );
      rethrow;
    }
  }

  // ─── Private ──────────────────────────────────────────────────────

  Future<String> _submitOnline({
    required OrderDraftState draft,
    required String salesmanId,
    required String distributorId,
  }) async {
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
                  'discount_percent': item.discountPercent,
                  'free_qty': item.freeQty,
                },
              )
              .toList(),
        );
    return orderId;
  }

  Future<String> _enqueueOffline({
    required OrderDraftState draft,
    required String salesmanId,
    required String distributorId,
  }) async {
    final localId = const Uuid().v4();
    final entry = OutboxOrder(
      localId: localId,
      distributorId: distributorId,
      salesmanId: salesmanId,
      shopId: draft.shop!.id,
      areaId: draft.area!.id,
      shopName: draft.shop!.shopName,
      shopNumber: draft.shop!.shopNumber ?? '',
      subtotal: draft.subtotal,
      gstTotal: draft.gstTotal,
      grandTotal: draft.grandTotal,
      orderDate: _dateStr(DateTime.now()),
      orderNumber: _generateOrderNumber(),
      status: OutboxStatus.pending,
      retryCount: 0,
      createdAt: DateTime.now(),
      items: draft.items
          .map(
            (item) => OutboxOrderItem(
              productId: item.productId,
              itemCode: item.itemCode,
              itemName: item.itemName,
              mrp: item.mrp,
              sellingRate: item.sellingRate,
              quantity: item.quantity,
              gstPercent: item.gstPercent,
              lineTotal: item.lineTotal,
              discountPercent: item.discountPercent,
              freeQty: item.freeQty,
            ),
          )
          .toList(),
      notes: draft.notes.isEmpty ? null : draft.notes,
    );
    await _hive.outboxBox.put(localId, entry.toJson());
    return localId;
  }

  int _pendingCount() => _hive.outboxBox.values
      .where(
        (dynamic m) =>
            (m as Map<dynamic, dynamic>)['status'] ==
            OutboxStatus.pending.name,
      )
      .length;

  OutboxOrder _toOutboxOrder(dynamic raw) =>
      OutboxOrder.fromJson(Map<String, dynamic>.from(raw as Map));

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  String _generateOrderNumber() {
    final now = DateTime.now();
    final date = '${now.year}${_pad(now.month)}${_pad(now.day)}';
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
