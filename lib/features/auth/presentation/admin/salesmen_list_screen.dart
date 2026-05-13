import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminSalesmenListScreen extends ConsumerStatefulWidget {
  const AdminSalesmenListScreen({super.key});

  @override
  ConsumerState<AdminSalesmenListScreen> createState() =>
      _AdminSalesmenListScreenState();
}

class _AdminSalesmenListScreenState
    extends ConsumerState<AdminSalesmenListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final salesmenAsync = ref.watch(adminSalesmenListProvider);
    final ordersAsync = ref.watch(salesmanOrdersTodayMapProvider);

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
                      'Salesmen',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  AppButton(
                    label: '+ Add',
                    fullWidth: false,
                    onPressed: () => context.push('/admin/salesmen/add'),
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
            const SizedBox(height: AppSpacing.sm),
            salesmenAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (salesmen) {
                final filtered = _query.isEmpty
                    ? salesmen
                    : salesmen
                        .where(
                          (s) =>
                              s.name.toLowerCase().contains(_query) ||
                              s.phone.contains(_query),
                        )
                        .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Text(
                    '${filtered.length} SALESMEN',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: salesmenAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (salesmen) {
                  final ordersMap = ordersAsync.asData?.value ?? {};
                  final filtered = _query.isEmpty
                      ? salesmen
                      : salesmen
                          .where(
                            (s) =>
                                s.name.toLowerCase().contains(_query) ||
                                s.phone.contains(_query),
                          )
                          .toList();

                  if (filtered.isEmpty) {
                    return _query.isNotEmpty
                        ? Center(
                            child: Text(
                              'No salesmen match "$_query"',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : _EmptyState(
                            onAdd: () => context.push('/admin/salesmen/add'),
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
                    itemBuilder: (_, i) => _SalesmanCard(
                      salesman: filtered[i],
                      ordersToday: ordersMap[filtered[i].id] ?? 0,
                    ),
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
          hintText: 'Search salesman...',
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

class _SalesmanCard extends ConsumerWidget {
  const _SalesmanCard({
    required this.salesman,
    required this.ordersToday,
  });
  final Salesman salesman;
  final int ordersToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = salesman.isActive;

    final avatarBg = isActive
        ? AppColors.primary
        : (isDark ? AppColors.darkBorder : AppColors.lightBorder);
    final avatarFg = isActive
        ? Colors.white
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        onTap: () => context.push(
          '/admin/salesmen/${salesman.id}/edit',
          extra: salesman,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
              ),
              alignment: Alignment.center,
              child: Text(
                salesman.name.isNotEmpty
                    ? salesman.name[0].toUpperCase()
                    : 'S',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: avatarFg,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          salesman.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _StatusBadge(isActive: isActive),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    salesman.phone,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$ordersToday orders today',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isActive) {
      return Text(
        'Active',
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Inactive',
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.lightTextSecondary,
          fontWeight: FontWeight.w600,
        ),
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
              Icons.people_outline_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No salesmen yet',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Add salesmen to start taking orders.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Add First Salesman',
              fullWidth: false,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
