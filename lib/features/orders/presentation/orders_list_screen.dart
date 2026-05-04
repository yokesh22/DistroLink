import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/core/widgets/app_offline_banner.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrdersListScreen extends ConsumerStatefulWidget {
  const OrdersListScreen({super.key});

  @override
  ConsumerState<OrdersListScreen> createState() =>
      _OrdersListScreenState();
}

class _OrdersListScreenState
    extends ConsumerState<OrdersListScreen> {
  final _searchCtrl = TextEditingController();
  int _filterIndex = 0; // 0=All 1=Today 2=This Week 3=Pending

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordersAsync = ref.watch(recentOrdersProvider);
    final outboxAsync = ref.watch(outboxOrdersProvider);
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount =
        ref.watch(pendingSyncCountProvider).asData?.value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!isOnline || pendingCount > 0)
              AppOfflineBanner(pendingCount: pendingCount),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    ref.invalidate(recentOrdersProvider),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppSpacing.screenPadding,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Orders',
                                  style: theme
                                      .textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (pendingCount > 0)
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.orangeLight,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '$pendingCount Pending Sync',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF92400E),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            TextField(
                              controller: _searchCtrl,
                              decoration: const InputDecoration(
                                hintText:
                                    'Search by shop or order #…',
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  'All',
                                  'Today',
                                  'This Week',
                                  'Pending Sync',
                                ]
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => Padding(
                                        padding:
                                            const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: AppChip(
                                          label: e.value,
                                          active: _filterIndex ==
                                              e.key,
                                          onTap: () => setState(
                                            () => _filterIndex =
                                                e.key,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Pending Sync filter shows outbox list ─────
                    if (_filterIndex == 3)
                      outboxAsync.when(
                        data: (outbox) {
                          if (outbox.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Text(
                                    'No pending orders.',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.screenPadding,
                                  0,
                                  AppSpacing.screenPadding,
                                  AppSpacing.xs,
                                ),
                                child: _OutboxOrderCard(
                                  entry: outbox[i],
                                ),
                              ),
                              childCount: outbox.length,
                            ),
                          );
                        },
                        loading: () => const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        error: (e, _) => SliverToBoxAdapter(
                          child: Center(child: Text('Error: $e')),
                        ),
                      )
                    else
                      // ── All / Today / This Week ─────────────────
                      ordersAsync.when(
                        data: (orders) {
                          final filtered = _filter(orders);
                          final q = _searchCtrl.text
                              .trim()
                              .toLowerCase();
                          final searched = q.isEmpty
                              ? filtered
                              : filtered
                                  .where(
                                    (o) =>
                                        (o.shopName ?? '')
                                            .toLowerCase()
                                            .contains(q) ||
                                        o.orderNumber
                                            .toLowerCase()
                                            .contains(q),
                                  )
                                  .toList();

                          if (searched.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Text(
                                    'No orders found.',
                                    style:
                                        theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppSpacing.screenPadding,
                                  0,
                                  AppSpacing.screenPadding,
                                  AppSpacing.xs,
                                ),
                                child: _OrderCard(
                                  order: searched[i],
                                ),
                              ),
                              childCount: searched.length,
                            ),
                          );
                        },
                        loading: () => const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                        error: (e, _) => SliverToBoxAdapter(
                          child: Center(child: Text('Error: $e')),
                        ),
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

  List<Order> _filter(List<Order> orders) {
    if (_filterIndex == 0) return orders;
    final now = DateTime.now();
    if (_filterIndex == 1) {
      return orders
          .where(
            (o) =>
                o.orderDate.year == now.year &&
                o.orderDate.month == now.month &&
                o.orderDate.day == now.day,
          )
          .toList();
    }
    if (_filterIndex == 2) {
      final weekAgo = now.subtract(const Duration(days: 7));
      return orders
          .where((o) => o.orderDate.isAfter(weekAgo))
          .toList();
    }
    return orders;
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.shopName ?? 'Shop',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.orderNumber} · '
                    '${DateFormat('dd MMM').format(order.orderDate)}',
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
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
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
      ),
    );
  }
}

class _OutboxOrderCard extends StatelessWidget {
  const _OutboxOrderCard({required this.entry});

  final OutboxOrder entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFailed = entry.status == OutboxStatus.failed;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isFailed
              ? const Color(0xFFFCA5A5)
              : const Color(0xFFFDE68A),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.shopName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${entry.orderNumber} · ${entry.orderDate}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isFailed
                            ? '✗ Sync failed · will retry'
                            : '⚠ Saved offline · will sync when online',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isFailed
                              ? const Color(0xFFB91C1C)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${entry.grandTotal.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isFailed
                            ? const Color(0xFFFEE2E2)
                            : AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isFailed ? 'Failed' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isFailed
                              ? const Color(0xFFB91C1C)
                              : const Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
