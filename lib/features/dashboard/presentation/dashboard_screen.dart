import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/core/widgets/app_offline_banner.dart';
import 'package:distro_link/core/widgets/app_stat_card.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);
    final salesmanAsync = ref.watch(currentSalesmanProvider);
    final statsAsync = ref.watch(salesmanStatsProvider);
    final recentAsync = ref.watch(recentOrdersProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount = ref.watch(pendingSyncCountProvider).asData?.value ?? 0;

    // Pre-warm areas cache so they're available offline when starting an order.
    ref.listen(areasProvider, (_, _) {});

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!isOnline || pendingCount > 0)
              AppOfflineBanner(pendingCount: pendingCount),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref
                    ..invalidate(salesmanStatsProvider)
                    ..invalidate(recentOrdersProvider);
                },
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning 👋',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            userAsync.when(
                              data: (u) => Text(
                                u?.fullName ?? 'Salesman',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              loading: () => const SizedBox(
                                height: 28,
                                width: 120,
                                child: LinearProgressIndicator(),
                              ),
                              error: (_, _) => const Text('Hello'),
                            ),
                          ],
                        ),
                        salesmanAsync.when(
                          data: (s) => CircleAvatar(
                            radius: 22,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: Text(
                              s?.name.isNotEmpty == true
                                  ? s!.name[0].toUpperCase()
                                  : 'S',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          loading: () => const CircleAvatar(radius: 22),
                          error: (_, _) => const CircleAvatar(radius: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Stats grid ───────────────────────────────────
                    statsAsync.when(
                      data: (stats) => _StatsGrid(stats: stats),
                      loading: () => const _StatsGridSkeleton(),
                      error: (e, _) => Text('Error loading stats: $e'),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Start new order button ────────────────────────
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(orderDraftProvider.notifier).clear();
                        context.go('/orders/new/1');
                      },
                      icon: const Icon(Icons.add, size: 22),
                      label: const Text('Start New Order'),
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // ── Export report button ──────────────────────────
                    OutlinedButton.icon(
                      onPressed: isOnline
                          ? () => context.push(
                              '/settings/export',
                              extra: ExportFormat.excel,
                            )
                          : null,
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Export Report'),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Quick chips ───────────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AppChip(
                            label: '📋 Repeat Last',
                            onTap: () => context.go('/orders/new/1'),
                          ),
                          const SizedBox(width: 8),
                          const AppChip(label: '📍 Nearby Shops'),
                          const SizedBox(width: 8),
                          AppChip(
                            label: pendingCount > 0
                                ? '⏳ Pending ($pendingCount)'
                                : '⏳ Pending',
                            onTap: () => context.go('/orders'),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: AppSpacing.lg),

                    // ── Recent orders ─────────────────────────────────
                    Text(
                      'RECENT ORDERS',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    recentAsync.when(
                      data: (orders) => orders.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No orders yet today.'),
                            )
                          : Column(
                              children: orders
                                  .take(3)
                                  .map((o) => _OrderRow(order: o))
                                  .toList(),
                            ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final SalesmanStats stats;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final rev = stats.revenueToday >= 1000
        ? '₹${(stats.revenueToday / 1000).toStringAsFixed(0)}K'
        : fmt.format(stats.revenueToday);
    final hasPending = stats.pendingSync > 0;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Orders Today',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${stats.ordersToday}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const Text('📋', style: TextStyle(fontSize: 48)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AppStatCard(
                label: 'Revenue Today',
                value: rev,
                footnote: '↑ 8%',
                footnoteColor: AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppStatCard(
                label: 'Shops Visited',
                value: '${stats.shopsVisited}',
                footnote: 'of assigned',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AppStatCard(
                label: 'Pending Sync',
                value: '${stats.pendingSync}',
                footnote: hasPending ? '⚠ No internet' : '✓ All synced',
                footnoteColor: hasPending
                    ? const Color(0xFFB45309)
                    : AppColors.accent,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: AppStatCard(
                label: "Today's Target",
                value: '₹80K',
                footnote: '77% achieved',
                child: _ProgressBar(value: 0.77),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: value,
        backgroundColor: Theme.of(context).colorScheme.outline,
        valueColor: const AlwaysStoppedAnimation(AppColors.accent),
        minHeight: 4,
      ),
    );
  }
}

class _StatsGridSkeleton extends StatelessWidget {
  const _StatsGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () => context.push('/orders/${order.id}'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 2,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blueLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.storefront_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.shopName ?? 'Shop',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${order.orderNumber} · '
                  '${DateFormat('hh:mm a').format(order.createdAt.toLocal())}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${order.grandTotal.toStringAsFixed(0)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Synced',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
