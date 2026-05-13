import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminShopsListScreen extends ConsumerStatefulWidget {
  const AdminShopsListScreen({super.key});

  @override
  ConsumerState<AdminShopsListScreen> createState() =>
      _AdminShopsListScreenState();
}

class _AdminShopsListScreenState extends ConsumerState<AdminShopsListScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedAreaId; // null = All Areas

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      () => setState(() => _query = _searchController.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Shop> _filtered(List<Shop> shops) {
    var result = shops;
    if (_selectedAreaId != null) {
      result = result.where((s) => s.areaId == _selectedAreaId).toList();
    }
    if (_query.isNotEmpty) {
      result = result
          .where(
            (s) =>
                s.shopName.toLowerCase().contains(_query) ||
                (s.shopNumber?.toLowerCase().contains(_query) ?? false),
          )
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shopsAsync = ref.watch(adminShopsListProvider);
    final areasAsync = ref.watch(adminAreasListProvider);
    final areas = areasAsync.asData?.value ?? <Area>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Shops',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  AppButton(
                    label: '+ Add',
                    fullWidth: false,
                    onPressed: () => context.push('/admin/shops/add'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: _SearchBar(controller: _searchController),
            ),
            if (areas.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              _AreaFilterChips(
                areas: areas,
                selectedAreaId: _selectedAreaId,
                onSelected: (id) => setState(() => _selectedAreaId = id),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            shopsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (shops) {
                final filtered = _filtered(shops);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Text(
                    '${filtered.length} SHOPS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: shopsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (shops) {
                  final filtered = _filtered(shops);

                  if (filtered.isEmpty) {
                    return _query.isNotEmpty || _selectedAreaId != null
                        ? Center(
                            child: Text(
                              'No shops match your filters',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : _EmptyState(
                            onAdd: () => context.push('/admin/shops/add'),
                          );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.screenPadding,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) {
                      final shop = filtered[i];
                      final area =
                          areas.where((a) => a.id == shop.areaId).firstOrNull;
                      return _ShopCard(shop: shop, area: area);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TextField(
        controller: controller,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search by shop name or number...',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _AreaFilterChips extends StatelessWidget {
  const _AreaFilterChips({
    required this.areas,
    required this.selectedAreaId,
    required this.onSelected,
  });

  final List<Area> areas;
  final String? selectedAreaId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        children: [
          _Chip(
            label: 'All Areas',
            isSelected: selectedAreaId == null,
            isDark: isDark,
            theme: theme,
            onTap: () => onSelected(null),
          ),
          ...areas.map(
            (a) => Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xs),
              child: _Chip(
                label: a.name,
                isSelected: selectedAreaId == a.id,
                isDark: isDark,
                theme: theme,
                onTap: () => onSelected(selectedAreaId == a.id ? null : a.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Colors.white
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop, this.area});
  final Shop shop;
  final Area? area;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      onTap: () => context.push('/admin/shops/${shop.id}/edit', extra: shop),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    shop.shopName,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const _ActiveBadge(),
              ],
            ),
            if (shop.shopNumber != null || area != null) ...[
              const SizedBox(height: 2),
              Text(
                [
                  if (shop.shopNumber != null) shop.shopNumber!,
                  if (area != null) area!.name,
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
            if (shop.shopAddress.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                shop.shopAddress,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'Active',
      style: theme.textTheme.labelSmall?.copyWith(
        color: AppColors.accent,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.store_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No shops yet',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Add shops for salesmen to place orders.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Add First Shop',
              fullWidth: false,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
