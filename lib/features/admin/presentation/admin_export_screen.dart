import 'dart:io';

import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_offline_banner.dart';
import 'package:distro_link/features/admin/application/admin_export_controller.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminExportScreen extends ConsumerStatefulWidget {
  const AdminExportScreen({super.key});

  @override
  ConsumerState<AdminExportScreen> createState() => _AdminExportScreenState();
}

class _AdminExportScreenState extends ConsumerState<AdminExportScreen> {
  final _selected = <AdminExportSheet>{...AdminExportSheet.values};

  void _toggle(AdminExportSheet sheet, {required bool on}) {
    setState(() {
      if (on) {
        _selected.add(sheet);
      } else {
        _selected.remove(sheet);
      }
    });
    ref.read(adminExportControllerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final exportState = ref.watch(adminExportControllerProvider);

    final isGenerating = exportState.maybeWhen(
      generating: () => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Export Data'),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            if (!isOnline) ...[
              const AppOfflineBanner(),
              const SizedBox(height: AppSpacing.sm),
            ],

            // ── List selection ──────────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LISTS TO EXPORT',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _SheetCheckbox(
                    label: 'Areas',
                    value: _selected.contains(AdminExportSheet.areas),
                    onChanged: (v) =>
                        _toggle(AdminExportSheet.areas, on: v ?? false),
                  ),
                  _SheetCheckbox(
                    label: 'Shops',
                    value: _selected.contains(AdminExportSheet.shops),
                    onChanged: (v) =>
                        _toggle(AdminExportSheet.shops, on: v ?? false),
                  ),
                  _SheetCheckbox(
                    label: 'Products',
                    value: _selected.contains(AdminExportSheet.products),
                    onChanged: (v) =>
                        _toggle(AdminExportSheet.products, on: v ?? false),
                  ),
                  _SheetCheckbox(
                    label: 'Salesmen',
                    value: _selected.contains(AdminExportSheet.salesmen),
                    onChanged: (v) =>
                        _toggle(AdminExportSheet.salesmen, on: v ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Generate button ─────────────────────────────────────
            AppButton(
              label: 'Generate & Share',
              loading: isGenerating,
              onPressed: isOnline && !isGenerating && _selected.isNotEmpty
                  ? () => ref
                      .read(adminExportControllerProvider.notifier)
                      .generateAndShare(sheets: _selected)
                  : null,
            ),

            if (!isOnline) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Export needs internet — connect to'
                ' Wi-Fi or mobile data',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.warning,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // ── Status section ──────────────────────────────────────
            exportState.when(
              idle: () => const SizedBox.shrink(),
              generating: () => const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              ),
              done: (file) => _DoneSection(
                file: file,
                onShareAgain: () => ref
                    .read(adminExportControllerProvider.notifier)
                    .shareAgain(),
              ),
              error: (message) => Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          message,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetCheckbox extends StatelessWidget {
  const _SheetCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}

class _DoneSection extends StatelessWidget {
  const _DoneSection({required this.file, required this.onShareAgain});

  final File file;
  final VoidCallback onShareAgain;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.accent,
                ),
                const SizedBox(width: 8),
                Text(
                  'File ready',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              file.path.split('/').last,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: 'Share again',
              variant: AppButtonVariant.secondary,
              onPressed: onShareAgain,
            ),
          ],
        ),
      ),
    );
  }
}
