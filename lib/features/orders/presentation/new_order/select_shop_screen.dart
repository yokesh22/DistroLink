import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_step_indicator.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/shops/application/shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
                '1 of 4',
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
          const AppStepIndicator(currentStep: 1),
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
                      ref
                          .read(
                            orderDraftProvider.notifier,
                          )
                          .selectShop(
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
                    '${shop.shopNumber} · ${shop.shopAddress}',
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
