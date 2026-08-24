import 'package:distro_link/core/theme/app_colors.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:distro_link/core/widgets/app_chip.dart';
import 'package:distro_link/features/auth/application/super_admin_import_providers.dart';
import 'package:distro_link/features/auth/domain/distributor.dart';
import 'package:distro_link/services/import/excel_import_service.dart';
import 'package:distro_link/services/import/import_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Super-admin bulk import: areas (single `area` column) or shops (7-column
/// sheet) from an `.xlsx` into a chosen distributor. Items is a placeholder.
class BulkImportScreen extends ConsumerWidget {
  const BulkImportScreen({super.key});

  Future<void> _pickFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true,
    );
    final file = result?.files.singleOrNull;
    final bytes = file?.bytes;
    if (bytes == null) return; // cancelled or no data
    await ref
        .read(bulkImportProvider.notifier)
        .parseFile(bytes: bytes, fileName: file!.name);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(bulkImportProvider);
    final notifier = ref.read(bulkImportProvider.notifier);

    // Surface import errors as a snackbar.
    ref.listen(bulkImportProvider, (prev, next) {
      final msg = next.errorMessage;
      if (msg != null && msg != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final type = state.type;
    final isAreas = type == ImportType.areas;
    final isItems = type == ImportType.items;
    // Shops and items share the plan-based validation UI.
    final isPlanBased = !isAreas;
    final canSubmit = notifier.canSubmit;

    return Scaffold(
      appBar: AppBar(title: const Text('Bulk Import')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  // 1. Distributor
                  const _SectionLabel('Distributor'),
                  const SizedBox(height: AppSpacing.xs),
                  _DistributorField(
                    distributor: state.distributor,
                    onTap: () => _openDistributorPicker(context, ref),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 2. Import type
                  const _SectionLabel('What to import'),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _TypeChip(
                        label: 'Areas',
                        active: isAreas,
                        onTap: () => notifier.selectType(ImportType.areas),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _TypeChip(
                        label: 'Shops',
                        active: type == ImportType.shops,
                        onTap: () => notifier.selectType(ImportType.shops),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _TypeChip(
                        label: 'Items',
                        active: isItems,
                        onTap: () => notifier.selectType(ImportType.items),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 3. File
                  const _SectionLabel('Spreadsheet'),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _fileHint(type),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppButton(
                    label: state.fileName == null
                        ? 'Choose .xlsx file'
                        : 'Choose a different file',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.attach_file_rounded,
                    onPressed: () => _pickFile(ref),
                  ),
                  if (state.fileName != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    if (isPlanBased)
                      _SheetValidationPanel(
                        fileName: state.fileName!,
                        fatalError: isItems
                            ? state.itemParse?.fatalError
                            : state.shopParse?.fatalError,
                        parsed: isItems
                            ? state.itemParse != null
                            : state.shopParse != null,
                        distributor: state.distributor,
                        phase: state.phase,
                        plan: state.plan,
                        noun: isItems ? 'item' : 'shop',
                        onDownloadErrors: notifier.shareErrorReport,
                      )
                    else
                      _AreaFileSummary(
                        fileName: state.fileName!,
                        parse: state.areaParse,
                      ),
                  ],
                  if (state.result != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _ResultCard(
                      result: state.result!,
                      onDownloadSkipped:
                          isPlanBased && state.result!.skipped > 0
                          ? notifier.shareSkippedReport
                          : null,
                    ),
                  ],
                ],
              ),
            ),

            // Sticky footer action.
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: AppButton(
                label: _submitLabel(state),
                loading: state.phase == ImportPhase.submitting,
                onPressed: canSubmit ? notifier.submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fileHint(ImportType type) => switch (type) {
        ImportType.areas => "One column with the header 'area'.",
        ImportType.shops =>
          'Columns: area, shop, retailer_code, address (required); '
              'mobile, shop_owner, gst_no (values optional).',
        ImportType.items =>
          'Columns: brand, item_code, item, hsn, mrp, rate, gst, pack.',
      };

  String _submitLabel(BulkImportState state) {
    switch (state.type) {
      case ImportType.areas:
        final p = state.areaParse;
        return (p?.isValid ?? false)
            ? 'Import ${p!.names.length} areas'
            : 'Import';
      case ImportType.shops:
      case ImportType.items:
        final plan = state.plan;
        final noun = state.type == ImportType.items ? 'items' : 'shops';
        return (plan?.canImport ?? false)
            ? 'Import ${plan!.toInsert.length} $noun'
            : 'Import';
    }
  }

  Future<void> _openDistributorPicker(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final selected = await showModalBottomSheet<Distributor>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _DistributorPickerSheet(),
    );
    if (selected != null) {
      await ref.read(bulkImportProvider.notifier).selectDistributor(selected);
    }
  }
}

/// Selectable import-type chip (Areas / Shops).
class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) =>
      AppChip(label: label, active: active, onTap: onTap);
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _DistributorField extends StatelessWidget {
  const _DistributorField({required this.distributor, required this.onTap});

  final Distributor? distributor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasValue = distributor != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusInput),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.business_rounded,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                distributor?.name ?? 'Select distributor',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasValue
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaFileSummary extends StatelessWidget {
  const _AreaFileSummary({required this.fileName, required this.parse});

  final String fileName;
  final AreaImportParse? parse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valid = parse?.isValid ?? false;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          if (!valid)
            Text(
              parse?.error ?? 'Could not read this file.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.error),
            )
          else
            _PreviewList(names: parse!.names),
        ],
      ),
    );
  }
}

class _PreviewList extends StatelessWidget {
  const _PreviewList({required this.names});
  final List<String> names;

  static const _previewLimit = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shown = names.take(_previewLimit).toList();
    final remaining = names.length - shown.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${names.length} area${names.length == 1 ? '' : 's'} found',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [for (final name in shown) AppChip(label: name)],
        ),
        if (remaining > 0) ...[
          const SizedBox(height: 6),
          Text(
            '+ $remaining more',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, this.onDownloadSkipped});
  final ImportResult result;
  final Future<void> Function()? onDownloadSkipped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.accent),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${result.added} added, ${result.skipped} skipped '
                  '(already exist)',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (onDownloadSkipped != null) ...[
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: 'Download skipped rows',
              variant: AppButtonVariant.secondary,
              icon: Icons.download_rounded,
              onPressed: onDownloadSkipped,
            ),
          ],
        ],
      ),
    );
  }
}

/// Shops/items file summary + full validation state (fatal / blocking / ready).
class _SheetValidationPanel extends StatelessWidget {
  const _SheetValidationPanel({
    required this.fileName,
    required this.fatalError,
    required this.parsed,
    required this.distributor,
    required this.phase,
    required this.plan,
    required this.noun,
    required this.onDownloadErrors,
  });

  final String fileName;
  final String? fatalError;
  final bool parsed;
  final Distributor? distributor;
  final ImportPhase phase;
  final ImportPlan? plan;
  final String noun; // 'shop' | 'item'
  final Future<void> Function() onDownloadErrors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    Widget body;
    if (phase == ImportPhase.parsing) {
      body = const _InlineProgress(label: 'Reading spreadsheet…');
    } else if (!parsed) {
      body = const SizedBox.shrink();
    } else if (fatalError != null) {
      body = Text(
        fatalError!,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
      );
    } else if (distributor == null) {
      body = Text(
        'Select a distributor to validate this sheet.',
        style: theme.textTheme.bodySmall?.copyWith(color: muted),
      );
    } else if (phase == ImportPhase.validating) {
      body = const _InlineProgress(label: 'Validating against distributor…');
    } else if (plan != null) {
      body = _PlanSummary(
        plan: plan!,
        noun: noun,
        onDownloadErrors: onDownloadErrors,
      );
    } else {
      body = const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_outlined, size: 18, color: muted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  fileName,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          body,
        ],
      ),
    );
  }
}

class _PlanSummary extends StatelessWidget {
  const _PlanSummary({
    required this.plan,
    required this.noun,
    required this.onDownloadErrors,
  });

  final ImportPlan plan;
  final String noun;
  final Future<void> Function() onDownloadErrors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!plan.canImport) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${plan.blocking.length} row(s) have errors — nothing will be '
            'imported. Fix them and re-upload.',
            style:
                theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: 'Download error report',
            variant: AppButtonVariant.secondary,
            icon: Icons.download_rounded,
            onPressed: onDownloadErrors,
          ),
        ],
      );
    }

    final ready = plan.toInsert.length;
    final skipped = plan.skipped.length;
    return Text(
      '$ready $noun${ready == 1 ? '' : 's'} ready'
      '${skipped > 0 ? ' · $skipped will be skipped (already exist)' : ''}',
      style: theme.textTheme.bodySmall?.copyWith(
        color: AppColors.accent,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InlineProgress extends StatelessWidget {
  const _InlineProgress({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

/// Bottom sheet listing all distributors with client-side search.
class _DistributorPickerSheet extends ConsumerStatefulWidget {
  const _DistributorPickerSheet();

  @override
  ConsumerState<_DistributorPickerSheet> createState() =>
      _DistributorPickerSheetState();
}

class _DistributorPickerSheetState
    extends ConsumerState<_DistributorPickerSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => setState(() => _query = _controller.text.trim().toLowerCase()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final distributors = ref.watch(distributorsListProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screenPadding,
        right: AppSpacing.screenPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.sm,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusCard),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Search distributor...',
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
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: distributors.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text(
                    'Could not load distributors',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                data: (list) {
                  final filtered = _query.isEmpty
                      ? list
                      : list
                          .where((d) => d.name.toLowerCase().contains(_query))
                          .toList();
                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No distributors found',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final d = filtered[i];
                      return ListTile(
                        title: Text(d.name),
                        subtitle: d.email.isEmpty ? null : Text(d.email),
                        onTap: () => Navigator.pop(context, d),
                      );
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
