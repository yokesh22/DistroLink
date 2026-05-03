import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_worker.g.dart';

/// Long-lived service that drains the outbox whenever connectivity returns.
/// Eagerly started in DistroLinkApp via `ref.read(syncWorkerProvider)`.
@Riverpod(keepAlive: true)
class SyncWorker extends _$SyncWorker {
  @override
  void build() {
    ref.listen<bool>(isOnlineProvider, (prev, isOnline) {
      if (isOnline && prev != true) {
        drain().ignore();
      }
    });

    // Drain eagerly on startup if we're already online.
    if (ref.read(isOnlineProvider)) {
      drain().ignore();
    }
  }

  /// Drains all pending and failed outbox orders. Called on reconnect or via
  /// the "Force Sync Now" button in Settings.
  Future<void> drain() async {
    final repo = await ref.read(ordersRepositoryProvider.future);
    final toSync = repo.allPendingOrFailed();
    if (toSync.isEmpty) return;

    var syncedAny = false;
    for (final entry in toSync) {
      // Reset failed entries back to pending before retrying.
      final toAttempt = entry.status == OutboxStatus.failed
          ? entry.copyWith(status: OutboxStatus.pending)
          : entry;
      try {
        await repo.syncOutboxOrder(toAttempt);
        syncedAny = true;
      } on Exception catch (e) {
        debugPrint('SyncWorker: failed to sync ${entry.localId}: $e');
      }
    }

    if (syncedAny) {
      ref
        ..invalidate(recentOrdersProvider)
        ..invalidate(salesmanStatsProvider)
        ..invalidate(pendingSyncCountProvider);
    }
  }
}
