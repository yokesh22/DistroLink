import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/data/super_admin_repository.dart';
import 'package:distro_link/features/auth/domain/distributor.dart';
import 'package:distro_link/services/export/share_service.dart';
import 'package:distro_link/services/import/excel_import_service.dart';
import 'package:distro_link/services/import/import_models.dart';
import 'package:distro_link/services/import/import_report_service.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'super_admin_import_providers.freezed.dart';
part 'super_admin_import_providers.g.dart';

@Riverpod(keepAlive: true)
SuperAdminRepository superAdminRepository(Ref ref) =>
    SuperAdminRepository(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
ExcelImportService excelImportService(Ref ref) => ExcelImportService();

@Riverpod(keepAlive: true)
ImportReportService importReportService(Ref ref) => ImportReportService();

@Riverpod(keepAlive: true)
ShareService importShareService(Ref ref) => ShareService();

/// All distributors, for the bulk-import picker.
@riverpod
Future<List<Distributor>> distributorsList(Ref ref) =>
    ref.watch(superAdminRepositoryProvider).listDistributors();

/// Which catalog the super admin is bulk-importing.
enum ImportType { areas, shops, items }

/// Report column headers (without the trailing `issue`) per shape.
const _shopReportHeaders = [
  'area',
  'shop',
  'retailer_code',
  'address',
  'gst_no',
  'mobile',
  'shop_owner',
];
const _itemReportHeaders = [
  'brand',
  'item_code',
  'item',
  'hsn',
  'mrp',
  'rate',
  'gst',
  'pack',
];

enum ImportPhase { idle, parsing, validating, submitting, done }

/// Outcome of a completed import.
@freezed
abstract class ImportResult with _$ImportResult {
  const factory ImportResult({
    required int added,
    required int skipped,
  }) = _ImportResult;
}

/// UI state for the bulk-import screen (areas, shops, items).
@freezed
abstract class BulkImportState with _$BulkImportState {
  const factory BulkImportState({
    @Default(ImportType.areas) ImportType type,
    Distributor? distributor,
    String? fileName,
    AreaImportParse? areaParse,
    ShopSheetParse? shopParse,
    ItemSheetParse? itemParse,
    // Shared insert plan for shops/items (only one type active at a time).
    ImportPlan? plan,
    @Default(ImportPhase.idle) ImportPhase phase,
    ImportResult? result,
    String? errorMessage,
  }) = _BulkImportState;
}

@riverpod
class BulkImport extends _$BulkImport {
  @override
  BulkImportState build() => const BulkImportState();

  void selectType(ImportType type) {
    if (type == state.type) return;
    // Switching catalog invalidates any picked file / parse / plan.
    state = BulkImportState(type: type, distributor: state.distributor);
  }

  Future<void> selectDistributor(Distributor distributor) async {
    state = state.copyWith(
      distributor: distributor,
      result: null,
      errorMessage: null,
    );
    // A shops/items file already parsed can now be validated against this
    // tenant.
    if (state.type == ImportType.shops &&
        (state.shopParse?.hasFatalError == false)) {
      await _validateShops();
    } else if (state.type == ImportType.items &&
        (state.itemParse?.hasFatalError == false)) {
      await _validateItems();
    }
  }

  /// Parses a picked file's [bytes] according to the active [ImportType].
  Future<void> parseFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    switch (state.type) {
      case ImportType.areas:
        final parse =
            ref.read(excelImportServiceProvider).parseAreaColumn(bytes);
        state = state.copyWith(
          fileName: fileName,
          areaParse: parse,
          result: null,
          errorMessage: null,
        );
      case ImportType.shops:
        state = state.copyWith(
          fileName: fileName,
          phase: ImportPhase.parsing,
          shopParse: null,
          plan: null,
          result: null,
          errorMessage: null,
        );
        // Parse off the UI thread — sheets can be 1000+ rows.
        final parse = await compute(parseShopSheetBytes, bytes);
        state = state.copyWith(phase: ImportPhase.idle, shopParse: parse);
        if (!parse.hasFatalError && state.distributor != null) {
          await _validateShops();
        }
      case ImportType.items:
        state = state.copyWith(
          fileName: fileName,
          phase: ImportPhase.parsing,
          itemParse: null,
          plan: null,
          result: null,
          errorMessage: null,
        );
        final parse = await compute(parseItemSheetBytes, bytes);
        state = state.copyWith(phase: ImportPhase.idle, itemParse: parse);
        if (!parse.hasFatalError && state.distributor != null) {
          await _validateItems();
        }
    }
  }

  /// Resolves areas + existing retailer codes for the chosen distributor and
  /// builds the insert plan (rows to add, duplicates to skip, blocking issues).
  Future<void> _validateShops() async {
    final distributor = state.distributor;
    final parse = state.shopParse;
    if (distributor == null || parse == null || parse.hasFatalError) {
      state = state.copyWith(plan: null);
      return;
    }

    state = state.copyWith(phase: ImportPhase.validating, errorMessage: null);
    try {
      final repo = ref.read(superAdminRepositoryProvider);
      final areaRes = await repo.areaNameToIdMap(distributor.id);
      final existingCodes =
          await repo.existingShopNumbersLower(distributor.id);

      final structuralRows = {
        for (final i in parse.structuralIssues) i.row.rowNumber,
      };
      final blocking = <RowIssue>[...parse.structuralIssues];
      final skipped = <RowIssue>[];
      final toInsert = <Map<String, dynamic>>[];

      for (final row in parse.rows) {
        if (structuralRows.contains(row.rowNumber)) continue;

        final areaKey = row.area.toLowerCase();
        if (areaRes.ambiguous.contains(areaKey)) {
          blocking.add(RowIssue(row: row, issue: 'ambiguous area name'));
          continue;
        }
        final areaId = areaRes.map[areaKey];
        if (areaId == null) {
          blocking.add(RowIssue(row: row, issue: 'area not found'));
          continue;
        }
        if (existingCodes.contains(row.retailerCode.toLowerCase())) {
          skipped.add(
            RowIssue(row: row, issue: 'retailer_code already exists'),
          );
          continue;
        }
        toInsert.add({
          'area_id': areaId,
          'shop_name': row.shop,
          'shop_address': row.address,
          'shop_number': row.retailerCode,
          // Optional values: omit when blank so they store NULL, not '',
          // matching the admin add-shop path.
          if (row.shopOwner.isNotEmpty) 'shop_owner': row.shopOwner,
          if (row.mobile.isNotEmpty) 'phone_no': row.mobile,
          if (row.gstNo.isNotEmpty) 'gstin': row.gstNo,
        });
      }

      blocking.sort((a, b) => a.row.rowNumber.compareTo(b.row.rowNumber));

      state = state.copyWith(
        phase: ImportPhase.idle,
        plan: ImportPlan(
          toInsert: toInsert,
          skipped: skipped,
          blocking: blocking,
        ),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        phase: ImportPhase.idle,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Splits the parsed items into insert / skip (existing item_code) / blocking
  /// (structural) once a distributor is chosen.
  Future<void> _validateItems() async {
    final distributor = state.distributor;
    final parse = state.itemParse;
    if (distributor == null || parse == null || parse.hasFatalError) {
      state = state.copyWith(plan: null);
      return;
    }

    state = state.copyWith(phase: ImportPhase.validating, errorMessage: null);
    try {
      final existingCodes = await ref
          .read(superAdminRepositoryProvider)
          .existingItemCodesLower(distributor.id);

      final structuralRows = {
        for (final i in parse.structuralIssues) i.row.rowNumber,
      };
      final blocking = <RowIssue>[...parse.structuralIssues];
      final skipped = <RowIssue>[];
      final toInsert = <Map<String, dynamic>>[];

      for (final row in parse.rows) {
        if (structuralRows.contains(row.rowNumber)) continue;

        if (existingCodes.contains(row.itemCode.toLowerCase())) {
          skipped.add(
            RowIssue(row: row, issue: 'item_code already exists'),
          );
          continue;
        }
        toInsert.add({
          'item_code': row.itemCode,
          'item_name': row.item,
          'mrp': double.parse(row.mrp),
          'base_rate': double.parse(row.rate),
          'gst_percent': int.parse(row.gst),
          'pack': int.parse(row.pack),
          'brand': row.brand,
          'hsn_code': row.hsn,
          'is_active': true,
        });
      }

      blocking.sort((a, b) => a.row.rowNumber.compareTo(b.row.rowNumber));

      state = state.copyWith(
        phase: ImportPhase.idle,
        plan: ImportPlan(
          toInsert: toInsert,
          skipped: skipped,
          blocking: blocking,
        ),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        phase: ImportPhase.idle,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// True when the active import type has everything it needs to submit.
  bool get canSubmit {
    if (state.distributor == null || state.phase == ImportPhase.submitting) {
      return false;
    }
    return switch (state.type) {
      ImportType.areas => state.areaParse?.isValid ?? false,
      ImportType.shops || ImportType.items => state.plan?.canImport ?? false,
    };
  }

  Future<void> submit() async {
    switch (state.type) {
      case ImportType.areas:
        await _submitAreas();
      case ImportType.shops:
        await _submitPlan(_shopRepoInsert);
      case ImportType.items:
        await _submitPlan(_productRepoInsert);
    }
  }

  Future<void> _shopRepoInsert(
    String distributorId,
    List<Map<String, dynamic>> rows,
  ) => ref
      .read(superAdminRepositoryProvider)
      .bulkInsertShops(distributorId, rows);

  Future<void> _productRepoInsert(
    String distributorId,
    List<Map<String, dynamic>> rows,
  ) => ref
      .read(superAdminRepositoryProvider)
      .bulkInsertProducts(distributorId, rows);

  Future<void> _submitAreas() async {
    final distributor = state.distributor;
    final parse = state.areaParse;
    if (distributor == null || parse == null || !parse.isValid) return;

    state = state.copyWith(phase: ImportPhase.submitting, errorMessage: null);
    try {
      final repo = ref.read(superAdminRepositoryProvider);
      final existing = await repo.existingAreaNamesLower(distributor.id);
      final toInsert = [
        for (final name in parse.names)
          if (!existing.contains(name.toLowerCase())) name,
      ];
      await repo.bulkInsertAreas(distributor.id, toInsert);
      state = state.copyWith(
        phase: ImportPhase.done,
        result: ImportResult(
          added: toInsert.length,
          skipped: parse.names.length - toInsert.length,
        ),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        phase: ImportPhase.idle,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Shared submit for the plan-based imports (shops, items). [insert] performs
  /// the type-specific atomic batch insert.
  Future<void> _submitPlan(
    Future<void> Function(String distributorId, List<Map<String, dynamic>> rows)
        insert,
  ) async {
    final distributor = state.distributor;
    final plan = state.plan;
    if (distributor == null || plan == null || !plan.canImport) return;

    state = state.copyWith(phase: ImportPhase.submitting, errorMessage: null);
    try {
      await insert(distributor.id, plan.toInsert);
      state = state.copyWith(
        phase: ImportPhase.done,
        result: ImportResult(
          added: plan.toInsert.length,
          skipped: plan.skipped.length,
        ),
      );
    } on Exception catch (e) {
      state = state.copyWith(
        phase: ImportPhase.idle,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Report column headers for the active import type.
  List<String> get _reportHeaders => switch (state.type) {
        ImportType.items => _itemReportHeaders,
        _ => _shopReportHeaders,
      };

  String get _reportNoun =>
      state.type == ImportType.items ? 'Item' : 'Shop';

  /// Shares the `.xlsx` of blocking rows (those preventing the import).
  Future<void> shareErrorReport() async {
    final blocking = state.plan?.blocking ?? const [];
    if (blocking.isEmpty) return;
    final file = await ref.read(importReportServiceProvider).generate(
          _reportHeaders,
          blocking,
          namePrefix: '${state.type.name}_import_errors',
        );
    await ref
        .read(importShareServiceProvider)
        .shareFile(file, subject: '$_reportNoun import — rows to fix');
  }

  /// Shares the `.xlsx` of rows skipped as existing duplicates.
  Future<void> shareSkippedReport() async {
    final skipped = state.plan?.skipped ?? const [];
    if (skipped.isEmpty) return;
    final file = await ref.read(importReportServiceProvider).generate(
          _reportHeaders,
          skipped,
          namePrefix: '${state.type.name}_import_skipped',
        );
    await ref
        .read(importShareServiceProvider)
        .shareFile(file, subject: '$_reportNoun import — skipped rows');
  }

  void reset() =>
      state = BulkImportState(type: state.type, distributor: state.distributor);
}
