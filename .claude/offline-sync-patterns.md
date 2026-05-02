# Offline & Sync Patterns

> **Status:** Phase 2. Phase 1 designs around offline (UI shows banners, "pending sync" stat tile) but persistence is not yet implemented. **Don't implement Isar / outbox / sync workers in Phase 1** unless the user explicitly asks.

This file is the playbook for when we do build it. Capturing it now so future-Claude doesn't reinvent.

## Why offline matters

Salesmen work in shops with patchy 2G/3G. The hot path — creating an order — must succeed end-to-end without internet. Losing an order because the network blipped is unacceptable.

## Architecture (Phase 2 target)

```
UI → Riverpod provider → Repository → ┬── Supabase (online)
                                      └── Isar (local cache + outbox)
                                          └── SyncWorker (drains outbox when online)
```

Two distinct uses of Isar:

1. **Read-side cache** — `areas`, `shops`, `products` mirrored locally. Reads hit Isar first; the repository revalidates from Supabase in the background and refreshes the cache. Stale-while-revalidate.
2. **Write-side outbox** — `orders` and `order_items` queued locally when the network is down (or when the salesman explicitly requests it). A `SyncWorker` watches `connectivity_plus` and drains the outbox.

## Read cache — pattern

For each cacheable resource, the repository becomes:

```dart
class ShopsRepository {
  ShopsRepository(this._client, this._isar);

  Future<List<Shop>> listByArea(String areaId) async {
    final cached = await _isar.shops
        .filter()
        .areaIdEqualTo(areaId)
        .findAll();
    if (cached.isNotEmpty) {
      // Background revalidate — don't await
      _revalidate(areaId).ignore();
      return cached;
    }
    return _revalidate(areaId);
  }

  Future<List<Shop>> _revalidate(String areaId) async {
    final fresh = await _client.from('shops').select().eq('area_id', areaId);
    final shops = fresh.map(Shop.fromJson).toList();
    await _isar.writeTxn(() async {
      await _isar.shops.filter().areaIdEqualTo(areaId).deleteAll();
      await _isar.shops.putAll(shops);
    });
    return shops;
  }
}
```

The provider can `ref.invalidate(...)` after revalidation to push fresh data into the UI.

## Write outbox — pattern

```dart
class OrdersRepository {
  Future<String> submit(OrderDraft draft) async {
    if (await _connectivity.isOnline) {
      try {
        return await _submitOnline(draft);
      } on SocketException {
        return _enqueueOffline(draft);
      }
    }
    return _enqueueOffline(draft);
  }

  Future<String> _enqueueOffline(OrderDraft draft) async {
    final localId = const Uuid().v4();
    await _isar.writeTxn(() => _isar.outboxOrders.put(
      OutboxOrder.fromDraft(draft, localId: localId, status: OutboxStatus.pending),
    ));
    return localId; // local id; replaced with server id after sync
  }
}
```

Keys:
- **Local-first id.** Generate a UUID locally so the UI has something to reference immediately.
- **Idempotency.** Outbox rows store everything needed to retry. The server endpoint should accept a client-generated id (or `client_request_id`) to dedupe.
- **Status field:** `pending` → `syncing` → `synced` (delete after grace period) | `failed` (with retry count).

## Sync worker

A long-lived service started in `bootstrap.dart`:

```dart
class SyncWorker {
  void start(Ref ref) {
    ref.listen(connectivityProvider, (prev, next) {
      if (next == ConnectivityResult.none) return;
      _drain(ref).ignore();
    });
  }

  Future<void> _drain(Ref ref) async {
    final pending = await ref.read(isarProvider).outboxOrders
        .filter().statusEqualTo(OutboxStatus.pending)
        .findAll();
    for (final entry in pending) {
      try {
        final serverId = await ref.read(ordersRepositoryProvider)._submitOnline(entry.draft);
        await _markSynced(entry.localId, serverId);
        ref.invalidate(recentOrdersProvider);
        ref.invalidate(salesmanStatsProvider);
      } catch (e, st) {
        await _markFailed(entry.localId, e);
      }
    }
  }
}
```

Run on a `Timer.periodic` plus connectivity listener. Don't bombard the server — back off on repeated failures.

## Conflict resolution

Phase 2 keep simple: **server wins** for cached reads (revalidation overwrites local). For writes, the salesman's submission is the truth — there is no "edit" flow that competes with another writer. If we ever add edits, revisit.

## UI rules for offline state

- **Top banner:** orange `AppOfflineBanner` ("No internet · N orders pending sync").
- **Dashboard "Pending Sync" stat tile** turns orange with the count.
- **Orders list** shows "Saved offline · will sync automatically" on each pending order, with an orange `Pending` badge. Card border becomes `1.5dp` orange.
- **Settings → Sync status card** mirrors the count and offers a "Force Sync Now" button (disabled when offline; visible only in online state, just kicks the worker).
- **Bill preview "Confirm" button** stays enabled when offline — the order goes to the outbox and the success snackbar reads "Saved offline — will sync when online".

## Phase 1 hooks (don't implement Phase 2 logic, but design around it)

In Phase 1:
- `connectivityProvider` (`connectivity_plus` wrapper) exists and powers the offline banner.
- `pendingSyncCountProvider` exists but always returns 0 unless the debug "Simulate Offline" toggle is on (then it returns 2 to demo the visual).
- `OrdersRepository.submit` calls Supabase directly. If `connectivity_plus` says offline, **error out gracefully** with a clear "Saving offline isn't available yet — please retry when online" snackbar. Do **not** silently lose the draft — the draft stays in `orderDraftProvider` so the user can retry.

This way, Phase 2 only needs to swap the repo implementation; the UI is already wired.

## Things to never do

- ❌ Pretend offline support exists when it doesn't (Phase 1: don't lie about a successful save).
- ❌ Cache writes that affect other users (orders) silently — always show a clear "pending" indicator.
- ❌ Optimistic UI updates that can't be undone if the sync fails.
- ❌ Forget to invalidate dependent providers after a successful sync.
- ❌ Run the sync worker without a backoff policy.
