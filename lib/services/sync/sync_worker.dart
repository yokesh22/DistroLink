import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/hive/hive_provider.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_worker.g.dart';

enum SyncStatus { idle, syncing, done }

class SyncWorkerState {
  const SyncWorkerState({
    this.status = SyncStatus.idle,
    this.syncedCount = 0,
    this.isManual = false,
  });

  final SyncStatus status;
  final int syncedCount;

  /// True when the user tapped "Force Sync Now" (vs automatic reconnect).
  final bool isManual;

  SyncWorkerState copyWith({
    SyncStatus? status,
    int? syncedCount,
    bool? isManual,
  }) =>
      SyncWorkerState(
        status: status ?? this.status,
        syncedCount: syncedCount ?? this.syncedCount,
        isManual: isManual ?? this.isManual,
      );
}

/// Exposes sync progress so the UI can show snackbars without needing a
/// BuildContext inside the worker. Uses a manual (non-codegen) NotifierProvider
/// because StateProvider was removed in Riverpod 3.
class _SyncStatusNotifier extends Notifier<SyncWorkerState> {
  @override
  SyncWorkerState build() => const SyncWorkerState();

  SyncWorkerState get current => state;
  set current(SyncWorkerState next) => state = next;
  void reset() => state = const SyncWorkerState();
}

final syncStatusProvider =
    NotifierProvider<_SyncStatusNotifier, SyncWorkerState>(
  _SyncStatusNotifier.new,
);

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
  ///
  /// Pass [isManual] = true when triggered by the user so the UI can show
  /// an "Already up to date" message even when there's nothing to sync.
  Future<void> drain({bool isManual = false}) async {
    final statusNotifier = ref.read(syncStatusProvider.notifier);

    // Prevent concurrent drain runs.
    if (statusNotifier.current.status == SyncStatus.syncing) return;

    statusNotifier.current = SyncWorkerState(
      status: SyncStatus.syncing,
      isManual: isManual,
    );

    var syncedCount = 0;
    try {
      // Read both keepAlive dependencies synchronously to avoid awaiting a
      // future that can hang if the async provider is mid-rebuild during a
      // connectivity transition.
      final hive = ref.read(hiveServiceProvider).asData?.value;
      final client = ref.read(supabaseClientProvider);
      if (hive == null) {
        debugPrint('SyncWorker: Hive not ready, skipping drain');
        return;
      }
      final repo = OrdersRepository(client, hive);
      final toSync = repo.allPendingOrFailed();

      for (final entry in toSync) {
        // Reset failed entries back to pending before retrying.
        final toAttempt = entry.status == OutboxStatus.failed
            ? entry.copyWith(status: OutboxStatus.pending)
            : entry;
        try {
          await repo.syncOutboxOrder(toAttempt);
          syncedCount++;
        } on Exception catch (e) {
          debugPrint('SyncWorker: failed to sync ${entry.localId}: $e');
        }
      }

      if (syncedCount > 0) {
        ref
          ..invalidate(recentOrdersProvider)
          ..invalidate(salesmanStatsProvider)
          ..invalidate(pendingSyncCountProvider);
      }
    } on Exception catch (e) {
      debugPrint('SyncWorker: drain error: $e');
    } finally {
      statusNotifier.current = SyncWorkerState(
        status: SyncStatus.done,
        syncedCount: syncedCount,
        isManual: isManual,
      );
    }
  }
}
