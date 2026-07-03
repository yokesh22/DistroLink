import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/services/export/catalog_export_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = CatalogExportService();
  final now = DateTime(2026, 7, 2);

  final area = Area(
    id: 'a1',
    name: 'MG Road',
    distributorId: 'd1',
    createdAt: now,
  );
  final shop = Shop(
    id: 's1',
    distributorId: 'd1',
    areaId: 'a1',
    shopName: 'Kumar Store',
    shopAddress: '12 Main St',
    createdAt: now,
    shopNumber: 'SH-041',
  );
  final product = Product(
    id: 'p1',
    distributorId: 'd1',
    itemCode: 'M1',
    itemName: 'Sunlight Bar',
    mrp: 30,
    baseRate: 25,
    gstPercent: 18,
    isActive: true,
    createdAt: now,
  );
  final salesman = Salesman(
    id: 'sm1',
    distributorId: 'd1',
    name: 'Ravi',
    phone: '9999',
    email: 'ravi@x.com',
    isActive: true,
    createdAt: now,
  );

  String? cellText(Sheet sheet, int col, int row) {
    final v = sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row))
        .value;
    return v is TextCellValue ? v.value.toString() : v?.toString();
  }

  test('includes only selected sheets, dropping the default Sheet1', () {
    final excel = service.buildWorkbook(
      products: [product],
      salesmen: [salesman],
    );
    expect(excel.sheets.keys, containsAll(<String>['Products', 'Salesmen']));
    expect(excel.sheets.keys, isNot(contains('Areas')));
    expect(excel.sheets.keys, isNot(contains('Sheet1')));
  });

  test('Shops sheet resolves area name from areasForLookup', () {
    final excel = service.buildWorkbook(
      shops: [shop],
      areasForLookup: [area],
    );
    final sheet = excel['Shops'];
    // Header row.
    expect(cellText(sheet, 0, 0), 'Shop Name');
    expect(cellText(sheet, 2, 0), 'Area');
    // First data row: area id 'a1' resolves to 'MG Road'.
    expect(cellText(sheet, 0, 1), 'Kumar Store');
    expect(cellText(sheet, 2, 1), 'MG Road');
  });

  test('empty selection yields a single (empty) default sheet, no crash', () {
    final excel = service.buildWorkbook();
    // Nothing added → default Sheet1 is kept so the workbook is never empty.
    expect(excel.sheets.keys, contains('Sheet1'));
  });
}
