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
  'brand',
  'item_code',
  'item',
  'hsn',
  'mrp',
  'rate',
  'gst',
  'pack',
];

List<String?> _row({
  String brand = 'Sunrise',
  String code = 'M1',
  String item = 'Biscuit 100g',
  String hsn = '1905',
  String mrp = '57.4',
  String rate = '50',
  String gst = '18',
  String pack = '24',
}) => [brand, code, item, hsn, mrp, rate, gst, pack];

void main() {
  test('parses valid rows and preserves decimals', () {
    final bytes = _buildXlsx([
      _headers,
      _row(mrp: '108.80', rate: '95.5'),
      _row(code: 'M2'),
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.length, 2);
    expect(parse.rows.first.rowNumber, 2);
    expect(parse.rows.first.mrp, '108.80'); // raw value preserved for report
    expect(parse.rows.first.rate, '95.5');
  });

  test('missing a required header is a fatal error', () {
    final headers = [..._headers]..remove('pack');
    final bytes = _buildXlsx([
      headers,
      ['Sunrise', 'M1', 'Biscuit', '1905', '57.4', '50', '18'],
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.hasFatalError, isTrue);
    expect(parse.fatalError, contains('pack'));
  });

  test('brand and hsn are optional values (blank allowed)', () {
    final bytes = _buildXlsx([
      _headers,
      _row(brand: '', hsn: ''),
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.hasFatalError, isFalse);
    expect(parse.structuralIssues, isEmpty);
    expect(parse.rows.single.brand, '');
    expect(parse.rows.single.hsn, '');
  });

  test('flags rows missing a still-mandatory field', () {
    final bytes = _buildXlsx([
      _headers,
      _row(code: '', item: ''), // item_code + item are still mandatory
      _row(code: 'M2'),
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.structuralIssues.length, 1);
    final issue = parse.structuralIssues.single.issue;
    expect(issue, contains('item_code'));
    expect(issue, contains('item'));
    // Optional fields must NOT appear in the missing list.
    expect(issue, isNot(contains('brand')));
    expect(issue, isNot(contains('hsn')));
  });

  test('flags non-numeric mrp / rate', () {
    final bytes = _buildXlsx([
      _headers,
      _row(mrp: 'abc', rate: 'xyz'),
    ]);

    final parse = parseItemSheetBytes(bytes);

    final issue = parse.structuralIssues.single.issue;
    expect(issue, contains('mrp is not a number'));
    expect(issue, contains('rate is not a number'));
  });

  test('flags non-integer pack (2.5)', () {
    final bytes = _buildXlsx([_headers, _row(pack: '2.5')]);

    final parse = parseItemSheetBytes(bytes);

    expect(
      parse.structuralIssues.single.issue,
      contains('pack is not an integer'),
    );
  });

  test('accepts whole-number pack written as 24.0', () {
    final bytes = _buildXlsx([_headers, _row(pack: '24.0')]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.structuralIssues, isEmpty);
  });

  test('accepts whole-number gst written as 18.0', () {
    final bytes = _buildXlsx([_headers, _row(gst: '18.0')]);

    final parse = parseItemSheetBytes(bytes);

    expect(parse.structuralIssues, isEmpty);
  });

  // `asIntValue` is the shared coercion the parser accepts gst/pack by AND the
  // import validator (`_validateItems`) converts them with — they must agree,
  // so an Excel-formatted `18.0`/`2.0` never throws at insert-plan build time
  // (a plain `int.parse('18.0')` would). Regression guard for that.
  group('asIntValue', () {
    test('parses plain integers', () {
      expect(asIntValue('18'), 18);
      expect(asIntValue('0'), 0);
    });

    test('coerces whole-number decimals (Excel 18.0 / 2.0)', () {
      expect(asIntValue('18.0'), 18);
      expect(asIntValue('2.0'), 2);
    });

    test('returns null for non-integer values', () {
      expect(asIntValue('2.5'), isNull);
      expect(asIntValue('abc'), isNull);
      expect(asIntValue(''), isNull);
    });
  });

  test('flags gst outside the {0,5,12,18,28,40} slab', () {
    final bytes = _buildXlsx([
      _headers,
      _row(gst: '17'), // 17 is not a valid slab value
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(
      parse.structuralIssues.single.issue,
      contains('gst must be one of 0, 5, 12, 18, 28, 40'),
    );
  });

  test('accepts each valid gst slab value', () {
    for (final gst in ['0', '5', '12', '18', '28', '40']) {
      final bytes = _buildXlsx([_headers, _row(gst: gst)]);
      final parse = parseItemSheetBytes(bytes);
      expect(parse.structuralIssues, isEmpty, reason: 'gst=$gst should pass');
    }
  });

  test('flags in-file duplicate item_code (case-insensitive)', () {
    final bytes = _buildXlsx([
      _headers,
      _row(),
      _row(item: 'Other', code: 'm1'),
    ]);

    final parse = parseItemSheetBytes(bytes);

    expect(
      parse.structuralIssues.single.issue,
      contains('duplicate item_code in file'),
    );
  });

  test('fails gracefully on non-xlsx bytes', () {
    final parse = parseItemSheetBytes(Uint8List.fromList([9, 8, 7]));
    expect(parse.hasFatalError, isTrue);
  });
}
