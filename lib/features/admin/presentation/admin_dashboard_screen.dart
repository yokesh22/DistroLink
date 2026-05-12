import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
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
    final filter = ref.watch(activityFilterProvider);
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
              // ── Header ───────────────────────────────────────────
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

              // ── KPI grid ─────────────────────────────────────────
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

              // ── Recent Activity header + filter ───────────────────
              Row(
                children: [
                  Text(
                    'RECENT ACTIVITY',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  _FilterButton(filter: filter),
                ],
              ),

              // ── Date range subtitle (non-today filters) ───────────
              if (filter.preset != ActivityFilterPreset.today) ...[
                const SizedBox(height: 6),
                activityAsync.maybeWhen(
                  data: (orders) => _RangeSubtitle(
                    count: orders.length,
                    filter: filter,
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],

              const SizedBox(height: AppSpacing.xs),

              // ── Activity list ─────────────────────────────────────
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
                            'No orders for this period.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      )
                    : Column(
                        children: orders
                            .map(
                              (o) => _ActivityRow(
                                order: o,
                                fmt: fmt,
                                orderId: o.id,
                              ),
                            )
                            .toList(),
                      ),
              ),

              // ── Hint banner ───────────────────────────────────────
              const SizedBox(height: AppSpacing.xs),
              _HintBanner(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Filter button + dropdown ─────────────────────────────────────

class _FilterButton extends ConsumerWidget {
  const _FilterButton({required this.filter});
  final ActivityFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return PopupMenuButton<_FilterChoice>(
      onSelected: (choice) async {
        if (choice == _FilterChoice.custom) {
          await _showCustomRangeSheet(context, ref);
        } else if (choice == _FilterChoice.today) {
          ref
              .read(activityFilterProvider.notifier)
              .setToday();
        } else {
          ref
              .read(activityFilterProvider.notifier)
              .setYesterday();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _FilterChoice.today,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today'),
              if (filter.preset == ActivityFilterPreset.today)
                const Icon(Icons.check, size: 16, color: AppColors.primary),
            ],
          ),
        ),
        PopupMenuItem(
          value: _FilterChoice.yesterday,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Yesterday'),
              if (filter.preset == ActivityFilterPreset.yesterday)
                const Icon(Icons.check, size: 16, color: AppColors.primary),
            ],
          ),
        ),
        const PopupMenuItem(
          value: _FilterChoice.custom,
          child: Text('Custom range...'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              size: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              filter.label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCustomRangeSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final current = ref.read(activityFilterProvider);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CustomRangeSheet(
        initialFrom: current.from,
        initialTo: current.to,
        onApply: (from, to) {
          ref
              .read(activityFilterProvider.notifier)
              .setCustom(from, to);
        },
      ),
    );
  }
}

enum _FilterChoice { today, yesterday, custom }

// ─── Range subtitle ───────────────────────────────────────────────

class _RangeSubtitle extends StatelessWidget {
  const _RangeSubtitle({required this.count, required this.filter});
  final int count;
  final ActivityFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayFmt = DateFormat('d MMM');
    return Row(
      children: [
        Text(
          'Showing $count ${count == 1 ? 'order' : 'orders'} between',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(width: 6),
        _DatePill(label: dayFmt.format(filter.from)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        _DatePill(label: dayFmt.format(filter.to)),
      ],
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

// ─── Hint banner ──────────────────────────────────────────────────

class _HintBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Text('💡', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tap any order to open its summary with PDF / Excel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom date range bottom sheet ──────────────────────────────

class _CustomRangeSheet extends StatefulWidget {
  const _CustomRangeSheet({
    required this.initialFrom,
    required this.initialTo,
    required this.onApply,
  });
  final DateTime initialFrom;
  final DateTime initialTo;
  final void Function(DateTime from, DateTime to) onApply;

  @override
  State<_CustomRangeSheet> createState() => _CustomRangeSheetState();
}

class _CustomRangeSheetState extends State<_CustomRangeSheet> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _from : _to,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_to.isBefore(_from)) _to = _from;
      } else {
        _to = picked;
        if (_from.isAfter(_to)) _from = _to;
      }
    });
  }

  void _applyQuick({required int days}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _to = today;
      _from = today.subtract(Duration(days: days - 1));
    });
  }

  void _applyThisMonth() {
    final now = DateTime.now();
    setState(() {
      _from = DateTime(now.year, now.month);
      _to = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFmt = DateFormat('MM/dd/yyyy');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              'Custom date range',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Pick a From and To date to filter recent orders.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),

            // From date
            Text(
              'From',
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            _DateField(
              value: dateFmt.format(_from),
              onTap: () => _pickDate(isFrom: true),
            ),
            const SizedBox(height: AppSpacing.xs),

            // To date
            Text(
              'To',
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            _DateField(
              value: dateFmt.format(_to),
              onTap: () => _pickDate(isFrom: false),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Quick chips
            Row(
              children: [
                _QuickChip(
                  label: 'Last 7d',
                  onTap: () => _applyQuick(days: 7),
                ),
                const SizedBox(width: 8),
                _QuickChip(
                  label: 'Last 30d',
                  onTap: () => _applyQuick(days: 30),
                ),
                const SizedBox(width: 8),
                _QuickChip(
                  label: 'This month',
                  onTap: _applyThisMonth,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Cancel',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    label: 'Apply',
                    onPressed: () {
                      widget.onApply(_from, _to);
                      Navigator.of(context).pop();
                    },
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

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onTap});
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: theme.textTheme.bodyMedium),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// ─── Activity row ─────────────────────────────────────────────────

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.order,
    required this.fmt,
    required this.orderId,
  });
  final AdminRecentOrder order;
  final NumberFormat fmt;
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: AppCard(
        onTap: () => context.push('/admin/orders/$orderId'),
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
