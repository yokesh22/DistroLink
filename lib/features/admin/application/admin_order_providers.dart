import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/exports/application/export_providers.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_order_providers.g.dart';

@riverpod
Future<OrderWithItems> adminOrderDetail(Ref ref, String orderId) async {
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.fetchOrderById(orderId);
}

@riverpod
class SingleOrderExportController
    extends _$SingleOrderExportController {
  @override
  ExportState build(String orderId) => const ExportState.idle();

  Future<void> export(ExportFormat format) async {
    state = const ExportState.generating();
    try {
      final data = await ref.read(
        adminOrderDetailProvider(orderId).future,
      );
      final now = data.order.orderDate;

      final file = format == ExportFormat.excel
          ? await ref
              .read(excelExportServiceProvider)
              .generate(data: [data], from: now, to: now)
          : await ref
              .read(pdfExportServiceProvider)
              .generate(data: [data], from: now, to: now);

      final subject = format == ExportFormat.excel
          ? 'DistroLink Order ${data.order.orderNumber}'
          : 'DistroLink Order ${data.order.orderNumber}';

      state = ExportState.done(file);
      await ref
          .read(shareServiceProvider)
          .shareFile(file, subject: subject);
    } on Exception catch (e) {
      state = ExportState.error(e.toString());
    }
  }

  void reset() => state = const ExportState.idle();
}
