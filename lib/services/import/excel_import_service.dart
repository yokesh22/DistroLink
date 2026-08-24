import 'dart:typed_data';

import 'package:distro_link/core/utils/gst.dart';
import 'package:distro_link/services/import/import_models.dart';
import 'package:excel/excel.dart';

/// Result of parsing an `.xlsx` area-import sheet.
///
/// Either [error] is non-null (parsing failed — [names] is empty) or [names]
/// holds the de-duplicated, trimmed area names ready to import.
class AreaImportParse {
  const AreaImportParse.success(this.names) : error = null;
  const AreaImportParse.failure(this.error) : names = const [];

  final List<String> names;
  final String? error;

  bool get isValid => error == null;
}

/// Reads bulk-import spreadsheets. Pure / stateless — no I/O beyond decoding the
/// bytes handed to it, so it's trivially unit-testable.
class ExcelImportService {
  /// Parses an area list from [bytes] of an `.xlsx` file.
  ///
  /// Expects a single column whose header cell reads `area` (case-insensitive,
  /// whitespace-trimmed). Values below the header are trimmed; blank cells are
  /// skipped and duplicates are removed case-insensitively while preserving the
  /// first-seen order.
  AreaImportParse parseAreaColumn(Uint8List bytes) {
    final Excel excel;
    try {
      excel = Excel.decodeBytes(bytes);
    } on Object {
      // decodeBytes throws Errors (e.g. UnsupportedError) as well as
      // Exceptions on malformed / non-xlsx input — treat any failure as
      // "unreadable file".
      return const AreaImportParse.failure(
        "Couldn't read the file. Make sure it's a valid .xlsx spreadsheet.",
      );
    }

    if (excel.tables.isEmpty) {
      return const AreaImportParse.failure('The spreadsheet has no sheets.');
    }

    // Use the first sheet.
    final sheet = excel.tables.values.first;
    final rows = sheet.rows;

    // Locate the `area` header cell anywhere in the sheet (forgiving of blank
    // leading rows / columns).
    var headerRow = -1;
    var headerCol = -1;
    outer:
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < rows[r].length; c++) {
        if (_cellText(rows[r][c]).toLowerCase() == 'area') {
          headerRow = r;
          headerCol = c;
          break outer;
        }
      }
    }

    if (headerRow == -1) {
      return const AreaImportParse.failure(
        "No 'area' column found. The sheet needs a single column with the "
        "header 'area'.",
      );
    }

    final seen = <String>{};
    final names = <String>[];
    for (var r = headerRow + 1; r < rows.length; r++) {
      final row = rows[r];
      if (headerCol >= row.length) continue;
      final value = _cellText(row[headerCol]);
      if (value.isEmpty) continue;
      if (seen.add(value.toLowerCase())) names.add(value);
    }

    if (names.isEmpty) {
      return const AreaImportParse.failure(
        "The 'area' column is empty — no areas to import.",
      );
    }

    return AreaImportParse.success(names);
  }

  /// Trimmed string for a cell, tolerant of any cell value type (text/number).
  String _cellText(Data? cell) => cell?.value?.toString().trim() ?? '';
}

// ─── Shops sheet parsing ──────────────────────────────────────────────────

/// Trimmed string for a cell, tolerant of any cell value type (text/number).
String _shopCellText(Data? cell) => cell?.value?.toString().trim() ?? '';

/// Expected SHOPS.xlsx headers. `retailer_code` and `gst_no` are optional
/// (their columns may be absent); the rest must be present.
const _shopRequiredHeaders = [
  'area',
  'shop',
  'address',
  'mobile',
  'shop_owner',
];

/// Per-row mandatory fields (values must be non-empty). `mobile` and
/// `shop_owner` are optional values — their columns must still be present (see
/// `_shopRequiredHeaders`) but the cells may be left blank. `retailer_code` and
/// `gst_no` are fully optional: their columns may be omitted entirely (they are
/// not in `_shopRequiredHeaders`). A blank `retailer_code` stores NULL and is
/// exempt from the in-file / existing-code duplicate checks.
const _shopMandatoryFields = [
  'area',
  'shop',
  'address',
];

/// Parses a SHOPS.xlsx from [bytes]. **Top-level** so it can run in a
/// background isolate via `compute` (1000+ row sheets shouldn't block the UI).
///
/// Does only the checks possible without a distributor: required headers
/// present, per-row mandatory cells non-empty, and in-file duplicate
/// `retailer_code`.
/// Area-existence and existing-`retailer_code` checks happen later in the
/// validator (they need the target distributor + network).
ShopSheetParse parseShopSheetBytes(Uint8List bytes) {
  final Excel excel;
  try {
    excel = Excel.decodeBytes(bytes);
  } on Object {
    return const ShopSheetParse.fatal(
      "Couldn't read the file. Make sure it's a valid .xlsx spreadsheet.",
    );
  }

  if (excel.tables.isEmpty) {
    return const ShopSheetParse.fatal('The spreadsheet has no sheets.');
  }

  final rows = excel.tables.values.first.rows;

  // Header row = first row that has any non-empty cell.
  var headerIndex = -1;
  for (var r = 0; r < rows.length; r++) {
    if (rows[r].any((c) => _shopCellText(c).isNotEmpty)) {
      headerIndex = r;
      break;
    }
  }
  if (headerIndex == -1) {
    return const ShopSheetParse.fatal('The spreadsheet is empty.');
  }

  // Map header name (lower/trimmed) → column index.
  final headerRow = rows[headerIndex];
  final colOf = <String, int>{};
  for (var c = 0; c < headerRow.length; c++) {
    final name = _shopCellText(headerRow[c]).toLowerCase();
    if (name.isNotEmpty) colOf.putIfAbsent(name, () => c);
  }

  final missingHeaders =
      _shopRequiredHeaders.where((h) => !colOf.containsKey(h)).toList();
  if (missingHeaders.isNotEmpty) {
    return ShopSheetParse.fatal(
      'Missing required column(s): ${missingHeaders.join(', ')}. '
      'Expected: area, shop, address, mobile, shop_owner '
      '(retailer_code, gst_no optional).',
    );
  }

  String valueAt(List<Data?> row, String header) {
    final c = colOf[header];
    if (c == null || c >= row.length) return '';
    return _shopCellText(row[c]);
  }

  final parsedRows = <ShopRow>[];
  final issues = <RowIssue>[];
  final seenCodes = <String>{};

  for (var r = headerIndex + 1; r < rows.length; r++) {
    final raw = rows[r];
    // Skip wholly-empty rows silently.
    if (raw.every((c) => _shopCellText(c).isEmpty)) continue;

    final row = ShopRow(
      rowNumber: r + 1, // 1-based, matches the user's spreadsheet
      area: valueAt(raw, 'area'),
      shop: valueAt(raw, 'shop'),
      retailerCode: valueAt(raw, 'retailer_code'),
      address: valueAt(raw, 'address'),
      gstNo: valueAt(raw, 'gst_no'),
      mobile: valueAt(raw, 'mobile'),
      shopOwner: valueAt(raw, 'shop_owner'),
    );
    parsedRows.add(row);

    final missing = [
      for (final f in _shopMandatoryFields)
        if (valueAt(raw, f).isEmpty) f,
    ];
    if (missing.isNotEmpty) {
      issues.add(RowIssue(row: row, issue: 'missing: ${missing.join(', ')}'));
      continue; // don't also flag dup for a row that's already missing fields
    }

    // Only coded rows are subject to the duplicate check — a blank
    // `retailer_code` is optional, so many rows may share the empty value.
    if (row.retailerCode.isNotEmpty &&
        !seenCodes.add(row.retailerCode.toLowerCase())) {
      issues.add(
        RowIssue(row: row, issue: 'duplicate retailer_code in file'),
      );
    }
  }

  if (parsedRows.isEmpty) {
    return const ShopSheetParse.fatal('No shop rows found below the header.');
  }

  return ShopSheetParse(rows: parsedRows, structuralIssues: issues);
}

// ─── Items sheet parsing ──────────────────────────────────────────────────

/// Expected ITEMS.xlsx headers — all columns must be present.
const _itemRequiredHeaders = [
  'brand',
  'item_code',
  'item',
  'hsn',
  'mrp',
  'rate',
  'gst',
  'pack',
];

/// Per-row mandatory fields (values must be non-empty). `brand` and `hsn` are
/// optional values — their columns must still be present (see
/// `_itemRequiredHeaders`) but the cells may be left blank.
const _itemMandatoryFields = [
  'item_code',
  'item',
  'mrp',
  'rate',
  'gst',
  'pack',
];

/// Allowed GST slab values for the item import — shared with the admin
/// add/edit product dropdown so the two can't drift.
final Set<int> _gstSlab = kGstSlabs.toSet();

/// Parses [text] as an integer, tolerating a whole-number decimal (e.g. Excel
/// yielding `2.0`). Returns null when not an integer value.
///
/// Public so the import validator (`_validateItems`) coerces `gst`/`pack` with
/// the exact same rule the parser accepts them by — they must not drift (a
/// plain `int.parse('18.0')` would throw).
int? asIntValue(String text) {
  final direct = int.tryParse(text);
  if (direct != null) return direct;
  final d = double.tryParse(text);
  if (d != null && d == d.roundToDouble()) return d.toInt();
  return null;
}

/// Parses an ITEMS.xlsx from [bytes]. **Top-level** so it can run in a
/// background isolate via `compute`.
///
/// Validates (without a distributor): required headers present; per-row
/// mandatory fields non-empty (`brand`/`hsn` optional — see
/// `_itemMandatoryFields`); `mrp`/`rate` numeric (exact decimals kept); `pack`
/// an integer; `gst` an integer in `kGstSlabs` ({0, 5, 12, 18, 28, 40});
/// in-file duplicate `item_code`.
ItemSheetParse parseItemSheetBytes(Uint8List bytes) {
  final Excel excel;
  try {
    excel = Excel.decodeBytes(bytes);
  } on Object {
    return const ItemSheetParse.fatal(
      "Couldn't read the file. Make sure it's a valid .xlsx spreadsheet.",
    );
  }

  if (excel.tables.isEmpty) {
    return const ItemSheetParse.fatal('The spreadsheet has no sheets.');
  }

  final rows = excel.tables.values.first.rows;

  var headerIndex = -1;
  for (var r = 0; r < rows.length; r++) {
    if (rows[r].any((c) => _shopCellText(c).isNotEmpty)) {
      headerIndex = r;
      break;
    }
  }
  if (headerIndex == -1) {
    return const ItemSheetParse.fatal('The spreadsheet is empty.');
  }

  final headerRow = rows[headerIndex];
  final colOf = <String, int>{};
  for (var c = 0; c < headerRow.length; c++) {
    final name = _shopCellText(headerRow[c]).toLowerCase();
    if (name.isNotEmpty) colOf.putIfAbsent(name, () => c);
  }

  final missingHeaders =
      _itemRequiredHeaders.where((h) => !colOf.containsKey(h)).toList();
  if (missingHeaders.isNotEmpty) {
    return ItemSheetParse.fatal(
      'Missing required column(s): ${missingHeaders.join(', ')}. '
      'Expected: brand, item_code, item, hsn, mrp, rate, gst, pack.',
    );
  }

  String valueAt(List<Data?> row, String header) {
    final c = colOf[header];
    if (c == null || c >= row.length) return '';
    return _shopCellText(row[c]);
  }

  final parsedRows = <ItemRow>[];
  final issues = <RowIssue>[];
  final seenCodes = <String>{};

  for (var r = headerIndex + 1; r < rows.length; r++) {
    final raw = rows[r];
    if (raw.every((c) => _shopCellText(c).isEmpty)) continue;

    final row = ItemRow(
      rowNumber: r + 1,
      brand: valueAt(raw, 'brand'),
      itemCode: valueAt(raw, 'item_code'),
      item: valueAt(raw, 'item'),
      hsn: valueAt(raw, 'hsn'),
      mrp: valueAt(raw, 'mrp'),
      rate: valueAt(raw, 'rate'),
      gst: valueAt(raw, 'gst'),
      pack: valueAt(raw, 'pack'),
    );
    parsedRows.add(row);

    final problems = <String>[];

    final missing = [
      for (final h in _itemMandatoryFields)
        if (valueAt(raw, h).isEmpty) h,
    ];
    if (missing.isNotEmpty) problems.add('missing: ${missing.join(', ')}');

    if (row.mrp.isNotEmpty && double.tryParse(row.mrp) == null) {
      problems.add('mrp is not a number');
    }
    if (row.rate.isNotEmpty && double.tryParse(row.rate) == null) {
      problems.add('rate is not a number');
    }
    if (row.pack.isNotEmpty && asIntValue(row.pack) == null) {
      problems.add('pack is not an integer');
    }
    if (row.gst.isNotEmpty) {
      final gst = asIntValue(row.gst);
      if (gst == null || !_gstSlab.contains(gst)) {
        problems.add('gst must be one of ${kGstSlabs.join(', ')}');
      }
    }
    if (row.itemCode.isNotEmpty &&
        !seenCodes.add(row.itemCode.toLowerCase())) {
      problems.add('duplicate item_code in file');
    }

    if (problems.isNotEmpty) {
      issues.add(RowIssue(row: row, issue: problems.join('; ')));
    }
  }

  if (parsedRows.isEmpty) {
    return const ItemSheetParse.fatal('No item rows found below the header.');
  }

  return ItemSheetParse(rows: parsedRows, structuralIssues: issues);
}
