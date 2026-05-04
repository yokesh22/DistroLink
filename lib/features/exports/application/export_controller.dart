import 'dart:io';

import 'package:distro_link/features/exports/application/export_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'export_controller.freezed.dart';
part 'export_controller.g.dart';

enum ExportFormat { excel, pdf }

@freezed
abstract class ExportState with _$ExportState {
  const factory ExportState.idle() = _Idle;
  const factory ExportState.generating() = _Generating;
  const factory ExportState.done(File file) = _Done;
  const factory ExportState.error(String message) = _Error;
}

@riverpod
class ExportController extends _$ExportController {
  @override
  ExportState build() => const ExportState.idle();

  Future<void> generateAndShare({
    required ExportFormat format,
    required DateTime from,
    required DateTime to,
  }) async {
    state = const ExportState.generating();
    try {
      final data = await ref.read(
        ordersInRangeProvider(from: from, to: to).future,
      );
      if (data.isEmpty) {
        state = const ExportState.error(
          'No orders in this date range.',
        );
        return;
      }

      final File file;
      final String subject;

      if (format == ExportFormat.excel) {
        file = await ref
            .read(excelExportServiceProvider)
            .generate(data: data, from: from, to: to);
        subject = 'DistroLink Orders Export';
      } else {
        file = await ref
            .read(pdfExportServiceProvider)
            .generate(data: data, from: from, to: to);
        subject = 'DistroLink Orders Report';
      }

      state = ExportState.done(file);
      await ref.read(shareServiceProvider).shareFile(file, subject: subject);
    } on Exception catch (e) {
      state = ExportState.error(e.toString());
    }
  }

  Future<void> shareAgain() async {
    final current = state;
    if (current is! _Done) return;
    await ref
        .read(shareServiceProvider)
        .shareFile(current.file, subject: 'DistroLink Export');
  }

  void reset() => state = const ExportState.idle();
}
