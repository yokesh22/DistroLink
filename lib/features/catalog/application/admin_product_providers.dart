import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/catalog/application/product_providers.dart';
import 'package:distro_link/features/catalog/data/admin_products_repository.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_providers.g.dart';

@riverpod
AdminProductsRepository adminProductsRepository(Ref ref) =>
    AdminProductsRepository(ref.watch(supabaseClientProvider));

@riverpod
class AdminProductsList extends _$AdminProductsList {
  @override
  Future<List<Product>> build() async {
    final user = await ref.watch(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    return ref
        .watch(adminProductsRepositoryProvider)
        .list(distributorId);
  }

  Future<void> create({
    required String itemCode,
    required String itemName,
    required double mrp,
    required double baseRate,
    required double gstPercent,
  }) async {
    final user = await ref.read(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    await ref.read(adminProductsRepositoryProvider).create(
          distributorId: distributorId,
          itemCode: itemCode,
          itemName: itemName,
          mrp: mrp,
          baseRate: baseRate,
          gstPercent: gstPercent,
        );
    ref
      ..invalidateSelf()
      ..invalidate(productsProvider);
  }

  Future<void> updateProduct({
    required String id,
    required String itemCode,
    required String itemName,
    required double mrp,
    required double baseRate,
    required double gstPercent,
    required bool isActive,
  }) async {
    await ref.read(adminProductsRepositoryProvider).update(
          id: id,
          itemCode: itemCode,
          itemName: itemName,
          mrp: mrp,
          baseRate: baseRate,
          gstPercent: gstPercent,
          isActive: isActive,
        );
    ref
      ..invalidateSelf()
      ..invalidate(productsProvider);
  }

  Future<void> toggleActive(String id, {required bool isActive}) async {
    await ref
        .read(adminProductsRepositoryProvider)
        .toggleActive(id, isActive: isActive);
    ref
      ..invalidateSelf()
      ..invalidate(productsProvider);
  }
}
