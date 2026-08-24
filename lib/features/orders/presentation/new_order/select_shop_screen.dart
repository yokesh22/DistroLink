import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_step_indicator.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/features/shops/presentation/add_shop_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class SelectShopScreen extends ConsumerStatefulWidget {
  const SelectShopScreen({super.key});

  @override
  ConsumerState<SelectShopScreen> createState() =>
      _SelectShopScreenState();
}

class _SelectShopScreenState extends ConsumerState<SelectShopScreen> {
  String? _selectedAreaId;
  Shop? _selectedShop;
  final _searchCtrl = TextEditingController();

  /// Order date shown on Step 1. Defaults to today; the salesman can change it
  /// (persisted to `orders.order_date` on submit). Seeded from the draft when
  /// resuming/editing.
  late DateTime _orderDate;

  @override
  void initState() {
    super.initState();
    _orderDate = ref.read(orderDraftProvider).orderDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickOrderDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _orderDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _orderDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final areasAsync = ref.watch(areasProvider);
    final shopsAsync = _selectedAreaId != null
        ? ref.watch(shopsByAreaProvider(_selectedAreaId!))
        : null;
    final recentAsync = ref.watch(recentShopsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => context.go('/home'),
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('New Order'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '1 of 3',
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
          const AppStepIndicator(currentStep: 1, total: 3),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                4,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
              ),
              children: [
                // ── Order date / time ─────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _OrderDateField(
                        date: _orderDate,
                        onChange: _pickOrderDate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _OrderTimeField(time: DateTime.now()),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                Text(
                  'Select Shop',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Area dropdown ─────────────────────────────────
                areasAsync.when(
                  data: (areas) => _AreaDropdown(
                    areas: areas,
                    value: _selectedAreaId,
                    onChanged: (areaId) =>
                        setState(() {
                          debugPrint('Selected areaId: $areaId');
                          _selectedAreaId = areaId;
                          _selectedShop = null;
                        }),
                  ),
                  loading: () =>
                      const LinearProgressIndicator(),
                  error: (e, _) =>
                      Text('Error loading areas: $e'),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.orangeLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusCard),
                    border: Border.all(
                      color: const Color(0xFFFDE68A),
                    ),
                  ),
                  child: const Text(
                    '💡 Areas are set by admin. '
                    'Selecting area filters shop list.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF92400E),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // ── Shop search ───────────────────────────────────
                if (_selectedAreaId != null) ...[
                  const _InputLabel('Select Shop'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Search by name or number…',
                      prefixIcon:
                          Icon(Icons.search_rounded, size: 20),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(
                    label: 'Add New Shop',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.add_business_rounded,
                    onPressed: () => _addNewShop(areasAsync),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (shopsAsync != null)
                    shopsAsync.when(
                      data: (shops) {
                        final q =
                            _searchCtrl.text.trim().toLowerCase();
                        final filtered = q.isEmpty
                            ? shops
                            : shops
                                .where(
                                  (s) =>
                                      s.shopName
                                          .toLowerCase()
                                          .contains(q) ||
                                      (s.shopNumber ?? '')
                                          .toLowerCase()
                                          .contains(q),
                                )
                                .toList();
                        debugPrint(
                          'UI shops for area $_selectedAreaId -> '
                          'total: ${shops.length}, '
                          'filtered: ${filtered.length}, query: "$q"',
                        );
                        if (shops.isEmpty) {
                          return Text(
                            'No shops found for this area.',
                            style: theme.textTheme.bodyMedium,
                          );
                        }
                        if (filtered.isEmpty) {
                          return Text(
                            'No shops match "$q".',
                            style: theme.textTheme.bodyMedium,
                          );
                        }
                        return Column(
                          children: filtered
                              .map(
                                (s) => _ShopTile(
                                  shop: s,
                                  selected:
                                      _selectedShop?.id == s.id,
                                  onTap: () =>
                                      setState(
                                        () => _selectedShop = s,
                                      ),
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () =>
                          const LinearProgressIndicator(),
                      error: (e, _) =>
                          Text('Error loading shops: $e'),
                    ),
                ] else ...[
                  // ── Recent shops ───────────────────────────────
                  const _InputLabel('Recent Shops'),
                  const SizedBox(height: AppSpacing.xs),
                  recentAsync.when(
                    data: (shops) => shops.isEmpty
                        ? const Text('No recent shops yet.')
                        : Column(
                            children: shops
                                .map(
                                  (s) => _ShopTile(
                                    shop: s,
                                    selected:
                                        _selectedShop?.id == s.id,
                                    onTap: () => setState(
                                      () {
                                        _selectedShop = s;
                                      },
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                    loading: () =>
                        const LinearProgressIndicator(),
                    error: (e, _) =>
                        Text('Error loading recent shops: $e'),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: AppButton(
              label: 'Next: Order Details →',
              onPressed: _selectedShop != null
                  ? () {
                      final selectedArea = _resolveSelectedArea(areasAsync);
                      if (selectedArea == null) return;
                      ref.read(orderDraftProvider.notifier)
                        ..setOrderDate(_orderDate)
                        ..selectShop(
                          area: selectedArea,
                          shop: _selectedShop!,
                        );
                      context.go('/orders/new/2');
                    }
                  : null,
            ),
          ),
        ],
      ),
      ),
    );
  }

  Area? _resolveSelectedArea(AsyncValue<List<Area>> areasAsync) {
    final areas = areasAsync.asData?.value;
    if (areas == null || areas.isEmpty) return null;

    // If user selected from "Recent Shops", infer area by shop.areaId.
    final targetAreaId = _selectedAreaId ?? _selectedShop?.areaId;
    if (targetAreaId == null) return null;

    for (final area in areas) {
      if (area.id == targetAreaId) return area;
    }
    return null;
  }

  Future<void> _addNewShop(AsyncValue<List<Area>> areasAsync) async {
    final area = _resolveSelectedArea(areasAsync);
    if (area == null) return;
    final created = await AddShopSheet.show(context, area: area);
    // The shop list refreshes automatically via the provider invalidation in
    // AdminShopsList.create; select the new shop so "Next" enables at once.
    if (created != null && mounted) {
      setState(() => _selectedShop = created);
    }
  }
}

class _AreaDropdown extends StatelessWidget {
  const _AreaDropdown({
    required this.areas,
    required this.value,
    required this.onChanged,
  });

  final List<Area> areas;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InputLabel('Select Area'),
        const SizedBox(height: 6),
        DropdownMenu<String>(
          initialSelection: value,
          // Tap-to-select only; don't pop the keyboard / allow free text.
          requestFocusOnTap: false,
          enableSearch: false,
          hintText: 'Choose your area…',
          // Match the field to the parent width.
          expandedInsets: EdgeInsets.zero,
          // Cap the popup to roughly half the screen so a long area list
          // can't cover it; it stays anchored below the field and scrolls
          // internally past this.
          menuHeight: MediaQuery.sizeOf(context).height * 0.5,
          leadingIcon: const Icon(Icons.location_on_rounded, size: 20),
          trailingIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
          selectedTrailingIcon: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
          ),
          textStyle: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
          menuStyle: MenuStyle(
            backgroundColor:
                WidgetStatePropertyAll(theme.colorScheme.surface),
            elevation: const WidgetStatePropertyAll(3),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusCard),
                side: BorderSide(color: theme.colorScheme.outline),
              ),
            ),
          ),
          onSelected: onChanged,
          dropdownMenuEntries: areas
              .map(
                (a) => DropdownMenuEntry(
                  value: a.id,
                  label: a.name,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ShopTile extends StatelessWidget {
  const _ShopTile({
    required this.shop,
    required this.selected,
    required this.onTap,
  });

  final Shop shop;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.blueLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.storefront_rounded,
                size: 20,
                color: selected
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.shopName,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    (shop.shopNumber?.isNotEmpty ?? false)
                        ? '${shop.shopNumber} · ${shop.shopAddress}'
                        : shop.shopAddress,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              size: 18,
              color: selected
                  ? AppColors.accent
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderDateField extends StatelessWidget {
  const _OrderDateField({required this.date, required this.onChange});

  final DateTime date;
  final Future<void> Function() onChange;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InputLabel('Order Date'),
        const SizedBox(height: 6),
        InkWell(
          onTap: onChange,
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          child: InputDecorator(
            decoration: const InputDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    DateFormat('dd MMM yyyy').format(date),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Change',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderTimeField extends StatelessWidget {
  const _OrderTimeField({required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _InputLabel('Order Time'),
        const SizedBox(height: 6),
        InputDecorator(
          decoration: const InputDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  DateFormat('hh:mm a').format(time),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'AUTO',
                  style: TextStyle(
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
