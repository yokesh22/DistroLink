import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/features/shops/data/admin_areas_repository.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_area_providers.g.dart';

@riverpod
AdminAreasRepository adminAreasRepository(Ref ref) =>
    AdminAreasRepository(ref.watch(supabaseClientProvider));

@riverpod
class AdminAreasList extends _$AdminAreasList {
  @override
  Future<List<Area>> build() async {
    final user = await ref.watch(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    return ref.watch(adminAreasRepositoryProvider).list(distributorId);
  }

  Future<Area> create(String name) async {
    final user = await ref.read(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    final area = await ref
        .read(adminAreasRepositoryProvider)
        .create(distributorId, name);
    ref
      ..invalidateSelf()
      ..invalidate(areasRepositoryProvider);
    return area;
  }

  Future<void> updateArea(String id, String name) async {
    await ref.read(adminAreasRepositoryProvider).update(id, name);
    ref
      ..invalidateSelf()
      ..invalidate(areasRepositoryProvider);
  }

  Future<void> delete(String id) async {
    await ref.read(adminAreasRepositoryProvider).delete(id);
    ref
      ..invalidateSelf()
      ..invalidate(areasRepositoryProvider);
  }
}
