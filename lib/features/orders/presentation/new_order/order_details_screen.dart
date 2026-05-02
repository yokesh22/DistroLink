import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_segmented.dart';
import 'package:distro_link/core/widgets/app_step_indicator.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/orders/domain/order_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  ConsumerState<OrderDetailsScreen> createState() =>
      _OrderDetailsScreenState();
}

class _OrderDetailsScreenState
    extends ConsumerState<OrderDetailsScreen> {
  late DateTime _deliveryDate;
  int _typeIndex = 0;
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deliveryDate =
        DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = ref.watch(orderDraftProvider);
    final now = DateTime.now();
    final dateFmt = DateFormat('EEE, dd MMM yyyy');
    final timeFmt = DateFormat('hh:mm a');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/orders/new/1'),
        ),
        title: const Text('Order Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '2 of 4',
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
          const AppStepIndicator(currentStep: 2),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                4,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
              ),
              children: [
                Text(
                  'Confirm Details',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Selected shop ─────────────────────────────────
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECTED SHOP',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedShopTitle(draft),
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _selectedShopSubtitle(draft),
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Auto-filled date/time ─────────────────────────
                _ReadOnlyField(
                  label: 'Order Date',
                  value: dateFmt.format(now),
                  badge: 'AUTO',
                ),
                const SizedBox(height: AppSpacing.sm),
                _ReadOnlyField(
                  label: 'Order Time',
                  value: timeFmt.format(now),
                  badge: 'AUTO',
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Delivery date ─────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _InputLabel('Delivery Date'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _deliveryDate,
                          firstDate: now,
                          lastDate: now.add(
                            const Duration(days: 30),
                          ),
                        );
                        if (picked != null) {
                          setState(() => _deliveryDate = picked);
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusInput),
                      child: InputDecorator(
                        decoration: const InputDecoration(),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateFmt.format(_deliveryDate)),
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Order type ────────────────────────────────────
                const _InputLabel('Order Type'),
                const SizedBox(height: 6),
                AppSegmented(
                  options:
                      OrderType.values.map((t) => t.label).toList(),
                  selectedIndex: _typeIndex,
                  onChanged: (i) =>
                      setState(() => _typeIndex = i),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Notes ─────────────────────────────────────────
                const _InputLabel('Notes (optional)'),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Add delivery note…',
                  ),
                ),
                const SizedBox(height: 6),
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
                    '💡 Date & time auto-set to now. '
                    'Most orders need 0 input here.',
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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Row(
              children: [
                AppButton(
                  label: '← Back',
                  variant: AppButtonVariant.secondary,
                  fullWidth: false,
                  onPressed: () => context.go('/orders/new/1'),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton(
                    label: 'Next: Add Items →',
                    onPressed: () {
                      ref
                          .read(
                            orderDraftProvider.notifier,
                          )
                          .setDetails(
                            deliveryDate: _deliveryDate,
                            orderType:
                                OrderType.values[_typeIndex],
                            notes: _notesCtrl.text,
                          );
                      context.go('/orders/new/3');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _selectedShopTitle(OrderDraftState draft) {
    final name = draft.shop?.shopName.trim();
    if (name == null || name.isEmpty) return 'Shop not selected';
    return name;
  }

  String _selectedShopSubtitle(OrderDraftState draft) {
    final shopNumber = draft.shop?.shopNumber.trim() ?? '';
    final areaName = draft.area?.name.trim() ?? '';
    if (shopNumber.isNotEmpty && areaName.isNotEmpty) {
      return '$shopNumber · $areaName';
    }
    if (shopNumber.isNotEmpty) return shopNumber;
    if (areaName.isNotEmpty) return areaName;
    return 'Select a shop in step 1';
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({
    required this.label,
    required this.value,
    this.badge,
  });

  final String label;
  final String value;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InputLabel(label),
        const SizedBox(height: 6),
        InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Theme.of(context)
                .colorScheme
                .onSurface
                .withValues(alpha: 0.5),
          ),
    );
  }
}
