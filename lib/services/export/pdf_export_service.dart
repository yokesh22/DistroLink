import 'dart:io';

import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_item.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExportService {
  static final _dateFmt = DateFormat('dd-MMM-yyyy');
  static final _timeFmt = DateFormat('hh:mm a');
  static final _filenameFmt = DateFormat('ddMMyyyy');
  static final _numFmt = NumberFormat('#,##0.00', 'en_IN');

  static const _blue = PdfColor.fromInt(0xFF2563EB);
  static const _blueLight = PdfColor.fromInt(0xFFEFF6FF);
  static const _border = PdfColor.fromInt(0xFFE2E8F0);
  static const _textMuted = PdfColor.fromInt(0xFF64748B);
  static const _blueMid = PdfColor.fromInt(0xFF93C5FD);

  Future<File> generate({
    required List<OrderWithItems> data,
    required DateTime from,
    required DateTime to,
  }) async {
    final doc = pw.Document()
      ..addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin:
              const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          build: (context) {
            final widgets = <pw.Widget>[];
            for (var i = 0; i < data.length; i++) {
              if (i > 0) widgets.add(pw.NewPage());
              widgets.addAll(_buildOrder(data[i]));
            }
            return widgets;
          },
        ),
      );

    final dir = await getApplicationDocumentsDirectory();
    final fromStr = _filenameFmt.format(from);
    final toStr = _filenameFmt.format(to);
    final file = File(
      '${dir.path}/distrolink_orders_${fromStr}_$toStr.pdf',
    );
    await file.writeAsBytes(await doc.save());
    return file;
  }

  // ─── Per-order widget list ─────────────────────────────────────────

  List<pw.Widget> _buildOrder(OrderWithItems entry) {
    final order = entry.order;
    final items = entry.items;
    return [
      _header(order),
      pw.SizedBox(height: 10),
      _infoGrid(order, items),
      pw.SizedBox(height: 10),
      _itemsTable(items),
      pw.SizedBox(height: 8),
      _totals(order),
      pw.SizedBox(height: 10),
      _notesAndTerms(),
      pw.SizedBox(height: 10),
      _footer(order),
    ];
  }

  // ─── Header ───────────────────────────────────────────────────────

  pw.Widget _header(Order order) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        color: _blue,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      padding: const pw.EdgeInsets.all(14),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Branding
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'DistroLink',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Distribution Simplified',
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 8,
                ),
              ),
            ],
          ),
          // Centre title
          pw.Column(
            children: [
              pw.Text(
                'ORDER RECEIPT',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: const pw.BoxDecoration(
                  color: _blueMid,
                  borderRadius:
                      pw.BorderRadius.all(pw.Radius.circular(10)),
                ),
                child: pw.Text(
                  'Thank you for your order!',
                  style: pw.TextStyle(
                    color: _blue,
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Order meta
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                order.orderNumber,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                _dateFmt.format(order.orderDate),
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 8,
                ),
              ),
              pw.Text(
                _timeFmt.format(order.createdAt),
                style: const pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Info cards grid ──────────────────────────────────────────────

  pw.Widget _infoGrid(Order order, List<OrderItem> items) {
    final totalQty = items.fold(0, (sum, i) => sum + i.quantity);
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            children: [
              _infoCard(
                title: 'DISTRIBUTOR DETAILS',
                rows: [
                  _row('Name', order.distributorName),
                  _row('Phone', order.distributorPhone),
                  _row('Email', order.distributorEmail),
                ],
              ),
              pw.SizedBox(height: 6),
              _infoCard(
                title: 'SHOP DETAILS',
                rows: [
                  _row('Name', order.shopName),
                  _row('Code', order.shopNumber),
                  _row('Address', order.shopAddress),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Column(
            children: [
              _infoCard(
                title: 'ORDER SUMMARY',
                rows: [
                  _row('Total Items', '${items.length}'),
                  _row('Total Qty', '$totalQty'),
                  _row('Grand Total', _numFmt.format(order.grandTotal)),
                ],
              ),
              pw.SizedBox(height: 6),
              _infoCard(
                title: 'SALESMAN DETAILS',
                rows: [
                  _row('Name', order.salesmanName),
                  _row('Phone', order.salesmanPhone),
                ],
              ),
              pw.SizedBox(height: 6),
              _infoCard(
                title: 'AREA DETAILS',
                rows: [
                  _row('Area', order.areaName),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _row(String label, String? value) => [label, value ?? '-'];

  pw.Widget _infoCard({
    required String title,
    required List<List<String>> rows,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
              color: _blue,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Divider(height: 1, color: _border),
          pw.SizedBox(height: 4),
          ...rows.map(
            (r) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 52,
                    child: pw.Text(
                      r[0],
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: _textMuted,
                      ),
                    ),
                  ),
                  pw.Text(
                    ': ',
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: _textMuted,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      r[1],
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Items table ──────────────────────────────────────────────────

  pw.Widget _itemsTable(List<OrderItem> items) {
    return pw.TableHelper.fromTextArray(
      headers: [
        '#',
        'Item Name',
        'Item Code',
        'MRP',
        'Rate',
        'Qty',
        'Total',
      ],
      data: items.asMap().entries.map((e) {
        final item = e.value;
        return [
          '${e.key + 1}',
          item.itemName,
          item.itemCode,
          _numFmt.format(item.mrp),
          _numFmt.format(item.sellingRate),
          '${item.quantity}',
          _numFmt.format(item.lineTotal),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(color: _blue),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      oddRowDecoration: const pw.BoxDecoration(color: _blueLight),
      cellAlignments: {
        0: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.center,
        6: pw.Alignment.centerRight,
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(18),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(1.5),
        4: const pw.FlexColumnWidth(1.5),
        5: const pw.FixedColumnWidth(24),
        6: const pw.FlexColumnWidth(1.8),
      },
    );
  }

  // ─── Totals ───────────────────────────────────────────────────────

  pw.Widget _totals(Order order) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 210,
        child: pw.Column(
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _border),
                borderRadius: const pw.BorderRadius.only(
                  topLeft: pw.Radius.circular(6),
                  topRight: pw.Radius.circular(6),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Sub Total',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: _textMuted,
                    ),
                  ),
                  pw.Text(
                    _numFmt.format(order.subtotal),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: const pw.BoxDecoration(
                color: _blue,
                borderRadius: pw.BorderRadius.only(
                  bottomLeft: pw.Radius.circular(6),
                  bottomRight: pw.Radius.circular(6),
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Grand Total',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    _numFmt.format(order.grandTotal),
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Notes & Terms ────────────────────────────────────────────────

  pw.Widget _notesAndTerms() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: _bulletBox(
            title: 'NOTES',
            bullets: [
              'This is an order receipt, not a final tax invoice.',
              'Final invoice will be generated from billing system.',
              'Prices are subject to distributor confirmation.',
            ],
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: _bulletBox(
            title: 'TERMS & CONDITIONS',
            bullets: [
              'Goods once sold will not be taken back.',
              'Final billing handled by distributor.',
              'Subject to Bangalore jurisdiction.',
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _bulletBox({
    required String title,
    required List<String> bullets,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
              color: _blue,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Divider(height: 1, color: _border),
          pw.SizedBox(height: 4),
          ...bullets.map(
            (b) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '•  ',
                    style: const pw.TextStyle(
                      fontSize: 7,
                      color: _textMuted,
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      b,
                      style: const pw.TextStyle(
                        fontSize: 7,
                        color: _textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────

  pw.Widget _footer(Order order) {
    final phone = order.distributorPhone;
    final email = order.distributorEmail;
    final contactParts = <String>[
      if (phone != null) 'Phone: $phone',
      if (email != null) 'Email: $email',
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: pw.BoxDecoration(
        color: _blueLight,
        border: pw.Border.all(color: _border),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      child: pw.Column(
        children: [
          if (contactParts.isNotEmpty)
            pw.Text(
              contactParts.join('   |   '),
              style: const pw.TextStyle(fontSize: 8, color: _textMuted),
              textAlign: pw.TextAlign.center,
            ),
          if (contactParts.isNotEmpty) pw.SizedBox(height: 4),
          pw.Text(
            'Thank you for your business.',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _blue,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }
}
