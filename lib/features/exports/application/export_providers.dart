import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:distro_link/services/export/excel_export_service.dart';
import 'package:distro_link/services/export/pdf_export_service.dart';
import 'package:distro_link/services/export/share_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'export_providers.g.dart';

@Riverpod(keepAlive: true)
ExcelExportService excelExportService(Ref ref) => ExcelExportService();

@Riverpod(keepAlive: true)
PdfExportService pdfExportService(Ref ref) => PdfExportService();

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) => ShareService();

@riverpod
Future<List<OrderWithItems>> ordersInRange(
  Ref ref, {
  required DateTime from,
  required DateTime to,
}) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.ordersInRange(salesman.id, from, to);
}
