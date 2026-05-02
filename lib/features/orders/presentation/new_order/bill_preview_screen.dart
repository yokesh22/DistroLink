import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_step_indicator.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BillPreviewScreen extends ConsumerStatefulWidget {
  const BillPreviewScreen({super.key});

  @override
  ConsumerState<BillPreviewScreen> createState() =>
      _BillPreviewScreenState();
}

class _BillPreviewScreenState
    extends ConsumerState<BillPreviewScreen> {
  bool _submitting = false;

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    try {
      final draft = ref.read(orderDraftProvider);
      final user =
          await ref.read(currentAppUserProvider.future);
      final salesman =
          await ref.read(currentSalesmanProvider.future);

      if (user == null || salesman == null) {
        throw Exception('Not authenticated');
      }

      await ref.read(ordersRepositoryProvider).submit(
            draft: draft,
            salesmanId: salesman.id,
            distributorId: user.distributorId,
          );

      ref.read(orderDraftProvider.notifier).clear();
      ref
        ..invalidate(recentOrdersProvider)
        ..invalidate(salesmanStatsProvider)
        ..invalidate(recentShopsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order saved successfully!')),
        );
        context.go('/home');
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save order: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = ref.watch(orderDraftProvider);
    final fmt = DateFormat('EEE, dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/orders/new/3'),
        ),
        title: const Text('Bill Preview'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '4 of 4',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const AppStepIndicator(currentStep: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                // ── Order header ──────────────────────────────────
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER FOR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        draft.shop?.shopName ?? '—',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${draft.shop?.shopNumber ?? ''} · '
                        '${draft.area?.name ?? ''} · '
                        '${fmt.format(DateTime.now())}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Column headers ────────────────────────────────
                Text(
                  'ITEMS',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const _TableHeader(),
                ...draft.items.map((item) => _ItemLine(item: item)),

                const Divider(height: AppSpacing.md),

                // ── Totals ────────────────────────────────────────
                _TotalRow(
                  label: 'Subtotal',
                  value: '₹${draft.subtotal.toStringAsFixed(0)}',
                ),
                ..._buildGstRows(draft),
                const SizedBox(height: AppSpacing.sm),

                // ── Grand total ───────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '₹${draft.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                    border: Border.all(
                        color: const Color(0xFFFDE68A)),
                  ),
                  child: const Text(
                    '💡 Order saved locally if offline. '
                    'Syncs automatically when internet returns.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Action buttons ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                AppButton(
                  label: '✓ Confirm & Save Order',
                  loading: _submitting,
                  onPressed: _confirm,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: '← Edit Items',
                        variant: AppButtonVariant.secondary,
                        onPressed: () =>
                            context.go('/orders/new/3'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: AppButton(
                        label: '📤 WhatsApp',
                        variant: AppButtonVariant.secondary,
                        onPressed: null, // Phase 5
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGstRows(OrderDraftState draft) {
    final rows = <Widget>[];
    var totalCgst = 0;
    var totalSgst = 0;
    for (final item in draft.items) {
      if (item.gstPercent > 0) {
        totalCgst += item.cgst;
        totalSgst += item.sgst;
      }
    }
    if (totalCgst > 0) {
      rows
        ..add(_TotalRow(label: 'CGST', value: '₹$totalCgst'))
        ..add(_TotalRow(label: 'SGST', value: '₹$totalSgst'));
    }
    return rows;
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
    final color = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.5);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'ITEM',
              style: style.copyWith(color: color),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              'QTY',
              style: style.copyWith(color: color),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Text(
              'RATE',
              style: style.copyWith(color: color),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 64,
            child: Text(
              'TOTAL',
              style: style.copyWith(color: color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({required this.item});

  final DraftItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.itemName,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '${item.quantity}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: Text(
                  '₹${item.sellingRate.toStringAsFixed(0)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 64,
                child: Text(
                  '₹${item.lineTotal.toStringAsFixed(0)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        if (item.gstPercent > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'GST ${item.gstPercent.toStringAsFixed(0)}% → '
                'CGST ₹${item.cgst} + SGST ₹${item.sgst}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
