import 'dart:async';

import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/utils/money.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
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

    // Fast lookup so each product row can show its current cart quantity.
    final cartById = {for (final it in draft.items) it.productId: it};

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
        body: GestureDetector(
          // Tapping outside the search field force-dismisses the keyboard.
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
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
                            final inCart = cartById[p.id];
                            return ListTile(
                              title: Text(p.itemName),
                              subtitle: Text(
                                inCart != null
                                    ? '${p.itemCode} · MRP ₹${p.mrp} · in cart'
                                    : '${p.itemCode} · MRP ₹${p.mrp}',
                              ),
                              trailing: inCart != null
                                  ? AppQtyStepper(
                                      value: inCart.quantity,
                                      onChanged: (qty) => notifier.changeQty(
                                        p.id,
                                        qty - inCart.quantity,
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      onPressed: () => notifier.addItem(
                                        DraftItem.fromProduct(p),
                                      ),
                                    ),
                            );
                          },
                        ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),

              // ── Bottom cart bar (opens the cart sheet) ─────────────
              // The cart no longer competes for body space — it lives behind
              // this bar so the product list/search gets the full screen.
              _CartBar(
                itemCount: draft.items.length,
                subtotal: draft.subtotal,
                onTap: () => _showCartSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCartSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusCard),
          ),
        ),
        builder: (_) => const _CartSheet(),
      ),
    );
  }
}

class _CartSheet extends ConsumerWidget {
  const _CartSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final draft = ref.watch(orderDraftProvider);
    final notifier = ref.read(orderDraftProvider.notifier);
    final hasInvalidRate = draft.items
        .any((i) => !i.isRateValid() || !i.isDiscountValid());

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // ── Header: "YOUR CART / N items" + circular close ─────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR CART',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${draft.items.length} items',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Circular grey close button.
                  Material(
                    color: theme.colorScheme.surface,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.close_rounded,
                          size: 22,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Cart items (or empty state) ────────────────────────
            Expanded(
              child: draft.items.isEmpty
                  ? Center(
                      child: Text(
                        'Your cart is empty.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ColoredBox(
                      color: theme.colorScheme.primary.withValues(alpha: 0.05),
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          AppSpacing.sm,
                          AppSpacing.screenPadding,
                          AppSpacing.sm,
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
                          onDiscountChanged: (pct) => notifier.changeDiscount(
                            draft.items[i].productId,
                            pct,
                          ),
                          onFreeQtyChanged: (qty) => notifier.changeFreeQty(
                            draft.items[i].productId,
                            qty,
                          ),
                          onRemove: () => notifier.removeItem(
                            draft.items[i].productId,
                          ),
                        ),
                      ),
                    ),
            ),

            // ── Sticky footer inside the sheet ─────────────────────
            Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline),
                ),
              ),
              child: SafeArea(
                top: false,
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
                          formatMoney(draft.subtotal),
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
                          ? () {
                              Navigator.of(context).pop();
                              context.go('/orders/new/4');
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CartBar extends StatefulWidget {
  const _CartBar({
    required this.itemCount,
    required this.subtotal,
    required this.onTap,
  });

  final int itemCount;
  final double subtotal;
  final VoidCallback onTap;

  @override
  State<_CartBar> createState() => _CartBarState();
}

class _CartBarState extends State<_CartBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    // A brief blink so even non-tech users notice an item went into the cart.
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.06), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(_CartBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > oldWidget.itemCount) {
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Empty state: a muted, non-tappable bar keeps the footprint stable.
    if (widget.itemCount == 0) {
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: theme.colorScheme.outline)),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: Text(
              'No items yet — tap + to add',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: widget.onTap,
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: const Icon(
                      Icons.shopping_cart_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '${widget.itemCount} items '
                      '· ${formatMoney(widget.subtotal)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'View Cart →',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
    required this.onDiscountChanged,
    required this.onFreeQtyChanged,
    required this.onRemove,
  });

  final DraftItem item;
  final ValueChanged<int> onQtyChanged;
  final ValueChanged<double> onRateChanged;
  final ValueChanged<double> onDiscountChanged;
  final ValueChanged<int> onFreeQtyChanged;
  final VoidCallback onRemove;

  @override
  State<_ItemRow> createState() => _ItemRowState();
}

class _ItemRowState extends State<_ItemRow> {
  late final TextEditingController _rateCtrl;
  late final TextEditingController _discountCtrl;
  final FocusNode _rateFocus = FocusNode();
  bool _editingRate = false;
  bool _editingDiscount = false;

  static String _fmtPct(double v) =>
      v == v.truncateToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  void initState() {
    super.initState();
    _rateCtrl = TextEditingController(
      text: widget.item.sellingRate.toStringAsFixed(2),
    );
    _discountCtrl = TextEditingController(
      text: _fmtPct(widget.item.discountPercent),
    );
  }

  /// Focus the rate field and select its contents so the salesman can type
  /// over the value immediately — the "EDIT" affordance from the design.
  void _focusRate() {
    setState(() => _editingRate = true);
    _rateFocus.requestFocus();
    _rateCtrl.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _rateCtrl.text.length,
    );
  }

  @override
  void didUpdateWidget(_ItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editingRate &&
        oldWidget.item.sellingRate != widget.item.sellingRate) {
      _rateCtrl.text = widget.item.sellingRate.toStringAsFixed(2);
    }
    if (!_editingDiscount &&
        oldWidget.item.discountPercent != widget.item.discountPercent) {
      _discountCtrl.text = _fmtPct(widget.item.discountPercent);
    }
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    _discountCtrl.dispose();
    _rateFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final isRateInvalid = !item.isRateValid();
    final isDiscountInvalid = !item.isDiscountValid();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: badge + name + meta | line total + remove ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item-code pill badge.
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.itemCode,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.itemName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'MRP ${formatMoney(item.mrp)}'
                              ' · Base ${formatMoney(item.baseRate)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
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
                const SizedBox(width: 8),
                // Line total — small remove X sits above it.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: widget.onRemove,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'LINE TOTAL',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      formatMoney(item.lineTotal),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (item.gstPercent > 0)
                      Text(
                        '+${formatMoney(item.gstAmount)} GST',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const Divider(height: AppSpacing.md),
            // ── Quantity ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUANTITY',
                style: _fieldLabelStyle(theme),
              ),
              AppQtyStepper(
                value: item.quantity,
                onChanged: widget.onQtyChanged,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // ── Selling rate ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('SELLING RATE', style: _fieldLabelStyle(theme)),
              ),
              Text(
                'Range ${formatMoney(item.baseRate)}'
                ' – ${formatMoney(item.mrp)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Full-width rate field: ₹ prefix · value · tap-to-focus EDIT.
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isRateInvalid
                    ? AppColors.error
                    : theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  '₹',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _rateCtrl,
                    focusNode: _rateFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isRateInvalid
                          ? AppColors.error
                          : theme.colorScheme.onSurface,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
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
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _focusRate,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'EDIT',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // ── Discount % + Free Qty ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DISCOUNT %', style: _fieldLabelStyle(theme)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _discountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDiscountInvalid
                            ? AppColors.error
                            : theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        suffixText: '%',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDiscountInvalid
                                ? AppColors.error
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: isDiscountInvalid
                                ? AppColors.error
                                : theme.colorScheme.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onTap: () => setState(() => _editingDiscount = true),
                      onChanged: (v) {
                        final parsed = double.tryParse(v);
                        if (parsed != null) {
                          widget.onDiscountChanged(parsed);
                        }
                      },
                      onSubmitted: (_) =>
                          setState(() => _editingDiscount = false),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FREE QTY', style: _fieldLabelStyle(theme)),
                  const SizedBox(height: 6),
                  AppQtyStepper(
                    value: item.freeQty,
                    min: 0,
                    onChanged: widget.onFreeQtyChanged,
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

  TextStyle? _fieldLabelStyle(ThemeData theme) =>
      theme.textTheme.bodySmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
      );
}
