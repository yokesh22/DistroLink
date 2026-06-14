import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/services/hive/hive_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopsRepository {
  ShopsRepository(this._client, this._hive);

  final SupabaseClient _client;
  final HiveService _hive;

  Future<List<Shop>> listByArea(String distributorId, String areaId) async {
    final cached = _hive.shopsBox.values
        .where(
          (dynamic m) =>
              _field(m, 'area_id') == areaId &&
              _field(m, 'distributor_id') == distributorId,
        )
        .map(_toShop)
        .toList()
      ..sort((a, b) => a.shopName.compareTo(b.shopName));
    if (cached.isNotEmpty) {
      _revalidate(distributorId, areaId).ignore();
      return cached;
    }
    try {
      return await _revalidate(distributorId, areaId);
    } on Exception {
      throw Exception(
        'No internet connection and no cached shops available. '
        'Please connect to the internet and try again.',
      );
    }
  }

  Future<List<Shop>> _revalidate(String distributorId, String areaId) async {
    final rows = await _client
        .from('shops')
        .select()
        .eq('distributor_id', distributorId)
        .eq('area_id', areaId)
        .order('shop_name');
    final shops = rows.map(Shop.fromJson).toList();
    // Remove old entries for this area then insert fresh.
    final staleKeys = _hive.shopsBox.keys
        .where(
          (dynamic k) =>
              _field(_hive.shopsBox.get(k), 'area_id') == areaId,
        )
        .toList();
    await _hive.shopsBox.deleteAll(staleKeys);
    for (final shop in shops) {
      await _hive.shopsBox.put(shop.id, shop.toJson());
    }
    return shops;
  }

  /// Recent shops for Step 1 "Quick Select". Always online — joins orders.
  Future<List<Shop>> recentForSalesman(
    String salesmanId, {
    int limit = 5,
  }) async {
    const shopFields =
        'id, distributor_id, area_id, shop_name, shop_number, '
        'shop_address, created_at';
    final rows = await _client
        .from('orders')
        .select('shop_id, created_at, shops!inner($shopFields)')
        .eq('salesman_id', salesmanId)
        .order('created_at', ascending: false)
        .limit(limit * 4);

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

  Shop _toShop(dynamic raw) =>
      Shop.fromJson(Map<String, dynamic>.from(raw as Map));

  dynamic _field(dynamic raw, String key) =>
      (raw as Map<dynamic, dynamic>)[key];
}
