import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/catalog/data/products_repository.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

@riverpod
ProductsRepository productsRepository(Ref ref) =>
    ProductsRepository(ref.watch(supabaseClientProvider));

@riverpod
Future<List<Product>> products(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null) return [];
  return ref
      .watch(productsRepositoryProvider)
      .listActive(user.distributorId);
}

@riverpod
Future<List<Product>> productSearch(Ref ref, String query) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null) return [];
  return ref
      .watch(productsRepositoryProvider)
      .searchByQuery(user.distributorId, query);
}
