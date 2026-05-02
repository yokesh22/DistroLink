import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopsRepository {
  const ShopsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Shop>> listByArea(String areaId) async {
    debugPrint(
      'Shops query -> areaId: $areaId, '
      'userId: ${_client.auth.currentUser?.id}, '
      'hasSession: ${_client.auth.currentSession != null}',
    );
    final rows = await _client
        .from('shops')
        .select()
        .eq('area_id', areaId)
        .order('shop_name');
    debugPrint('Shops raw rows count for area $areaId: ${rows.length}');
    final shops = rows.map(Shop.fromJson).toList();
    debugPrint(
      'Fetched shops (${shops.length}) for area $areaId: '
      '${shops.map((s) => s.shopName).toList()}',
    );
    return shops;
  }

  /// Returns the last [limit] distinct shops ordered by the salesman's most
  /// recent order. Used for the "Recent Shops" shortcut on Step 1.
  Future<List<Shop>> recentForSalesman(
    String salesmanId, {
    int limit = 5,
  }) async {
    const shopFields =
        'id, area_id, shop_name, shop_number, shop_address, created_at';
    final rows = await _client
        .from('orders')
        .select('shop_id, created_at, shops!inner($shopFields)')
        .eq('salesman_id', salesmanId)
        .order('created_at', ascending: false)
        .limit(limit * 4); // overfetch to dedupe

    final seen = <String>{};
    final shops = <Shop>[];
    for (final row in rows) {
      final shopData = row['shops'] as Map<String, dynamic>;
      final shop = Shop.fromJson(shopData);
      if (seen.add(shop.id)) shops.add(shop);
      if (shops.length >= limit) break;
    }
    return shops;
  }
}
