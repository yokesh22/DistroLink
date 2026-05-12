import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/admin/data/admin_dashboard_repository.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_providers.g.dart';

// ─── Filter model ─────────────────────────────────────────────────

enum ActivityFilterPreset { today, yesterday, custom }

class ActivityFilter {
  const ActivityFilter({
    required this.preset,
    required this.from,
    required this.to,
  });

  factory ActivityFilter.today() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return ActivityFilter(
      preset: ActivityFilterPreset.today,
      from: start,
      to: start,
    );
  }

  factory ActivityFilter.yesterday() {
    final now = DateTime.now();
    final d = DateTime(now.year, now.month, now.day - 1);
    return ActivityFilter(
      preset: ActivityFilterPreset.yesterday,
      from: d,
      to: d,
    );
  }

  factory ActivityFilter.custom(DateTime from, DateTime to) =>
      ActivityFilter(preset: ActivityFilterPreset.custom, from: from, to: to);

  final ActivityFilterPreset preset;
  final DateTime from;
  final DateTime to;

  String get label {
    switch (preset) {
      case ActivityFilterPreset.today:
        return 'Today';
      case ActivityFilterPreset.yesterday:
        return 'Yesterday';
      case ActivityFilterPreset.custom:
        final fmt = DateFormat('d MMM');
        return '${fmt.format(from)} – ${fmt.format(to)}';
    }
  }
}

// ─── Providers ────────────────────────────────────────────────────

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

@Riverpod(keepAlive: true)
class ActivityFilterNotifier extends _$ActivityFilterNotifier {
  @override
  ActivityFilter build() => ActivityFilter.today();

  void setToday() => state = ActivityFilter.today();
  void setYesterday() => state = ActivityFilter.yesterday();
  void setCustom(DateTime from, DateTime to) =>
      state = ActivityFilter.custom(from, to);
}

@riverpod
Future<List<AdminRecentOrder>> adminRecentActivity(Ref ref) async {
  final user = await ref.watch(currentAppUserProvider.future);
  final distributorId = user?.distributorId ?? '';
  final filter = ref.watch(activityFilterProvider);
  return ref
      .watch(adminDashboardRepositoryProvider)
      .recentActivity(distributorId, from: filter.from, to: filter.to);
}
