import 'package:intl/intl.dart';

final NumberFormat _moneyFmt = NumberFormat('#,##0.00', 'en_IN');

/// Rupee amount with the brand symbol and exactly 2 decimals, Indian comma
/// grouping. Matches the formatting used by the PDF/Excel exporters so totals
/// read consistently across the app and the exported documents.
String formatMoney(num value) => '₹${_moneyFmt.format(value)}';
