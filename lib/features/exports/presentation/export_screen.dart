import 'dart:io';

import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_offline_banner.dart';
import 'package:distro_link/core/widgets/app_segmented.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExportScreen extends ConsumerStatefulWidget {
  const ExportScreen({required this.initialFormat, super.key});

  final ExportFormat initialFormat;

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  late ExportFormat _format;
  late DateTime _from;
  late DateTime _to;

  static final _displayFmt = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _format = widget.initialFormat;
    _to = DateTime.now();
    _from = _to.subtract(const Duration(days: 6));
  }

  @override
  void dispose() {
    // ExportController is auto-dispose (@riverpod) — it resets automatically
    // when this screen is popped. Calling ref.read here is unsafe (widget
    // is unmounted) and unnecessary.
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = isFrom ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        if (_from.isAfter(_to)) _to = _from;
      } else {
        _to = picked;
        if (_to.isBefore(_from)) _from = _to;
      }
    });
    ref.read(exportControllerProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOnline = ref.watch(isOnlineProvider);
    final exportState = ref.watch(exportControllerProvider);

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
        title: const Text('Export Orders'),
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

            // ── Format toggle ──────────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FORMAT',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppSegmented(
                    options: const ['Excel (.xlsx)', 'PDF Report'],
                    selectedIndex: _format == ExportFormat.excel ? 0 : 1,
                    onChanged: (i) {
                      setState(
                        () => _format =
                            i == 0 ? ExportFormat.excel : ExportFormat.pdf,
                      );
                      ref.read(exportControllerProvider.notifier).reset();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Date range ─────────────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DATE RANGE',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Expanded(
                        child: _DateField(
                          label: 'From',
                          value: _displayFmt.format(_from),
                          onTap: () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _DateField(
                          label: 'To',
                          value: _displayFmt.format(_to),
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Generate button ────────────────────────────────────
            AppButton(
              label: 'Generate & Share',
              loading: isGenerating,
              onPressed: isOnline && !isGenerating
                  ? () => ref
                      .read(exportControllerProvider.notifier)
                      .generateAndShare(
                        format: _format,
                        from: _from,
                        to: _to,
                      )
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

            // ── Status section ─────────────────────────────────────
            exportState.when(
              idle: () => const SizedBox.shrink(),
              generating: () => const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              ),
              done: (file) => _DoneSection(
                file: file,
                onShareAgain: () => ref
                    .read(exportControllerProvider.notifier)
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
                          style: Theme.of(context).textTheme.bodyMedium
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.5),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneSection extends ConsumerWidget {
  const _DoneSection({required this.file, required this.onShareAgain});

  final File file;
  final VoidCallback onShareAgain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
