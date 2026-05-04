import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/admin/data/admin_dashboard_repository.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_providers.g.dart';

@riverpod
AdminDashboardRepository adminDashboardRepository(Ref ref) =>
    AdminDashboardRepository(ref.watch(supabaseClientProvider));

@riverpod
Future<AdminDashboardKpis> adminDashboardKpis(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  final distributorId = user?.distributorId ?? '';
  return ref
      .watch(adminDashboardRepositoryProvider)
      .fetchKpis(distributorId);
}

@riverpod
Future<List<AdminRecentOrder>> adminRecentActivity(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  final distributorId = user?.distributorId ?? '';
  return ref
      .watch(adminDashboardRepositoryProvider)
      .recentActivity(distributorId);
}
