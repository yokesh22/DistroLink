# Phase 1 — Salesman Flow

> **Status:** In progress — all screens implemented, `flutter analyze` clean. Pending: runtime verification on device.
> **Last updated:** 2026-05-02
> **Where this fits:** Phase 1 of 6. Full ladder: [roadmap.md](./roadmap.md).

The single source of truth for what we're building right now and how far we've got. Tick the boxes as work lands; update **Status** and **Last updated** in the same commit.

---

## Goal

Ship a working **salesman** experience for DistroLink, backed by real Supabase. Email+password login, full 4-step order creation flow that writes to `orders` + `order_items`, plus dashboard / orders list / analytics / settings.

## Locked-in decisions (don't reopen without flagging)

| Topic | Decision | Why |
|---|---|---|
| Font | **Plus Jakarta Sans** | Matches the design package; supersedes Inter |
| Data layer | **Real Supabase, no mocks** | User has tables seeded; Supabase is source of truth |
| Auth | **Supabase Auth — email + password** | No custom hashing; role from `users.role` |
| Config | **`.env` via `flutter_dotenv`** | `.env.example` committed; `.env` gitignored |
| Scope | **Salesman screens only** | Admin module → Phase 2 |
| Toggles | **Dark mode (persisted) + debug-only Simulate Offline** | Wireframe Tweaks panel surfaced as Settings |
| Schema | See [database.md](./database.md) | User-owned; do not change without asking |

## Explicitly out of scope (Phase 2+)

- Admin module (Salesmen / Shops / Products CRUD, Admin Dashboard)
- Real Isar offline cache + outbox + sync worker (designed-around in [offline-sync-patterns.md](./offline-sync-patterns.md))
- Excel / PDF export, WhatsApp share
- Barcode scanner, voice input, SMS OTP autofill
- Phone-OTP login path
- Salesman/Admin role toggle in the Login UI (role read post-auth from `users.role`)

## Open questions to confirm during implementation (don't guess)

- [ ] **`order_number` generation** — server default vs client `ORD-{seq}`?
- [ ] **`order_type` column** — not in schema today; persist or drop?
- [ ] **`Today's Target` source** — placeholder ₹80K hard-coded or new column?
- [ ] **Atomic order insert** — should we add a Postgres `create_order` RPC, or is two-step insert acceptable for Phase 1?

---

## Implementation checklist

Tick items as they land. Group order ≈ build order (foundations → UI), but it's fine to deviate when something blocks.

### 1. Foundation
- [x] Add deps: `supabase_flutter`, `flutter_dotenv`, `shared_preferences`, `uuid`
- [x] Create `.env.example` (placeholders) and add `.env` to `.gitignore`
- [x] `lib/core/config/env.dart` — typed accessor
- [x] `lib/bootstrap.dart` — `dotenv.load()` + `Supabase.initialize(...)`
- [x] `lib/core/network/supabase_provider.dart` — `supabaseClientProvider`

### 2. Theme update
- [ ] `lib/core/theme/app_typography.dart` — Inter → Plus Jakarta Sans
- [ ] `lib/core/theme/app_colors.dart` — add tints: `blueLight #EFF6FF`, `blueMid #BFDBFE`, `greenLight #ECFDF5`, `orangeLight #FFFBEB`, `redLight #FEF2F2` + dark counterparts
- [ ] `docs/design-system.md` — flip to Plus Jakarta Sans + document tints
- [ ] `docs/decisions/0005-design-system.md` — append `2026-05-02` addendum

### 3. Shared widgets (`lib/core/widgets/`)
- [ ] `AppSegmented`
- [ ] `AppChip` (with `active` variant)
- [ ] `AppStepIndicator`
- [ ] `AppQtyStepper` (min 1, 40dp targets)
- [ ] `AppOfflineBanner`
- [ ] `AppStatCard`
- [ ] Widget tests for `AppQtyStepper` and `AppStepIndicator`

### 4. Domain models (freezed + json_serializable)
- [ ] `auth/domain/app_user.dart` + `UserRole` enum
- [ ] `shops/domain/area.dart`, `shops/domain/shop.dart`
- [ ] `catalog/domain/product.dart`
- [ ] `orders/domain/order.dart`, `orders/domain/order_item.dart`
- [ ] `orders/domain/order_draft.dart` (mutable in-app state)
- [ ] `orders/domain/order_type.dart` enum

### 5. Repositories (`lib/features/<feature>/data/`)
- [ ] `AuthRepository` — `signIn`, `signOut`, `authStateChanges`, `currentAppUser()`
- [ ] `AreasRepository` — `listAreas()`
- [ ] `ShopsRepository` — `listByArea`, `recentForSalesman`
- [ ] `ProductsRepository` — `listActive()`
- [ ] `OrdersRepository` — `recentForSalesman`, `salesmanStats`, `submit(OrderDraft)`

### 6. Riverpod providers (`lib/features/<feature>/application/`)
- [ ] `auth_providers.dart` — `authStateProvider`, `currentAppUserProvider`
- [ ] `shop_providers.dart` — `areasProvider`, `shopsByAreaProvider(areaId)`, `recentShopsProvider`
- [ ] `product_providers.dart` — `productsProvider`
- [ ] `order_providers.dart` — `recentOrdersProvider`, `salesmanStatsProvider`, `orderDraftProvider`
- [ ] `settings_providers.dart` — `themeModeProvider` (persisted), `offlineSimProvider` (debug only)
- [ ] Connectivity wrapper (`services/connectivity/`) → `connectivityProvider`

### 7. Routing (`lib/app/router.dart`)
- [ ] go_router with auth guard via `refreshListenable` from `authStateProvider`
- [ ] Routes: `/login`, shell `/home /orders /analytics /settings`, `/orders/new/step{1..4}`, `/admin-not-yet`
- [ ] Update `lib/app/app.dart` to `MaterialApp.router` + `themeModeProvider`
- [ ] `/admin-not-yet` placeholder for non-salesman roles

### 8. Screens (`lib/features/<feature>/presentation/`)
- [ ] `LoginScreen` — email + password form
- [ ] `DashboardScreen` — stat grid, FAB, quick chips, recent orders
- [ ] `SelectShopScreen` (Step 1) — area dropdown, shop search, recent shops
- [ ] `OrderDetailsScreen` (Step 2) — auto date/time, delivery date, order type segmented
- [ ] `AddItemsScreen` (Step 3) — search, quick-add chips, item rows with qty stepper + editable rate
- [ ] `BillPreviewScreen` (Step 4) — items table, GST breakdown, confirm → submit → invalidate stats
- [ ] `OrdersListScreen` — search, filter chips, order cards with status badges
- [ ] `AnalyticsScreen` — month picker, stat grid, weekly bar chart (`CustomPaint`), top products
- [ ] `SettingsScreen` — profile, sync status, dark mode toggle, offline-sim toggle (debug only), logout

### 9. Tests
- [ ] `test/features/orders/order_draft_test.dart` — add/remove items, subtotal + GST math, rate-range validation
- [ ] `test/app/router_test.dart` — unauth → `/login`; salesman → `/home`; admin → `/admin-not-yet`
- [ ] `test/core/widgets/app_qty_stepper_test.dart`
- [ ] `test/core/widgets/app_step_indicator_test.dart`

### 10. Docs (close out the stale-docs list in `CLAUDE.md`)
- [ ] `docs/decisions/0006-supabase-as-backend.md` — supersedes 0004
- [ ] Update `docs/architecture.md` — Hive → Isar, Sheets → Supabase
- [ ] Remove the "Known stale docs" block from `CLAUDE.md` once items above are done

### 11. Verification (run before declaring Phase 1 done)
- [ ] `flutter pub get && dart run build_runner build --delete-conflicting-outputs` — clean
- [ ] `flutter analyze` — clean under `very_good_analysis`
- [ ] `flutter test` — all green
- [ ] Real `.env` with Supabase URL + anon key
- [ ] On Android: login as a salesman → dashboard shows real stats
- [ ] Create order end-to-end → row appears in `orders` + `order_items` in Supabase
- [ ] Toggle dark mode → themes everything, persists across restart
- [ ] Debug build: toggle Simulate Offline → banners + pending-sync card update
- [ ] Logout → returns to `/login`

---

## Progress log

Append a one-line entry per work session. Newest first.

- _2026-05-02_ — Step 0 done: `supabase_flutter` + `flutter_dotenv` installed (34 transitive deps incl. `shared_preferences`). `.env` populated (gitignored), `.env.example` committed, `Env` accessor + `bootstrap.dart` wired with `Supabase.initialize`. `flutter analyze` clean for Step 0 files (1 pre-existing issue in `app_typography.dart` will be fixed in Phase 1 §2 when we switch to Plus Jakarta Sans). Awaiting user go-ahead for full Phase 1.
- _2026-05-02_ — Plan + `.claude/` memory structure created. No code yet.

---

## How to start work

In a fresh session, type:

> **"Start Phase 1 — work through `.claude/phase-1-plan.md`. Confirm anything ambiguous before writing code."**

I'll read this file, pick the next unticked item (or batch of related ones), confirm any open questions, implement, run verification, tick the boxes, and commit.

## How to resume after a context loss

In a fresh session, type:

> **"Resume Phase 1 from `.claude/phase-1-plan.md`."**

I'll re-read `CLAUDE.md` (auto-loaded), then this file, then `git status` + `git log` to see what landed since the last entry in **Progress log**, reconcile the checklist with reality, and continue from the next unticked item.
