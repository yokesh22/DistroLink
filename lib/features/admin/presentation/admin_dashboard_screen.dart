import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_stat_card.dart';
import 'package:distro_link/features/admin/application/admin_dashboard_providers.dart';
import 'package:distro_link/features/admin/data/admin_dashboard_repository.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentAppUserProvider);
    final kpisAsync = ref.watch(adminDashboardKpisProvider);
    final activityAsync = ref.watch(adminRecentActivityProvider);
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(adminDashboardKpisProvider)
              ..invalidate(adminRecentActivityProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          userAsync.asData?.value?.fullName ?? 'Admin',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<_AdminAction>(
                    onSelected: (action) async {
                      if (action == _AdminAction.logout) {
                        await ref
                            .read(authRepositoryProvider)
                            .signOut();
                        if (context.mounted) context.go('/login');
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: _AdminAction.logout,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 18,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.blueLight,
                      child: Text(
                        (userAsync.asData?.value?.fullName ?? 'A')
                            .characters
                            .first
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // KPI grid
              kpisAsync.when(
                loading: () => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Failed to load stats: $e'),
                data: (kpis) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppStatCard(
                            label: 'Salesmen',
                            value: kpis.totalSalesmen.toString(),
                            valueColor: AppColors.primary,
                            backgroundColor: AppColors.blueLight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppStatCard(
                            label: 'Shops',
                            value: kpis.totalShops.toString(),
                            valueColor: AppColors.accent,
                            backgroundColor: AppColors.greenLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: AppStatCard(
                            label: 'Products',
                            value: kpis.totalProducts.toString(),
                            valueColor: AppColors.warning,
                            backgroundColor: AppColors.orangeLight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppStatCard(
                            label: 'Orders Today',
                            value: kpis.ordersToday.toString(),
                            valueColor: AppColors.primary,
                            backgroundColor: AppColors.blueLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: AppStatCard(
                            label: 'Revenue Today',
                            value: fmt.format(kpis.revenueToday),
                            valueColor: AppColors.accent,
                            backgroundColor: AppColors.greenLight,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppStatCard(
                            label: 'This Month',
                            value: kpis.ordersThisMonth.toString(),
                            footnote: 'orders',
                            valueColor: AppColors.warning,
                            backgroundColor: AppColors.orangeLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.md),
              Text(
                'RECENT ACTIVITY',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),

              activityAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Failed to load activity: $e'),
                data: (orders) => orders.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: Center(
                          child: Text(
                            'No orders yet.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                    : Column(
                        children: orders
                            .map((o) => _ActivityRow(order: o, fmt: fmt))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.order, required this.fmt});
  final AdminRecentOrder order;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderNumber,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${order.shopName} · ${order.salesmanName}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fmt.format(order.grandTotal),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
                Text(
                  DateFormat('dd MMM, hh:mm a').format(order.createdAt),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _AdminAction { logout }
