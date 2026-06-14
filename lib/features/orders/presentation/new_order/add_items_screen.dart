import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/core/widgets/app_qty_stepper.dart';
import 'package:distro_link/core/widgets/app_step_indicator.dart';
import 'package:distro_link/features/catalog/application/product_providers.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddItemsScreen extends ConsumerStatefulWidget {
  const AddItemsScreen({super.key});

  @override
  ConsumerState<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends ConsumerState<AddItemsScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = ref.watch(orderDraftProvider);
    final notifier = ref.read(orderDraftProvider.notifier);
    final productsAsync = _searchCtrl.text.isNotEmpty
        ? ref.watch(
            productSearchProvider(_searchCtrl.text),
          )
        : ref.watch(productsProvider);
    final lastItemsAsync = ref.watch(lastOrderItemNamesProvider);

    final hasInvalidRate = draft.items.any((i) => !i.isRateValid());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => context.go('/orders/new/2'),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/orders/new/2'),
          ),
          title: const Text('Add Items'),
          actions: [
            if (draft.items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${draft.items.length} items',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            const AppStepIndicator(currentStep: 3),

            // ── Search + scan/voice (Phase 2) ─────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                4,
                AppSpacing.screenPadding,
                20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Search item / code…',
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // const _IconBox(
                  //   icon: Icons.qr_code_scanner_rounded,
                  //   tooltip: 'Scan barcode (Phase 4)',
                  // ),
                  // const SizedBox(width: 8),
                  // const _IconBox(
                  //   icon: Icons.mic_rounded,
                  //   tooltip: 'Voice input (Phase 4)',
                  // ),
                ],
              ),
            ),

            // ── Quick Add chips ────────────────────────────────────
            lastItemsAsync.when(
              data: (names) => names.isEmpty
                  ? const SizedBox.shrink()
                  : _QuickAddSection(
                      names: names,
                      productsAsync: productsAsync,
                      onAdd: (name) {
                        productsAsync.whenData((products) {
                          final p = products.firstWhere(
                            (p) => p.itemName == name,
                            orElse: () => products.first,
                          );
                          notifier.addItem(DraftItem.fromProduct(p));
                        });
                      },
                    ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const Divider(height: 1),

            // ── Product search results ─────────────────────────────
            Expanded(
              child: productsAsync.when(
                data: (products) => products.isEmpty
                    ? Center(
                        child: Text(
                          'No products found.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, i) {
                          final p = products[i];
                          return ListTile(
                            title: Text(p.itemName),
                            subtitle: Text('${p.itemCode} · MRP ₹${p.mrp}'),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.add_circle_outline_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () =>
                                  notifier.addItem(DraftItem.fromProduct(p)),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),

            // ── Cart items ─────────────────────────────────────────
            // Only reserve space once at least one item is selected; until
            // then the product list above uses the full section.
            if (draft.items.isNotEmpty) ...[
              const Divider(height: 1),
              Expanded(
                flex: 2,
                child: ColoredBox(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    itemCount: draft.items.length,
                    itemBuilder: (_, i) => _ItemRow(
                      item: draft.items[i],
                      onQtyChanged: (qty) {
                        final delta = qty - draft.items[i].quantity;
                        notifier.changeQty(
                          draft.items[i].productId,
                          delta,
                        );
                      },
                      onRateChanged: (rate) => notifier.changeRate(
                        draft.items[i].productId,
                        rate,
                      ),
                      onRemove: () => notifier.removeItem(
                        draft.items[i].productId,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // ── Sticky footer ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${draft.items.length} items · Subtotal',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        '₹${draft.subtotal.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(
                    label: 'Next: Preview Bill →',
                    onPressed: draft.items.isNotEmpty && !hasInvalidRate
                        ? () => context.go('/orders/new/4')
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAddSection extends StatelessWidget {
  const _QuickAddSection({
    required this.names,
    required this.productsAsync,
    required this.onAdd,
  });

  final List<String> names;
  final AsyncValue<dynamic> productsAsync;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK ADD — LAST ORDER',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: names
                  .map(
                    (name) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: AppChip(
                        label: '+ $name',
                        active: true,
                        onTap: () => onAdd(name),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatefulWidget {
  const _ItemRow({
    required this.item,
    required this.onQtyChanged,
    required this.onRateChanged,
    required this.onRemove,
  });

  final DraftItem item;
  final ValueChanged<int> onQtyChanged;
  final ValueChanged<double> onRateChanged;
  final VoidCallback onRemove;

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  late final TextEditingController _rateCtrl;
  bool _editingRate = false;

  @override
  void initState() {
    super.initState();
    _rateCtrl = TextEditingController(
      text: widget.item.sellingRate.toStringAsFixed(0),
    );
  }

  @override
  void didUpdateWidget(_ItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editingRate &&
        oldWidget.item.sellingRate != widget.item.sellingRate) {
      _rateCtrl.text = widget.item.sellingRate.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final isRateInvalid = !item.isRateValid();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemCode,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      item.itemName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'MRP ₹${item.mrp.toStringAsFixed(0)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Base ₹${item.baseRate.toStringAsFixed(0)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (item.gstPercent > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                            child: Text(
                              'GST ${item.gstPercent.toStringAsFixed(0)}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Line total',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '₹${item.lineTotal.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (item.gstPercent > 0)
                    Text(
                      '+₹${item.gstAmount.toStringAsFixed(0)} GST',
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              AppQtyStepper(
                value: item.quantity,
                onChanged: widget.onQtyChanged,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selling Rate ₹',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _rateCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isRateInvalid
                            ? AppColors.error
                            : theme.colorScheme.primary,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isRateInvalid
                                ? AppColors.error
                                : theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                        fillColor: AppColors.blueLight,
                        filled: true,
                      ),
                      onTap: () => setState(() => _editingRate = true),
                      onChanged: (v) {
                        final parsed = double.tryParse(v);
                        if (parsed != null) {
                          widget.onRateChanged(parsed);
                        }
                      },
                      onSubmitted: (_) => setState(() => _editingRate = false),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                onPressed: widget.onRemove,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Rate range: ₹${item.baseRate.toStringAsFixed(0)}'
            ' – ₹${item.mrp.toStringAsFixed(0)} · Tap to edit',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const Divider(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.tooltip,
  });

  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
