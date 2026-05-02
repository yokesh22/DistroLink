import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/core/widgets/app_offline_banner.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/settings/application/settings_providers.dart';
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
    final isOffline = ref.watch(offlineSimProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline) const AppOfflineBanner(pendingCount: 2),
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
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                if (isOffline)
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
                                    child: const Text(
                                      '2 Pending Sync',
                                      style: TextStyle(
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
                    ordersAsync.when(
                      data: (orders) {
                        final filtered =
                            _filter(orders, isOffline);
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
                              padding:
                                  const EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'No orders found.',
                                  style: theme.textTheme
                                      .bodyMedium,
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
                                isOffline: isOffline && i < 2,
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

  List<Order> _filter(List<Order> orders, bool isOffline) {
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
    // Pending Sync — simulated when offline
    return isOffline ? orders.take(2).toList() : [];
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.isOffline});

  final Order order;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isOffline
              ? const Color(0xFFFDE68A)
              : theme.colorScheme.outline,
          width: isOffline ? 1.5 : 1,
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
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.shopName ?? 'Shop',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(
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
                      if (isOffline) ...[
                        const SizedBox(height: 4),
                        const Text(
                          '⚠ Saved offline · will sync when online',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
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
                        color: isOffline
                            ? AppColors.orangeLight
                            : AppColors.greenLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isOffline ? 'Pending' : 'Synced',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isOffline
                              ? const Color(0xFF92400E)
                              : AppColors.accent,
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
