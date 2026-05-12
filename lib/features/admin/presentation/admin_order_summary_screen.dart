import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/theme/app_typography.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/admin/application/admin_order_providers.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_item.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AdminOrderSummaryScreen extends ConsumerWidget {
  const AdminOrderSummaryScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(adminOrderDetailProvider(orderId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        actions: [
          orderAsync.maybeWhen(
            data: (_) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'Synced',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: orderAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Failed to load order.\n$e',
            textAlign: TextAlign.center,
          ),
        ),
        data: (owt) => _OrderSummaryBody(
          owt: owt,
          orderId: orderId,
        ),
      ),
    );
  }
}

class _OrderSummaryBody extends ConsumerWidget {
  const _OrderSummaryBody({
    required this.owt,
    required this.orderId,
  });

  final OrderWithItems owt;
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OrderHeaderCard(order: owt.order),
          const SizedBox(height: AppSpacing.sm),
          _ItemsSection(items: owt.items, currency: currency),
          const SizedBox(height: AppSpacing.xs),
          _TotalsSection(order: owt.order, currency: currency),
          const SizedBox(height: AppSpacing.md),
          _ExportSection(orderId: orderId),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.6,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
    );
    final valueStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ORDER ID', style: labelStyle),
          const SizedBox(height: 2),
          Text(order.orderNumber, style: valueStyle),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _InfoCell(
                  label: 'SHOP',
                  value: order.shopName ?? '—',
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
              ),
              Expanded(
                child: _InfoCell(
                  label: 'SALESMAN',
                  value: order.salesmanName ?? '—',
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _InfoCell(
                  label: 'DATE',
                  value: DateFormat('dd MMM, yyyy').format(order.orderDate),
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
              ),
              Expanded(
                child: _InfoCell(
                  label: 'TIME',
                  value: DateFormat('hh:mm a').format(order.createdAt),
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 2),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.items, required this.currency});
  final List<OrderItem> items;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sectionLabel = theme.textTheme.bodySmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    );
    final colHeader = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 11,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ITEMS · ${items.length}', style: sectionLabel),
        const SizedBox(height: AppSpacing.xs),
        AppCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text('ITEM', style: colHeader)),
                  SizedBox(
                    width: 36,
                    child: Text(
                      'QTY',
                      style: colHeader,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      'RATE',
                      style: colHeader,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    width: 64,
                    child: Text(
                      'TOTAL',
                      style: colHeader,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.sm),
              ...items.map((item) => _ItemRow(item: item, currency: currency)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.currency});
  final OrderItem item;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${item.itemCode} · GST ${item.gstPercent.toInt()}%',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '${item.quantity}',
              style: AppTypography.numeric(
                color: theme.colorScheme.onSurface,
                size: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              '₹${item.sellingRate.toStringAsFixed(0)}',
              style: AppTypography.numeric(
                color: theme.colorScheme.onSurface,
                size: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(
              '₹${item.lineTotal.toStringAsFixed(0)}',
              style: AppTypography.numeric(
                color: theme.colorScheme.onSurface,
                size: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalsSection extends StatelessWidget {
  const _TotalsSection({required this.order, required this.currency});
  final Order order;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: theme.textTheme.bodyMedium),
              Text(
                currency.format(order.subtotal),
                style: AppTypography.numeric(
                  color: theme.colorScheme.onSurface,
                  size: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  currency.format(order.grandTotal),
                  style: AppTypography.numeric(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportSection extends ConsumerWidget {
  const _ExportSection({required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState =
        ref.watch(singleOrderExportControllerProvider(orderId));
    final theme = Theme.of(context);
    final isGenerating = exportState.maybeWhen(
      generating: () => true,
      orElse: () => false,
    );
    final errorMessage = exportState.maybeWhen(
      error: (msg) => msg,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPORT',
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _ExportButton(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf_rounded,
                color: const Color(0xFFE53E3E),
                loading: isGenerating,
                onTap: isGenerating
                    ? null
                    : () => ref
                        .read(
                          singleOrderExportControllerProvider(orderId)
                              .notifier,
                        )
                        .export(ExportFormat.pdf),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _ExportButton(
                label: 'Export Excel',
                icon: Icons.table_chart_rounded,
                color: AppColors.accent,
                loading: isGenerating,
                onTap: isGenerating
                    ? null
                    : () => ref
                        .read(
                          singleOrderExportControllerProvider(orderId)
                              .notifier,
                        )
                        .export(ExportFormat.excel),
              ),
            ),
          ],
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              errorMessage,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.loading,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color color;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: color.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(AppSpacing.radiusButton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
