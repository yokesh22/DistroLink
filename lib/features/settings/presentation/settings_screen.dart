import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/settings/application/settings_providers.dart';
import 'package:flutter/foundation.dart';
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
    final isOffline = ref.watch(offlineSimProvider);
    final isDark = themeMode == ThemeMode.dark;

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
                        isOffline ? '📶' : '✅',
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOffline
                                  ? 'Offline — 2 orders pending sync'
                                  : 'All synced · Last sync 2 min ago',
                              style:
                                  theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isOffline
                                    ? const Color(0xFF92400E)
                                    : const Color(0xFF065F46),
                              ),
                            ),
                            Text(
                              isOffline
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
                  if (!isOffline) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AppButton(
                      label: 'Force Sync Now',
                      variant: AppButtonVariant.secondary,
                      onPressed: () {},
                    ),
                  ],
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

            // ── Offline simulation (debug only) ──────────────────
            if (kDebugMode)
              _PrefRow(
                label: 'Simulate Offline',
                subtitle: 'Debug: test offline UI states',
                value: isOffline,
                onChanged: (v) => ref
                    .read(offlineSimProvider.notifier)
                    .simulating = v,
              ),

            // ── Other preferences (cosmetic Phase 1) ────────────
            const _PrefRow(
              label: 'Auto-fill last shop',
              subtitle: 'Pre-select on new order',
              value: true,
            ),
            const _PrefRow(
              label: 'SMS OTP auto-read',
              subtitle: 'Skip manual OTP entry (Phase 4)',
              value: false,
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
            const AppButton(
              label: '↓ Export to Excel (.xlsx)',
              variant: AppButtonVariant.secondary,
              onPressed: null, // Phase 5
            ),
            const SizedBox(height: AppSpacing.xs),
            const AppButton(
              label: '↓ Export PDF Report',
              variant: AppButtonVariant.secondary,
              onPressed: null, // Phase 5
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
