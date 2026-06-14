import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboardKpis {
  const AdminDashboardKpis({
    required this.totalSalesmen,
    required this.totalShops,
    required this.totalProducts,
    required this.ordersToday,
    required this.revenueToday,
    required this.ordersThisMonth,
  });
  final int totalSalesmen;
  final int totalShops;
  final int totalProducts;
  final int ordersToday;
  final double revenueToday;
  final int ordersThisMonth;
}

class AdminRecentOrder {
  const AdminRecentOrder({
    required this.id,
    required this.orderNumber,
    required this.shopName,
    required this.salesmanName,
    required this.grandTotal,
    required this.createdAt,
  });
  final String id;
  final String orderNumber;
  final String shopName;
  final String salesmanName;
  final double grandTotal;
  final DateTime createdAt;
}

class AdminDashboardRepository {
  const AdminDashboardRepository(this._client);
  final SupabaseClient _client;

  Future<AdminDashboardKpis> fetchKpis(String distributorId) async {
    final today = DateTime.now();
    final todayStr = '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    final monthStart = '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-01';

    final salesmenRes = await _client
        .from('salesmen')
        .select('id')
        .eq('distributor_id', distributorId)
        .eq('is_active', true)
        .count(CountOption.exact);

    final shopsRes = await _client
        .from('shops')
        .select('id')
        .eq('distributor_id', distributorId)
        .count(CountOption.exact);

    final productsRes = await _client
        .from('products')
        .select('id')
        .eq('distributor_id', distributorId)
        .eq('is_active', true)
        .count(CountOption.exact);

    final todayRows = await _client
        .from('orders')
        .select('grand_total')
        .eq('distributor_id', distributorId)
        .eq('order_date', todayStr);

    final monthRes = await _client
        .from('orders')
        .select('id')
        .eq('distributor_id', distributorId)
        .gte('order_date', monthStart)
        .count(CountOption.exact);

    final revenueToday = todayRows.fold<double>(
      0,
      (sum, row) => sum + (row['grand_total'] as num).toDouble(),
    );

    return AdminDashboardKpis(
      totalSalesmen: salesmenRes.count,
      totalShops: shopsRes.count,
      totalProducts: productsRes.count,
      ordersToday: todayRows.length,
      revenueToday: revenueToday,
      ordersThisMonth: monthRes.count,
    );
  }

  Future<List<AdminRecentOrder>> recentActivity(
    String distributorId, {
    required DateTime from,
    required DateTime to,
  }) async {
    final fromStr = '${from.year}-'
        '${from.month.toString().padLeft(2, '0')}-'
        '${from.day.toString().padLeft(2, '0')}';
    final toStr = '${to.year}-'
        '${to.month.toString().padLeft(2, '0')}-'
        '${to.day.toString().padLeft(2, '0')}';

    final rows = await _client
        .from('orders')
        .select(
          'id, order_number, grand_total, created_at, '
          'shops(shop_name), salesmen(name)',
        )
        .eq('distributor_id', distributorId)
        .gte('order_date', fromStr)
        .lte('order_date', toStr)
        .order('created_at', ascending: false)
        .limit(50);

    return rows.map((row) {
      return AdminRecentOrder(
        id: row['id'] as String? ?? '',
        orderNumber: row['order_number'] as String? ?? '—',
        shopName: (row['shops'] as Map<String, dynamic>?)?['shop_name']
                as String? ??
            '—',
        salesmanName:
            (row['salesmen'] as Map<String, dynamic>?)?['name'] as String? ??
                '—',
        grandTotal: (row['grand_total'] as num).toDouble(),
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }).toList();
  }
}
