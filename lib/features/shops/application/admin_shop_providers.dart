import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/features/shops/data/admin_shops_repository.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_shop_providers.g.dart';

@riverpod
AdminShopsRepository adminShopsRepository(Ref ref) =>
    AdminShopsRepository(ref.watch(supabaseClientProvider));

@riverpod
class AdminShopsList extends _$AdminShopsList {
  @override
  Future<List<Shop>> build() async {
    final user = await ref.watch(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    return ref.watch(adminShopsRepositoryProvider).list(distributorId);
  }

  Future<void> create({
    required String areaId,
    required String shopName,
    required String shopAddress,
    String? shopNumber,
    String? shopOwner,
    String? phoneNo,
    String? gstin,
  }) async {
    final user = await ref.read(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    await ref.read(adminShopsRepositoryProvider).create(
          distributorId: distributorId,
          areaId: areaId,
          shopName: shopName,
          shopAddress: shopAddress,
          shopNumber: shopNumber,
          shopOwner: shopOwner,
          phoneNo: phoneNo,
          gstin: gstin,
        );
    ref
      ..invalidateSelf()
      ..invalidate(shopsByAreaProvider)
      ..invalidate(recentShopsProvider);
  }

  Future<void> updateShop({
    required String id,
    required String areaId,
    required String shopName,
    required String shopAddress,
    String? shopNumber,
    String? shopOwner,
    String? phoneNo,
    String? gstin,
  }) async {
    await ref.read(adminShopsRepositoryProvider).update(
          id: id,
          areaId: areaId,
          shopName: shopName,
          shopAddress: shopAddress,
          shopNumber: shopNumber,
          shopOwner: shopOwner,
          phoneNo: phoneNo,
          gstin: gstin,
        );
    ref
      ..invalidateSelf()
      ..invalidate(shopsByAreaProvider);
  }
}
