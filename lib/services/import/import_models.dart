/// Plain data types shared by the bulk-import parsers, validators and reports.
///
/// Kept free of Flutter/Supabase deps so the parsers can run in a background
/// isolate and stay easy to unit-test.
library;

/// A parsed sheet row that can appear in a downloadable issue report.
///
/// Implemented by each import type's row (shops, items) so the report service
/// and [RowIssue] stay type-agnostic.
abstract interface class ImportRowData {
  /// 1-based spreadsheet row number (maps an issue back to the user's file).
  int get rowNumber;

  /// Original cell values, in the sheet's column order (for the report).
  List<String> toReportCells();
}

/// One parsed row of a SHOPS.xlsx sheet.
class ShopRow implements ImportRowData {
  const ShopRow({
    required this.rowNumber,
    required this.area,
    required this.shop,
    required this.retailerCode,
    required this.address,
    required this.gstNo,
    required this.mobile,
    required this.shopOwner,
  });

  @override
  final int rowNumber;
  final String area;
  final String shop;
  final String retailerCode;
  final String address;
  final String gstNo;
  final String mobile;
  final String shopOwner;

  @override
  List<String> toReportCells() =>
      [area, shop, retailerCode, address, gstNo, mobile, shopOwner];
}

/// One parsed row of an ITEMS.xlsx sheet (raw strings; typed/validated later).
class ItemRow implements ImportRowData {
  const ItemRow({
    required this.rowNumber,
    required this.brand,
    required this.itemCode,
    required this.item,
    required this.hsn,
    required this.mrp,
    required this.rate,
    required this.gst,
    required this.pack,
  });

  @override
  final int rowNumber;
  final String brand;
  final String itemCode;
  final String item;
  final String hsn;
  final String mrp;
  final String rate;
  final String gst;
  final String pack;

  @override
  List<String> toReportCells() =>
      [brand, itemCode, item, hsn, mrp, rate, gst, pack];
}

/// A row that can't be imported (blocking) or was skipped, with a reason
/// written into the downloadable report's `issue` column.
class RowIssue {
  const RowIssue({required this.row, required this.issue});

  final ImportRowData row;
  final String issue;
}

/// Result of structurally parsing a shops/items sheet (no network / no
/// distributor context yet).
///
/// [fatalError] is non-null when the whole file is unusable (unreadable, or a
/// required header column is missing) — nothing else is populated. Otherwise
/// [rows] holds every non-empty data row and [structuralIssues] holds the
/// per-row problems detectable without the distributor (missing/mistyped
/// fields, in-file duplicate key).
class ShopSheetParse {
  const ShopSheetParse({
    this.fatalError,
    this.rows = const [],
    this.structuralIssues = const [],
  });

  const ShopSheetParse.fatal(String message) : this(fatalError: message);

  final String? fatalError;
  final List<ShopRow> rows;
  final List<RowIssue> structuralIssues;

  bool get hasFatalError => fatalError != null;
}

/// Structural parse result for an ITEMS.xlsx (mirrors [ShopSheetParse]).
class ItemSheetParse {
  const ItemSheetParse({
    this.fatalError,
    this.rows = const [],
    this.structuralIssues = const [],
  });

  const ItemSheetParse.fatal(String message) : this(fatalError: message);

  final String? fatalError;
  final List<ItemRow> rows;
  final List<RowIssue> structuralIssues;

  bool get hasFatalError => fatalError != null;
}

/// Fully-validated import plan, produced once a distributor is chosen: the rows
/// to insert, the rows skipped as existing duplicates, and any blocking issues
/// that abort the import. Shared by shops and items.
class ImportPlan {
  const ImportPlan({
    required this.toInsert,
    required this.skipped,
    required this.blocking,
  });

  /// Insert-ready row maps (FKs resolved, values typed).
  final List<Map<String, dynamic>> toInsert;
  final List<RowIssue> skipped;
  final List<RowIssue> blocking;

  bool get canImport => blocking.isEmpty;
}
