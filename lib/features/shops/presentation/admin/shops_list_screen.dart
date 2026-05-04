import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminShopsListScreen extends ConsumerWidget {
  const AdminShopsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final shopsAsync = ref.watch(adminShopsListProvider);
    final areasAsync = ref.watch(adminAreasListProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Shops',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/admin/areas'),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Areas'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AppButton(
                    label: 'Add Shop',
                    fullWidth: false,
                    icon: Icons.add_rounded,
                    onPressed: () => context.push('/admin/shops/add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: shopsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (shops) {
                  final areas = areasAsync.asData?.value ?? <Area>[];
                  if (shops.isEmpty) {
                    return _EmptyState(
                      onAdd: () => context.push('/admin/shops/add'),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                      vertical: AppSpacing.xs,
                    ),
                    itemCount: shops.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.xs),
                    itemBuilder: (_, i) {
                      final shop = shops[i];
                      final area = areas.where((a) => a.id == shop.areaId)
                          .firstOrNull;
                      return _ShopTile(shop: shop, area: area);
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

class _ShopTile extends StatelessWidget {
  const _ShopTile({required this.shop, this.area});
  final Shop shop;
  final Area? area;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.store_outlined,
              size: 18,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.shopName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${shop.shopNumber}${area != null ? ' · ${area!.name}' : ''}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                context.push('/admin/shops/${shop.id}/edit', extra: shop),
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Edit',
          ),
        ],
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
