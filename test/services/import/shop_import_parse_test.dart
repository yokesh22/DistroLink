import 'dart:typed_data';

import 'package:distro_link/services/import/excel_import_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds an in-memory `.xlsx` from [rows] (row-major; null = blank cell).
Uint8List _buildXlsx(List<List<String?>> rows) {
  final excel = Excel.createExcel();
  final sheet = excel['Sheet1'];
  for (var r = 0; r < rows.length; r++) {
    for (var c = 0; c < rows[r].length; c++) {
      final value = rows[r][c];
      if (value == null) continue;
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
          .value = TextCellValue(value);
    }
  }
  return Uint8List.fromList(excel.encode()!);
}

const _headers = [
  'area',
  'shop',
  'retailer_code',
  'address',
  'gst_no',
  'mobile',
  'shop_owner',
];

List<String?> _row({
  String area = 'MG Road',
  String shop = 'Kumar Store',
  String code = 'SH-001',
  String address = '12 Main St',
  String gst = '',
  String mobile = '9990001111',
  String owner = 'Ravi',
}) => [area, shop, code, address, gst, mobile, owner];

void main() {
  test('parses valid rows with row numbers', () {
    final bytes = _buildXlsx([
      _headers,
      _row(),
      _row(shop: 'Sun Mart', code: 'SH-002'),
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.length, 2);
    expect(parse.rows.first.rowNumber, 2); // header is row 1
    expect(parse.rows.first.retailerCode, 'SH-001');
    expect(parse.rows[1].shop, 'Sun Mart');
  });

  test('gst_no is optional (empty allowed)', () {
    final bytes = _buildXlsx([_headers, _row()]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.single.gstNo, '');
  });

  test('missing a required header is a fatal error', () {
    // Drop the "mobile" column entirely.
    final headers = [..._headers]..remove('mobile');
    final bytes = _buildXlsx([
      headers,
      ['MG Road', 'Kumar Store', 'SH-001', '12 Main St', '', 'Ravi'],
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isTrue);
    expect(parse.fatalError, contains('mobile'));
  });

  test('mobile, shop_owner and gst_no are optional values (blank allowed)', () {
    final bytes = _buildXlsx([
      _headers,
      _row(mobile: '', owner: ''), // gst_no blank by default → all three blank
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.single.mobile, '');
    expect(parse.rows.single.shopOwner, '');
    expect(parse.rows.single.gstNo, '');
  });

  test('flags rows missing a still-mandatory field with details', () {
    final bytes = _buildXlsx([
      _headers,
      // shop + address still mandatory; retailer_code blanked to prove it is
      // NOT reported as missing even alongside genuinely-missing fields.
      _row(address: '', shop: '', code: ''),
      _row(code: 'SH-002'),
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.rows.length, 2);
    expect(parse.structuralIssues.length, 1);
    final issue = parse.structuralIssues.single;
    expect(issue.issue, contains('address'));
    expect(issue.issue, contains('shop'));
    // Optional fields must NOT appear in the missing list.
    expect(issue.issue, isNot(contains('retailer_code')));
    expect(issue.issue, isNot(contains('mobile')));
    expect(issue.issue, isNot(contains('shop_owner')));
  });

  test('retailer_code is optional (blank allowed)', () {
    final bytes = _buildXlsx([_headers, _row(code: '')]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.single.retailerCode, '');
  });

  test('multiple blank retailer_code rows are not flagged as duplicates', () {
    final bytes = _buildXlsx([
      _headers,
      _row(shop: 'Store A', code: ''),
      _row(shop: 'Store B', code: ''),
      _row(shop: 'Store C', code: ''),
    ]);

    final parse = parseShopSheetBytes(bytes);

    // Blank codes all collapse to '' but must NOT collide as duplicates.
    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.length, 3);
  });

  test('retailer_code column may be omitted entirely', () {
    final headers = [..._headers]..remove('retailer_code');
    final bytes = _buildXlsx([
      headers,
      ['MG Road', 'Kumar Store', '12 Main St', '', '9990001111', 'Ravi'],
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.single.retailerCode, '');
  });

  test('flags in-file duplicate retailer_code (case-insensitive)', () {
    final bytes = _buildXlsx([
      _headers,
      _row(),
      _row(shop: 'Second', code: 'sh-001'),
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.structuralIssues.length, 1);
    expect(
      parse.structuralIssues.single.issue,
      contains('duplicate retailer_code'),
    );
  });

  test('trims values and skips wholly-empty rows', () {
    final bytes = _buildXlsx([
      _headers,
      _row(shop: '  Kumar Store  '),
      [null, null, null, null, null, null, null],
      _row(code: 'SH-002'),
    ]);

    final parse = parseShopSheetBytes(bytes);

    expect(parse.rows.length, 2);
    expect(parse.rows.first.shop, 'Kumar Store');
  });

  test('fails gracefully on non-xlsx bytes', () {
    final parse = parseShopSheetBytes(Uint8List.fromList([1, 2, 3, 4]));

    expect(parse.hasFatalError, isTrue);
  });
}
