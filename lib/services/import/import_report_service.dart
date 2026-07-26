import 'dart:io';

import 'package:distro_link/services/import/import_models.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Writes the "affected rows" report for a bulk import: the sheet's original
/// columns (the `headers` minus the trailing `issue`) plus a trailing `issue`
/// column. The user fixes the flagged rows, deletes the `issue` column, and
/// re-uploads directly (the importer reads `.xlsx`). Works for any import type
/// via `ImportRowData.toReportCells`.
class ImportReportService {
  static final _stampFmt = DateFormat('yyyyMMdd_HHmmss');

  /// [headers] are the original sheet columns (without `issue`); an `issue`
  /// column is appended automatically.
  Future<File> generate(
    List<String> headers,
    List<RowIssue> issues, {
    String namePrefix = 'import_issues',
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Issues'];
    excel.delete('Sheet1');

    final fullHeaders = [...headers, 'issue'];
    for (var col = 0; col < fullHeaders.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
        ..value = TextCellValue(fullHeaders[col])
        ..cellStyle = CellStyle(bold: true);
    }

    var rowIndex = 1;
    for (final entry in issues) {
      final values = [...entry.row.toReportCells(), entry.issue];
      for (var col = 0; col < values.length; col++) {
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: rowIndex),
            )
            .value = TextCellValue(values[col]);
      }
      rowIndex++;
    }

    final dir = await getApplicationDocumentsDirectory();
    final stamp = _stampFmt.format(DateTime.now());
    final file = File('${dir.path}/${namePrefix}_$stamp.xlsx');
    final bytes = excel.encode();
    if (bytes != null) await file.writeAsBytes(bytes);
    return file;
  }
}
