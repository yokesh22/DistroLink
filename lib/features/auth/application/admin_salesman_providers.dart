import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/data/admin_salesmen_repository.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_salesman_providers.g.dart';

@riverpod
AdminSalesmenRepository adminSalesmenRepository(Ref ref) =>
    AdminSalesmenRepository(ref.watch(supabaseClientProvider));

@riverpod
Future<Map<String, int>> salesmanOrdersTodayMap(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  final distributorId = user?.distributorId ?? '';
  return ref
      .watch(adminSalesmenRepositoryProvider)
      .ordersTodayBySalesman(distributorId);
}

@riverpod
class AdminSalesmenList extends _$AdminSalesmenList {
  @override
  Future<List<Salesman>> build() async {
    final user = await ref.watch(currentAppUserProvider.future);
    final distributorId = user?.distributorId ?? '';
    return ref
        .watch(adminSalesmenRepositoryProvider)
        .list(distributorId);
  }

  Future<void> create({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final user = await ref.read(currentAppUserProvider.future);
    if (!ref.mounted) return;
    final distributorId = user?.distributorId ?? '';
    await ref.read(adminSalesmenRepositoryProvider).create(
          distributorId: distributorId,
          fullName: fullName,
          phone: phone,
          email: email,
          password: password,
        );
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }

  Future<void> updateSalesman({
    required String id,
    required String userId,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    await ref.read(adminSalesmenRepositoryProvider).update(
          id: id,
          userId: userId,
          fullName: fullName,
          phone: phone,
          email: email,
        );
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }

  Future<void> toggleActive({
    required String salesmanId,
    required String userId,
    required bool isActive,
  }) async {
    await ref.read(adminSalesmenRepositoryProvider).toggleActive(
          salesmanId: salesmanId,
          userId: userId,
          isActive: isActive,
        );
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  }) =>
      ref.read(adminSalesmenRepositoryProvider).resetPassword(
            userId: userId,
            newPassword: newPassword,
          );
}
