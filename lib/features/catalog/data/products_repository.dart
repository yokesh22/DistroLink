import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/services/hive/hive_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsRepository {
  ProductsRepository(this._client, this._hive);

  final SupabaseClient _client;
  final HiveService _hive;

  Future<List<Product>> listActive(String distributorId) async {
    final cached = _hive.productsBox.values
        .where(
          (dynamic m) =>
              _field(m, 'distributor_id') == distributorId &&
              _field(m, 'is_active') == true,
        )
        .map(_toProduct)
        .toList()
      ..sort(
        (a, b) => a.itemName.compareTo(b.itemName),
      );
    if (cached.isNotEmpty) {
      _revalidate(distributorId).ignore();
      return cached;
    }
    return _revalidate(distributorId);
  }

  Future<List<Product>> searchByQuery(
    String distributorId,
    String query,
  ) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return listActive(distributorId);

    final cached = _hive.productsBox.values
        .where(
          (dynamic m) =>
              _field(m, 'distributor_id') == distributorId &&
              _field(m, 'is_active') == true,
        )
        .toList();

    if (cached.isNotEmpty) {
      return cached
          .where(
            (dynamic m) =>
                (_field(m, 'item_name') as String)
                    .toLowerCase()
                    .contains(q) ||
                (_field(m, 'item_code') as String)
                    .toLowerCase()
                    .contains(q),
          )
          .take(30)
          .map(_toProduct)
          .toList();
    }

    final rows = await _client
        .from('products')
        .select()
        .eq('distributor_id', distributorId)
        .eq('is_active', true)
        .or('item_name.ilike.%$q%,item_code.ilike.%$q%')
        .order('item_name')
        .limit(30);
    return rows.map(Product.fromJson).toList();
  }

  Future<List<Product>> _revalidate(String distributorId) async {
    final rows = await _client
        .from('products')
        .select()
        .eq('distributor_id', distributorId)
        .eq('is_active', true)
        .order('item_name');
    final products = rows.map(Product.fromJson).toList();
    final staleKeys = _hive.productsBox.keys
        .where(
          (dynamic k) =>
              _field(_hive.productsBox.get(k), 'distributor_id') ==
              distributorId,
        )
        .toList();
    await _hive.productsBox.deleteAll(staleKeys);
    for (final product in products) {
      await _hive.productsBox.put(product.id, product.toJson());
    }
    return products;
  }

  Product _toProduct(dynamic raw) =>
      Product.fromJson(Map<String, dynamic>.from(raw as Map));

  dynamic _field(dynamic raw, String key) =>
      (raw as Map<dynamic, dynamic>)[key];
}
