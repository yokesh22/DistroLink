import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminProductsRepository {
  const AdminProductsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Product>> list(String distributorId) async {
    final rows = await _client
        .from('products')
        .select()
        .eq('distributor_id', distributorId)
        .order('item_name');
    return rows.map(Product.fromJson).toList();
  }

  Future<Product> create({
    required String distributorId,
    required String itemCode,
    required String itemName,
    required double mrp,
    required double baseRate,
    required double gstPercent,
  }) async {
    final row = await _client
        .from('products')
        .insert({
          'distributor_id': distributorId,
          'item_code': itemCode.trim(),
          'item_name': itemName.trim(),
          'mrp': mrp,
          'base_rate': baseRate,
          'gst_percent': gstPercent,
          'is_active': true,
        })
        .select()
        .single();
    return Product.fromJson(row);
  }

  Future<Product> update({
    required String id,
    required String itemCode,
    required String itemName,
    required double mrp,
    required double baseRate,
    required double gstPercent,
    required bool isActive,
  }) async {
    final row = await _client
        .from('products')
        .update({
          'item_code': itemCode.trim(),
          'item_name': itemName.trim(),
          'mrp': mrp,
          'base_rate': baseRate,
          'gst_percent': gstPercent,
          'is_active': isActive,
        })
        .eq('id', id)
        .select()
        .single();
    return Product.fromJson(row);
  }

  Future<void> toggleActive(String id, {required bool isActive}) =>
      _client
          .from('products')
          .update({'is_active': isActive})
          .eq('id', id);

  /// Returns the next item code in the M1, M2, M3… series.
  Future<String> nextItemCode(String distributorId) async {
    final rows = await _client
        .from('products')
        .select('item_code')
        .eq('distributor_id', distributorId);

    final pattern = RegExp(r'^M(\d+)$', caseSensitive: false);
    var max = 0;
    for (final row in rows) {
      final code = (row['item_code'] as String?) ?? '';
      final match = pattern.firstMatch(code);
      if (match != null) {
        final n = int.tryParse(match.group(1)!) ?? 0;
        if (n > max) max = n;
      }
    }
    return 'M${max + 1}';
  }
}
