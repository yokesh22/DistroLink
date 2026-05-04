import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminSalesmenListScreen extends ConsumerWidget {
  const AdminSalesmenListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final salesmenAsync = ref.watch(adminSalesmenListProvider);

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
                      'Salesmen',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ),
                  AppButton(
                    label: 'Add Salesman',
                    fullWidth: false,
                    icon: Icons.add_rounded,
                    onPressed: () => context.push('/admin/salesmen/add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: salesmenAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (salesmen) => salesmen.isEmpty
                    ? _EmptyState(
                        onAdd: () => context.push('/admin/salesmen/add'),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                          vertical: AppSpacing.xs,
                        ),
                        itemCount: salesmen.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.xs),
                        itemBuilder: (_, i) =>
                            _SalesmanTile(salesman: salesmen[i]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesmanTile extends ConsumerWidget {
  const _SalesmanTile({required this.salesman});
  final Salesman salesman;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isActive = salesman.isActive;

    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                isActive ? AppColors.blueLight : AppColors.lightBorder,
            child: Text(
              salesman.name.isNotEmpty
                  ? salesman.name[0].toUpperCase()
                  : 'S',
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : AppColors.lightTextSecondary,
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
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (!isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.redLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Inactive',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(salesman.phone, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(
              '/admin/salesmen/${salesman.id}/edit',
              extra: salesman,
            ),
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
