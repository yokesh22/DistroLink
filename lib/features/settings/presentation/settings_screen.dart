import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/settings/application/settings_providers.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentAppUserProvider);
    final salesmanAsync = ref.watch(currentSalesmanProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount =
        ref.watch(pendingSyncCountProvider).asData?.value ?? 0;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text(
              'Settings',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Profile card ────────────────────────────────────
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primary,
                    child: salesmanAsync.whenOrNull(
                          data: (s) => Text(
                            s?.name.isNotEmpty == true
                                ? s!.name[0].toUpperCase()
                                : 'S',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ) ??
                        const Text(
                          'S',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          salesmanAsync.asData?.value?.name ??
                              userAsync.asData?.value?.fullName ??
                              'Salesman',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          userAsync.asData?.value?.email ?? '',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          'Salesman · Distributor',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Sync status card ────────────────────────────────
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        isOnline && pendingCount == 0 ? '✅' : '📶',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              !isOnline
                                  ? 'Offline — $pendingCount orders'
                                      ' pending sync'
                                  : pendingCount > 0
                                      ? '$pendingCount orders pending'
                                          ' sync'
                                      : 'All synced',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isOnline && pendingCount == 0
                                    ? const Color(0xFF065F46)
                                    : const Color(0xFF92400E),
                              ),
                            ),
                            Text(
                              !isOnline
                                  ? 'Orders saved locally. '
                                      'Will sync automatically.'
                                  : 'Orders sync automatically '
                                      'when online.',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            Text(
              'PREFERENCES',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),

            // ── Dark mode toggle ─────────────────────────────────
            _PrefRow(
              label: 'Dark Mode',
              subtitle: 'Easier in low light',
              value: isDark,
              onChanged: (_) => ref
                  .read(themeModeProvider.notifier)
                  .toggle(),
            ),

            // ── Other preferences (cosmetic Phase 1) ────────────
            const _PrefRow(
              label: 'Auto-fill last shop',
              subtitle: 'Pre-select on new order',
              value: true,
            ),

            const Divider(height: AppSpacing.lg),

            Text(
              'EXPORT',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: theme.colorScheme.onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: '↓ Export to Excel (.xlsx)',
              variant: AppButtonVariant.secondary,
              onPressed: isOnline
                  ? () => context.push(
                        '/settings/export',
                        extra: ExportFormat.excel,
                      )
                  : null,
            ),
            if (!isOnline) ...[
              const SizedBox(height: 4),
              Text(
                'Export needs internet — connect to'
                ' Wi-Fi or mobile data',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.warning),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: '↓ Export PDF Report',
              variant: AppButtonVariant.secondary,
              onPressed: isOnline
                  ? () => context.push(
                        '/settings/export',
                        extra: ExportFormat.pdf,
                      )
                  : null,
            ),

            const Divider(height: AppSpacing.lg),

            // ── About ────────────────────────────────────────────
            AppCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/icons/icon_dark_1024.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DistroLink v1.0.0',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'help@distrolink.in',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Logout ────────────────────────────────────────────
            OutlinedButton(
              onPressed: () async {
                await ref
                    .read(authRepositoryProvider)
                    .signOut();
                if (context.mounted) context.go('/login');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(
                  color: Color(0xFFFECACA),
                ),
              ),
              child: const Text('Logout'),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  const _PrefRow({
    required this.label,
    required this.subtitle,
    required this.value,
    this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
