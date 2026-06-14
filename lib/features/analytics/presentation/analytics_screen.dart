import 'dart:math' as math;

import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/core/widgets/app_stat_card.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() =>
      _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final analyticsAsync = ref.watch(
      analyticsDataProvider(year: _year, month: _month),
    );
    final topAsync = ref.watch(topProductsProvider);
    final monthLabel =
        DateFormat('MMM yyyy').format(DateTime(_year, _month));

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(analyticsDataProvider)
              ..invalidate(topProductsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Analytics',
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  AppChip(
                    label: '$monthLabel ▾',
                    onTap: _pickMonth,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Stats grid ─────────────────────────────────────
              analyticsAsync.when(
                data: (data) => _AnalyticsGrid(data: data),
                loading: () => const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) =>
                    Center(child: Text('Error: $e')),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Weekly bar chart ───────────────────────────────
              Text(
                'REVENUE — LAST 7 DAYS',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              analyticsAsync.when(
                data: (data) =>
                    _WeeklyBarChart(dailyRevenue: data.dailyRevenue),
                loading: () => const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Top products ───────────────────────────────────
              Text(
                'TOP PRODUCTS',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              topAsync.when(
                data: (products) => products.isEmpty
                    ? const Text('No data yet.')
                    : Column(
                        children: products
                            .asMap()
                            .entries
                            .map(
                              (e) => _TopProductRow(
                                rank: e.key + 1,
                                product: e.value,
                              ),
                            )
                            .toList(),
                      ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Error: $e')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMonth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_year, _month),
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      helpText: 'Select month',
    );
    if (picked != null) {
      setState(() {
        _year = picked.year;
        _month = picked.month;
      });
    }
  }
}

class _AnalyticsGrid extends StatelessWidget {
  const _AnalyticsGrid({required this.data});

  final AnalyticsData data;

  @override
  Widget build(BuildContext context) {
    final rev = data.revenue >= 1000
        ? '₹${(data.revenue / 1000).toStringAsFixed(0)}K'
        : '₹${data.revenue.toStringAsFixed(0)}';

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        AppStatCard(
          label: 'Revenue',
          value: rev,
          footnoteColor: AppColors.accent,
        ),
        AppStatCard(
          label: 'Order Count',
          value: '${data.orderCount}',
          footnoteColor: Theme.of(context).colorScheme.primary,
        ),
        AppStatCard(
          label: 'Avg Order Value',
          value: '₹${data.avgOrderValue.toStringAsFixed(0)}',
        ),
        AppStatCard(
          label: 'Shops Visited',
          value: '${data.shopsVisited}',
          footnoteColor: AppColors.warning,
        ),
      ],
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart({required this.dailyRevenue});

  final Map<String, double> dailyRevenue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final d = now.subtract(Duration(days: 6 - i));
      return d;
    });
    final values = days.map((d) {
      final mm = d.month.toString().padLeft(2, '0');
      final dd = d.day.toString().padLeft(2, '0');
      final key = '${d.year}-$mm-$dd';
      return dailyRevenue[key] ?? 0.0;
    }).toList();
    final maxVal = values.reduce(math.max);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.asMap().entries.map((e) {
                final i = e.key;
                final isToday = i == 6;
                final height = maxVal > 0
                    ? (values[i] / maxVal) * 80
                    : 4.0;
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: math.max(height, 4),
                      decoration: BoxDecoration(
                        color: isToday
                            ? theme.colorScheme.primary
                            : AppColors.blueMid,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: days.asMap().entries.map((e) {
              final isToday = e.key == 6;
              return Expanded(
                child: Text(
                  DateFormat('E').format(e.value)[0],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isToday
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  const _TopProductRow({
    required this.rank,
    required this.product,
  });

  final int rank;
  final TopProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: rank == 1
                    ? Colors.white
                    : theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.itemName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${product.totalUnits} units',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '₹${product.totalRevenue.toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
