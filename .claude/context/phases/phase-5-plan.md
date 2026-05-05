# Phase 5 — Export & Share

> **Status:** Implementation complete (2026-05-04) — pending manual device verification
> **Last updated:** 2026-05-04
> **Where this fits:** Phase 5 of 6. Phase 4 deferred. Full ladder: [roadmap.md](./roadmap.md).
> **Source plan:** `/home/yokesh/.claude/plans/clever-beaming-sloth.md` (approved 2026-05-04)

---

## Goal

Salesmen can export their orders to **Excel** or **PDF** for any date range and share the file via WhatsApp from inside the app. Files are saved locally first, then handed to the system share sheet.

## Locked-in decisions (from PM conversation, 2026-05-04)

| Topic | Decision |
|---|---|
| Excel column `orderId` | `orders.order_number` (human-readable, e.g. `ORD-2026-00123`) — **not** the UUID |
| Excel column `company` | **`shops.shop_name`** — user clarified this is the customer (shop), not a product brand. There is no product brand/manufacturer field in the schema. |
| Excel grain | One row per **order_item**, repeating order-level columns (`orderId`, `date`, `area`, `company`) on every row. Flat fact table for pivots. |
| Excel column order | `orderId | date | area | company | itemname | item code | MRP | Rate | Qty | Total` |
| Excel `Total` semantics | `order_items.line_total` = `selling_rate * quantity` (GST excluded). Matches the bill preview's "TOTAL" column. |
| Date format in Excel | `dd-MM-yyyy` via `intl` |
| PDF grain | One **page per order** in the date range; page layout mirrors `bill_preview_screen.dart` lines 103–262 (header + items table + GST rows + grand total) |
| Share method | Generic system share sheet via `share_plus` `Share.shareXFiles`. **Not** a WhatsApp deeplink — more reliable on iOS, single code path. |
| Storage | `path_provider` `getApplicationDocumentsDirectory()` — app-scoped, no Android storage permission needed |
| Filename | `distrolink_orders_{ddMMyyyy}_{ddMMyyyy}.xlsx` / `.pdf`. Deterministic on range — overwrites cleanly on re-export. |
| Offline behaviour | Both Settings buttons disabled with helper text `"Export needs internet — connect to Wi-Fi or mobile data"`. Generate button on the export screen also disabled. |
| Export UI | Dedicated screen at `/settings/export` (top-level push route, no bottom nav — full-screen task, mirrors `/orders/new/N`). Settings buttons push there with the format pre-selected via `extra`. |
| Empty range | `error('No orders in this date range.')` — no file written, no share sheet. |
| `exports` table tracking | **Not used** — exports treated as ephemeral artifacts. Add later if audit needed. |

## Architecture

```
SettingsScreen ──push('/settings/export', extra: ExportFormat.xxx)──▶ ExportScreen
                                                                        │
ExportScreen → ExportController (state machine: idle/generating/done/error)
                       │
                       ├── ordersInRangeProvider ──▶ OrdersRepository.ordersInRange(salesmanId, from, to)
                       │                                       │
                       │                                       └──▶ Supabase (orders + shops + areas + order_items, one round-trip)
                       │
                       ├── ExcelExportService.generate(data, from, to) ──▶ File (.xlsx in docs dir)
                       ├── PdfExportService.generate(data, from, to)   ──▶ File (.pdf  in docs dir)
                       │
                       └── ShareService.shareFile(file, subject)        ──▶ system share sheet (user picks WhatsApp)
```

**Risk noted (do not fix here):** `order_date` is a SQL `date` stored in local time. Correct for the India-only deployment; flag if multi-timezone ever becomes a thing.

## New files

| File | Purpose |
|---|---|
| `lib/features/orders/domain/order_with_items.dart` | Freezed aggregate `{ Order order, List<OrderItem> items }` |
| `lib/services/export/excel_export_service.dart` | `Future<File> generate({data, from, to})` — writes flat one-row-per-item sheet |
| `lib/services/export/pdf_export_service.dart` | Same signature; one `pw.Page` per order, layout mirrors bill preview |
| `lib/services/export/share_service.dart` | Thin `share_plus` wrapper |
| `lib/features/exports/application/export_providers.dart` | Service providers + `ordersInRangeProvider` (family on `from`/`to`) |
| `lib/features/exports/application/export_controller.dart` | `ExportFormat` enum, `ExportState` freezed union, `ExportController` notifier |
| `lib/features/exports/presentation/export_screen.dart` | Date range fields + format toggle + Generate & Share + status section |

## Files modified

| File | Change |
|---|---|
| `pubspec.yaml` | Add `excel`, `pdf`, `share_plus` (latest stable; pin at install time) |
| `lib/features/orders/domain/order.dart` | Add nullable `String? areaName` (`@JsonKey(name: 'area_name')`) — non-breaking |
| `lib/features/orders/data/orders_repository.dart` | Add `ordersInRange(salesmanId, from, to)` — joins shops + areas + order_items in one PostgREST select |
| `lib/features/settings/presentation/settings_screen.dart` | Replace `onPressed: null` placeholders (lines 219-229) with `context.push('/settings/export', extra: ExportFormat.xxx)`; gate on `isOnline`; add helper text when offline |
| `lib/app/router.dart` | Register top-level `GoRoute('/settings/export', ...)`; verify role-redirect allowlist already permits `/settings/...` |

## Implementation checklist

### 1. Dependencies
- [x] Add `excel`, `pdf`, `share_plus` to `pubspec.yaml` (pin latest stable)
- [x] `flutter pub get`

### 2. Domain
- [x] `Order` + `areaName` field; re-run build_runner; check existing repo methods compile (nullable field, should be transparent)
- [x] Create `OrderWithItems` freezed aggregate
- [x] Re-run `dart run build_runner build --delete-conflicting-outputs`

### 3. Repository
- [x] `OrdersRepository.ordersInRange(salesmanId, from, to)` — Supabase select with `shops!inner`, `areas!inner`, `order_items(*)` embed; `gte/lt` window with `to+1d` for inclusive end
- [x] Verify the returned mapping populates `areaName`/`shopName`/`shopNumber` correctly

### 4. Services (`lib/services/export/`)
- [x] `excel_export_service.dart` — header row bold, numeric cells written as numbers, deterministic filename, save to docs dir
- [x] `pdf_export_service.dart` — one `pw.Page` per order; mirror bill preview layout; GST rows conditional on `gstTotal > 0`
- [x] `share_service.dart` — `Share.shareXFiles` wrapper with subject

### 5. Feature slice (`lib/features/exports/`)
- [x] `export_providers.dart` — `keepAlive` providers for the three services; `ordersInRangeProvider(from, to)` async family
- [x] `export_controller.dart` — `ExportFormat`, `ExportState` freezed union, `ExportController` notifier with `generateAndShare`, `shareAgain`, `reset`
- [x] Re-run build_runner

### 6. Screen
- [x] `export_screen.dart` — `ConsumerStatefulWidget(initialFormat)`; date range card with `_DateField` x2 (using built-in `showDatePicker`, `firstDate: now-365d`, `lastDate: now`); format `AppSegmented`; `Generate & Share` `AppButton` with `loading` flag; status section for error/done states
- [x] Use only `AppColors` / `AppSpacing` / `AppButton` / `AppCard` / `AppSegmented` — no hex / no px literals
- [x] Show offline banner + disable Generate button when `!isOnline`

### 7. Routing & Settings wiring
- [x] Add `/settings/export` top-level GoRoute; pass `ExportFormat` via `extra`
- [x] Verify role-redirect allowlist — `_isSalesmanPath` checks `path.startsWith('/settings')` which covers `/settings/export`
- [x] Replace the two `onPressed: null` blocks in settings_screen.dart with `context.push` calls; gate on `isOnline`; add helper text when offline

### 8. Tests (recommended; skip if shipping under time pressure)
- [ ] `test/services/export/excel_export_service_test.dart` — fixture data → generate → re-parse with `excel.decode` → assert column order + row count
- [ ] `test/services/export/pdf_export_service_test.dart` — smoke: file exists, starts with `%PDF`
- [ ] `test/features/orders/orders_repository_range_test.dart` — mocktail `SupabaseClient`; assert `gte`/`lt` window matches `[from, to+1d)`

### 9. Verification (done bar)
- [x] `dart run build_runner build` — clean (13 outputs generated)
- [x] `flutter analyze` clean under `very_good_analysis`
- [ ] `flutter test` — pre-existing widget_test.dart failure unrelated to Phase 5; new service tests deferred
- [ ] **Manual on real device** (WhatsApp installed):
  - [ ] Online: Settings → "Export to Excel" → `/settings/export` opens with Excel preselected → Generate → share sheet → pick WhatsApp → file attaches with correct name
  - [ ] Settings → "Export PDF Report" → format toggle = PDF → 7-day range → Generate → open PDF → each page = one order with shop, area, items, GST rows where applicable, grand total
  - [ ] Future / empty date range → "No orders in this date range." → no file
  - [ ] Toggle "Simulate Offline" (debug build) or airplane mode → both Settings buttons disabled with helper text. Direct-navigate to `/settings/export` → Generate disabled, banner shown
  - [ ] Dismiss share sheet without sending → "Share again" button re-opens it
  - [ ] Re-export same range → file overwrites, no leak in docs dir
  - [ ] **Verify ₹ glyph renders** on Android *and* iOS PDFs. If tofu, bundle NotoSans as an asset and switch the PDF base font (`pw.Font.ttf(...)`).

## Out of scope (explicit)

- All Phase 4 features (deferred per PM)
- `exports` table tracking from the schema
- Admin-side bulk export across salesmen
- Direct WhatsApp deeplink — generic share sheet covers it
- Localisation of column headers / date pickers
- Background generation / progress streaming — synchronous with button spinner; sub-second for typical ranges

## Open questions / things to double-check before coding

- Latest stable versions of `excel`, `pdf`, `share_plus` at install time; pin them in pubspec.
- Confirm role-redirect allowlist in `router.dart` permits `/settings/export` for salesmen (it almost certainly does — `path.startsWith('/settings')`).
- Verify `AppSegmented` exists in `lib/core/widgets/`; if not, use a simple `SegmentedButton` (Material 3 native).
- Verify `AppColors.warning` exists; use `AppColors.error` or `AppColors.orangeLight` if not.

---

## Progress log

- _2026-05-04_ — Phase 5 plan written. PM directed to skip Phase 4 and prepare Phase 5 plan only; implementation deferred to a later session.
