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

void main() {
  final service = ExcelImportService();

  test('parses area names in order', () {
    final bytes = _buildXlsx([
      ['area'],
      ['Sector 12'],
      ['MG Road'],
      ['Ring Road'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.isValid, isTrue);
    expect(result.names, ['Sector 12', 'MG Road', 'Ring Road']);
  });

  test('header match is case-insensitive and whitespace-tolerant', () {
    final bytes = _buildXlsx([
      ['  AREA '],
      ['Sector 12'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.isValid, isTrue);
    expect(result.names, ['Sector 12']);
  });

  test('trims values and de-duplicates case-insensitively (first wins)', () {
    final bytes = _buildXlsx([
      ['area'],
      ['MG Road'],
      ['  mg road '],
      ['Sector 12'],
      ['MG ROAD'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.isValid, isTrue);
    expect(result.names, ['MG Road', 'Sector 12']);
  });

  test('skips blank rows between values', () {
    final bytes = _buildXlsx([
      ['area'],
      ['Sector 12'],
      [null],
      ['   '],
      ['MG Road'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.names, ['Sector 12', 'MG Road']);
  });

  test('fails when no area header is present', () {
    final bytes = _buildXlsx([
      ['locality'],
      ['Sector 12'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.isValid, isFalse);
    expect(result.names, isEmpty);
    expect(result.error, contains("'area'"));
  });

  test('fails when the area column has no values', () {
    final bytes = _buildXlsx([
      ['area'],
    ]);

    final result = service.parseAreaColumn(bytes);

    expect(result.isValid, isFalse);
    expect(result.error, contains('empty'));
  });

  test('fails gracefully on non-xlsx bytes', () {
    final result = service.parseAreaColumn(
      Uint8List.fromList([1, 2, 3, 4, 5]),
    );

    expect(result.isValid, isFalse);
    expect(result.names, isEmpty);
  });
}
