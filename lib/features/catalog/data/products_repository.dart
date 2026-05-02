import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsRepository {
  const ProductsRepository(this._client);
  final SupabaseClient _client;

  Future<List<Product>> listActive(String distributorId) async {
    final rows = await _client
        .from('products')
        .select()
        .eq('distributor_id', distributorId)
        .eq('is_active', true)
        .order('item_name');
    return rows.map(Product.fromJson).toList();
  }

  Future<List<Product>> searchByQuery(
    String distributorId,
    String query,
  ) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return listActive(distributorId);
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
}
