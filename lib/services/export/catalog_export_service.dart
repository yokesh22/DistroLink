import 'dart:io';

import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Builds a single Excel workbook holding one sheet per selected master-data
/// list (Areas / Shops / Products / Salesmen) for a distributor.
///
/// Admin-only export (see business-rules.md). Mirrors the cell-writing style of
/// `ExcelExportService` (orders export) so the two stay consistent.
class CatalogExportService {
  static final _dateFmt = DateFormat('dd-MM-yyyy');
  static final _filenameFmt = DateFormat('ddMMyyyy');

  /// Generates the workbook. Pass a non-null list to include that sheet; a
  /// null list is skipped entirely. [areas] is also used to resolve area names
  /// on the Shops sheet, so pass it whenever [shops] is included.
  Future<File> generate({
    List<Area>? areas,
    List<Shop>? shops,
    List<Product>? products,
    List<Salesman>? salesmen,
    List<Area>? areasForLookup,
  }) async {
    final excel = buildWorkbook(
      areas: areas,
      shops: shops,
      products: products,
      salesmen: salesmen,
      areasForLookup: areasForLookup,
    );

    final dir = await getApplicationDocumentsDirectory();
    final dateStr = _filenameFmt.format(DateTime.now());
    final file = File('${dir.path}/distrolink_master_data_$dateStr.xlsx');
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  /// Pure workbook construction — no file I/O, so it's unit-testable.
  /// Adds one sheet per non-null list; [areasForLookup] (falling back to
  /// [areas]) resolves area names on the Shops sheet.
  Excel buildWorkbook({
    List<Area>? areas,
    List<Shop>? shops,
    List<Product>? products,
    List<Salesman>? salesmen,
    List<Area>? areasForLookup,
  }) {
    final excel = Excel.createExcel();

    if (areas != null) _writeAreas(excel, areas);
    if (shops != null) {
      _writeShops(excel, shops, areasForLookup ?? areas ?? const []);
    }
    if (products != null) _writeProducts(excel, products);
    if (salesmen != null) _writeSalesmen(excel, salesmen);

    // createExcel() always seeds a default 'Sheet1'. Remove it only if we added
    // at least one real sheet, so the workbook is never left empty.
    if (excel.sheets.length > 1) {
      excel.delete('Sheet1');
    }
    return excel;
  }

  void _writeHeaders(Sheet sheet, List<String> headers) {
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        ..value = TextCellValue(headers[col])
        ..cellStyle = CellStyle(bold: true);
    }
  }

  void _writeAreas(Excel excel, List<Area> areas) {
    final sheet = excel['Areas'];
    _writeHeaders(sheet, ['Name', 'Created At']);
    var row = 1;
    for (final a in areas) {
      void write(int col, CellValue v) => sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .value = v;
      write(0, TextCellValue(a.name));
      write(1, TextCellValue(_dateFmt.format(a.createdAt)));
      row++;
    }
  }

  void _writeShops(Excel excel, List<Shop> shops, List<Area> areas) {
    final areaNameById = {for (final a in areas) a.id: a.name};
    final sheet = excel['Shops'];
    _writeHeaders(sheet, [
      'Shop Name',
      'Shop Number',
      'Area',
      'Address',
      'Owner',
      'Phone',
      'GSTIN',
    ]);
    var row = 1;
    for (final s in shops) {
      void write(int col, CellValue v) => sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .value = v;
      write(0, TextCellValue(s.shopName));
      write(1, TextCellValue(s.shopNumber ?? ''));
      write(2, TextCellValue(areaNameById[s.areaId] ?? ''));
      write(3, TextCellValue(s.shopAddress));
      write(4, TextCellValue(s.shopOwner ?? ''));
      write(5, TextCellValue(s.phoneNo ?? ''));
      write(6, TextCellValue(s.gstin ?? ''));
      row++;
    }
  }

  void _writeProducts(Excel excel, List<Product> products) {
    final sheet = excel['Products'];
    _writeHeaders(sheet, [
      'Item Code',
      'Item Name',
      'MRP',
      'Base Rate',
      'GST %',
      'Active',
    ]);
    var row = 1;
    for (final p in products) {
      void write(int col, CellValue v) => sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .value = v;
      write(0, TextCellValue(p.itemCode));
      write(1, TextCellValue(p.itemName));
      write(2, DoubleCellValue(p.mrp));
      write(3, DoubleCellValue(p.baseRate));
      write(4, DoubleCellValue(p.gstPercent));
      write(5, TextCellValue(p.isActive ? 'Yes' : 'No'));
      row++;
    }
  }

  void _writeSalesmen(Excel excel, List<Salesman> salesmen) {
    final sheet = excel['Salesmen'];
    _writeHeaders(sheet, ['Name', 'Phone', 'Email', 'Active']);
    var row = 1;
    for (final s in salesmen) {
      void write(int col, CellValue v) => sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
          .value = v;
      write(0, TextCellValue(s.name));
      write(1, TextCellValue(s.phone));
      write(2, TextCellValue(s.email));
      write(3, TextCellValue(s.isActive ? 'Yes' : 'No'));
      row++;
    }
  }
}
