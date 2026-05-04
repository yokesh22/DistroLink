# Phase 3 — Offline-First

> **Status:** In progress
> **Last updated:** 2026-05-03
> **Where this fits:** Phase 3 of 6. Full ladder: [roadmap.md](./roadmap.md).

---

## Goal

Salesmen can complete orders in shops with no connectivity. The app behaves correctly under flaky 2G/3G.

## Locked-in decisions

| Topic | Decision |
|---|---|
| Local DB | **hive_ce** (Isar 3 dropped — incompatible with riverpod_generator 4.x / source_gen) |
| Cache strategy | Stale-while-revalidate for reads; outbox for writes |
| Sync trigger | `connectivity_plus` listener in `SyncWorker` Riverpod notifier |
| Idempotency | Client-generated UUID (`localId`) stored in outbox |
| Conflict resolution | Server wins for cached reads; no edit conflicts on orders |
| Outbox scope | `orders` + `order_items` only (reads cache areas/shops/products) |

## Architecture

```
UI → Riverpod provider → Repository → ┬── Supabase (online)
                                      └── Isar (local cache + outbox)
                                          └── SyncWorker (drains outbox when online)
```

**Read-side cache** — areas, shops, products cached in Isar. Stale-while-revalidate:
serve from Isar immediately, revalidate from Supabase in background.

**Write-side outbox** — orders queued in `OutboxOrder` collection when offline.
`SyncWorker` listens to `isOnlineProvider` and drains on reconnect.

## New files

| File | Purpose |
|---|---|
| `lib/services/hive/outbox_order.dart` | Plain Dart `OutboxOrder` + `OutboxOrderItem` + `OutboxStatus` enum |
| `lib/services/hive/hive_service.dart` | `HiveService` holding all open boxes |
| `lib/services/hive/hive_provider.dart` | Opens Hive boxes; `hiveServiceProvider` |
| `lib/services/sync/sync_worker.dart` | keepAlive notifier; drains outbox on reconnect |
| `lib/services/sync/pending_sync_provider.dart` | `pendingSyncCountProvider` stream via `box.watch()` |

## Implementation checklist

### 1. Dependencies
- [x] Add `isar: ^3.1.0+1`, `isar_flutter_libs: ^3.1.0+1` to dependencies
- [x] Add `isar_generator: ^3.1.0+1` to dev_dependencies
- [x] Remove `hive_ce`, `hive_ce_flutter`

### 2. Hive service
- [x] `hive_service.dart` — `HiveService` data class holding all boxes
- [x] `hive_provider.dart` — async keepAlive `hiveServiceProvider`; opens `areas`, `shops`, `products`, `outbox` boxes
- [x] `outbox_order.dart` — plain Dart `OutboxOrder` / `OutboxOrderItem` / `OutboxStatus`; `toJson`/`fromJson`

### 3. Repositories updated
- [x] `AreasRepository(client, hive)` — stale-while-revalidate; in-Dart sort
- [x] `ShopsRepository(client, hive)` — stale-while-revalidate per area; key-based delete on revalidate
- [x] `ProductsRepository(client, hive)` — stale-while-revalidate; in-Dart search on cache
- [x] `OrdersRepository(client, hive)` — `submit()` checks connectivity; offline → hive outbox box; exposes `syncOutboxOrder()`

### 4. Sync services
- [x] `sync_worker.dart` — `SyncWorker` notifier: listens to `isOnlineProvider`, calls `drain()`; exposes `drain()` for Force Sync
- [x] `pending_sync_provider.dart` — `pendingSyncCountProvider`: Stream using `box.watch()`

### 5. Providers updated
- [x] `shop_providers.dart` — async; inject `hiveServiceProvider`
- [x] `product_providers.dart` — async; inject `hiveServiceProvider`
- [x] `order_providers.dart` — async; inject `hiveServiceProvider`; add `outboxOrdersProvider`

### 7. App wiring
- [x] `app.dart` — `ref.read(syncWorkerProvider)` to eagerly start worker

### 8. Screens
- [x] `dashboard_screen.dart` — use real `pendingSyncCountProvider`; remove `offlineSimProvider`
- [x] `orders_list_screen.dart` — real pending count; "Pending Sync" filter shows outbox orders
- [x] `bill_preview_screen.dart` — offline submit path: different snackbar message
- [x] `settings_screen.dart` — real sync count; "Force Sync Now" calls `syncWorkerProvider.forceSync()`

### 9. Verification (done bar)
- [ ] `flutter pub get && dart run build_runner build --delete-conflicting-outputs` — clean
- [ ] `flutter analyze` clean under `very_good_analysis`
- [ ] Airplane-mode test: create order offline → toggle airplane off → order syncs to Supabase within 30s
- [ ] Online test: submit order → lands in Supabase immediately, no outbox entry
- [ ] Pending count on dashboard and orders list updates in real-time
- [ ] "Force Sync Now" button drains the outbox on demand
- [ ] Settings sync card shows correct pending count and online/offline status

---

## Progress log

- _2026-05-03_ — Phase 3 plan created; implementation starting.
- _2026-05-03_ — Full implementation complete. Switched from Isar 3 (source_gen conflict with riverpod_generator 4.x) to hive_ce. `flutter analyze` clean.
