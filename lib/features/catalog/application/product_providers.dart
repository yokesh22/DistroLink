import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/catalog/data/products_repository.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/services/hive/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

@riverpod
Future<ProductsRepository> productsRepository(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final hive = await ref.watch(hiveServiceProvider.future);
  return ProductsRepository(client, hive);
}

@riverpod
Future<List<Product>> products(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null) return [];
  final repo = await ref.watch(productsRepositoryProvider.future);
  return repo.listActive(user.distributorId);
}

@riverpod
Future<List<Product>> productSearch(Ref ref, String query) async {
  final user = await ref.watch(currentAppUserProvider.future);
  if (user == null) return [];
  final repo = await ref.watch(productsRepositoryProvider.future);
  return repo.searchByQuery(user.distributorId, query);
}
