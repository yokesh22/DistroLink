import 'dart:io';

import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ExcelExportService {
  static final _dateFmt = DateFormat('dd-MM-yyyy');
  static final _filenameFmt = DateFormat('ddMMyyyy');

  Future<File> generate({
    required List<OrderWithItems> data,
    required DateTime from,
    required DateTime to,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Orders'];
    // createExcel() always seeds a default 'Sheet1' — remove it.
    excel.delete('Sheet1');

    final headers = [
      'orderId',
      'date',
      'Salesman',
      'area',
      'company',
      'itemname',
      'item code',
      'MRP',
      'Rate',
      'GST %',
      'Qty',
      'Discount %',
      'Free Qty',
      'Total',
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(
            columnIndex: col,
            rowIndex: 0,
          ))
          ..value = TextCellValue(headers[col])
          ..cellStyle = CellStyle(bold: true);
    }

    var rowIndex = 1;
    for (final entry in data) {
      final order = entry.order;
      final dateStr = _dateFmt.format(order.orderDate);
      for (final item in entry.items) {
        void write(int col, CellValue v) => sheet
            .cell(CellIndex.indexByColumnRow(
              columnIndex: col,
              rowIndex: rowIndex,
            ))
            .value = v;

        write(0, TextCellValue(order.orderNumber));
        write(1, TextCellValue(dateStr));
        write(2, TextCellValue(order.salesmanName ?? ''));
        write(3, TextCellValue(order.areaName ?? ''));
        write(4, TextCellValue(order.shopName ?? ''));
        write(5, TextCellValue(item.itemName));
        write(6, TextCellValue(item.itemCode));
        write(7, DoubleCellValue(item.mrp));
        write(8, DoubleCellValue(item.sellingRate));
        write(9, DoubleCellValue(item.gstPercent));
        write(10, IntCellValue(item.quantity));
        write(11, DoubleCellValue(item.discountPercent));
        write(12, IntCellValue(item.freeQty));
        write(13, DoubleCellValue(item.lineTotal));
        rowIndex++;
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    final fromStr = _filenameFmt.format(from);
    final toStr = _filenameFmt.format(to);
    final file = File(
      '${dir.path}/distrolink_orders_${fromStr}_$toStr.xlsx',
    );
    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }
}
