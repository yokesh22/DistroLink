# DistroLink Roadmap — 6 Phases

The full path from "scaffold" to "every wireframe screen + every feature working end-to-end". Each phase ships independent, deployable value. Detailed checklists live in `phase-<N>-plan.md` and are created when that phase begins.

> **Currently in flight: Phase 5 (planned, not yet implemented).** See [phase-5-plan.md](./phase-5-plan.md). Phase 4 is **deferred** — Phase 5 was prioritised by the PM (2026-05-04).

## Phase ladder at a glance

| # | Phase | Status | Detailed plan |
|---|---|---|---|
| 1 | Salesman Core | ✅ Done | [phase-1-plan.md](./phase-1-plan.md) |
| 2 | Admin Module | ✅ Done | [phase-2-plan.md](./phase-2-plan.md) |
| 3 | Offline-First | ✅ Done | [phase-3-plan.md](./phase-3-plan.md) |
| 4 | Field Productivity | ⏸️ Deferred (skipped by PM 2026-05-04) | _(plan to be drafted when prioritised)_ |
| 5 | Export & Share | **In planning — implementation deferred** | [phase-5-plan.md](./phase-5-plan.md) |
| 6 | Super Admin & Multi-Tenant | Not started | _(create `phase-6-plan.md` when starting)_ |

Polish (bundled fonts, perf, accessibility, error tracking, store prep, i18n) is part of every phase's Done bar — **not** a separate phase.

---

## Phase 1 — Salesman Core

**Goal:** A working salesman experience backed by real Supabase. The hot path (login → take order → submit) works online.

**Ships these wireframe screens:** Login (email+password) · Salesman Dashboard (online state) · Step 1 Select Shop · Step 2 Order Details · Step 3 Add Items · Step 4 Bill Preview · Orders list (online) · Analytics · Settings (with dark-mode toggle + debug-only Simulate Offline)

**Notable exclusions:** Admin module · real offline persistence · barcode/voice/SMS OTP/GPS · Excel/PDF/WhatsApp · Super Admin · Login role toggle (role read post-auth from `users.role`; non-salesmen → `/admin-not-yet` placeholder).

**Dependencies:** none.

**Done bar:** all checklist items in `phase-1-plan.md` ticked, `flutter analyze` + `flutter test` clean, end-to-end order creation verified against a real Supabase instance.

---

## Phase 2 — Admin Module

**Goal:** Self-service admin can fully manage the catalog without engineering help. Removes the dependency on backend-direct edits.

**Ships these wireframe screens:** Admin Dashboard (KPIs + salesman activity) · Salesmen list · Add Salesman · Edit Salesman (with deactivate) · Shops list · Add Shop · Products list · Add / Edit Product · area management UI (areas are admin-controlled but no screen exists yet — design needed).

**Plus:** role-based routing for `admin` users → admin shell with bottom nav (Dashboard / Salesmen / Shops / Products); replaces the `/admin-not-yet` placeholder from Phase 1.

**Dependencies:** Phase 1 (auth wiring, theme, base repos). Reuses `AppCard`, `AppTextField`, `AppButton`, `AppSegmented`, `AppChip`.

**Open questions to resolve before starting:** Does the admin screen need to manage `distributors`-level fields (only super_admin)? Are areas admin-managed via a dedicated screen or implicit?

**Done bar:** an admin user can onboard a new salesman + shop + product end-to-end, deactivate them, and see real activity on the dashboard.

---

## Phase 3 — Offline-First

**Goal:** Salesmen can complete orders in shops with no connectivity. The app behaves correctly under flaky 2G/3G.

**Ships these wireframe states:** Offline banner (top of every screen) · Salesman Dashboard "Pending Sync" tile turning orange with a real count · Orders list "Pending" badges + "Saved offline · will sync automatically" notes · Settings sync status card with "Force Sync Now" · Bill preview confirm working offline.

**Plus:** Isar read-cache for `areas`, `shops`, `products` (stale-while-revalidate) · Isar outbox for `orders` + `order_items` · sync worker tied to `connectivity_plus` · idempotency via client-generated UUID. Pattern reference: [offline-sync-patterns.md](./offline-sync-patterns.md).

**Dependencies:** Phase 1 only (Phase 2 is independent).

**Done bar:** airplane-mode test — open app, create order, confirm; toggle airplane mode off; see order sync to Supabase within 30s without re-prompting.

---

## Phase 4 — Field Productivity ⏸️ Deferred

**Status:** Deferred by PM 2026-05-04 in favour of Phase 5. Resume when the field team asks for typing-speed improvements.

**Goal:** Cut typing on the hot path even further. The wireframe has these icons / cards already drawn — Phase 4 wires them up.

**Ships these wireframe affordances:**
- ▦ Barcode scan button on Step 3 → `mobile_scanner` package
- 🎙 Voice search on Step 3 → `speech_to_text`
- 📍 "Shops nearby" GPS card on Step 1 → `geolocator` (already in deps)
- "OTP auto-read from SMS" line on Login → `sms_autofill`
- Phone-OTP login mode in Login → Supabase `signInWithOtp(phone:)` (only if SMS provider is configured in Supabase)

**Dependencies:** Phase 1 (Login + Step 1 + Step 3 must exist). Independent of Phase 2 / Phase 3.

**Open questions:** Does Supabase have an SMS provider configured? If not, drop the phone-OTP path and ship the rest.

**Done bar:** scan a barcode → product appears at Step 3 row in <2s; voice "sunflower oil" → search filters; phone is auto-located → "3 shops nearby" populates with real data.

---

## Phase 5 — Export & Share

**Status:** In planning, implementation deferred. Detailed plan: [phase-5-plan.md](./phase-5-plan.md). Plan source: `~/.claude/plans/clever-beaming-sloth.md` (approved 2026-05-04).

**Goal:** Salesmen can export their own orders to Excel or PDF for any date range and share via WhatsApp from the field. (Admin-side bulk export is a future extension.)

**Locked-in scope (from PM 2026-05-04):**
- Excel: salesman picks from-date / to-date (single day works); columns `orderId | date | area | company | itemname | item code | MRP | Rate | Qty | Total`. One row per order_item.
- `orderId` = `orders.order_number` (human). `company` = **`shops.shop_name`** (the customer/shop, not a product brand — there is no brand field in the schema).
- PDF: same date range; multi-page document, **one page per order**, layout mirrors `bill_preview_screen.dart`.
- File saved to app docs dir, then handed to the system share sheet (`share_plus` `Share.shareXFiles`) so the user picks WhatsApp themselves.
- Both export buttons disabled when offline; helper text "Export needs internet — connect to Wi-Fi or mobile data".
- Dedicated screen at `/settings/export` (top-level push route, no bottom nav). Settings buttons push there with format pre-selected.

**Out of scope this phase:** `exports` table audit tracking · admin-side bulk export · WhatsApp deeplink (use generic share sheet) · Step 4 "WhatsApp" share button (the `bill_preview_screen.dart` placeholder; tracked separately if PM wants per-order share inline).

**Dependencies:** Phase 1 (orders exist), Phase 3 (online check via `isOnlineProvider`). Independent of Phase 2 / 4.

**Done bar:** salesman picks today's date → Excel lands on device with rows matching Supabase → share sheet opens → file attaches in WhatsApp. Same for PDF with one page per order. Offline → buttons disabled with banner. ₹ glyph verified on Android and iOS PDFs.

---

## Phase 6 — Super Admin & Multi-Tenant

**Goal:** Onboard new distributors without engineering help. Operate as a multi-tenant platform.

**Ships:** super_admin role routing · distributor management screens (list / add / edit) · cross-distributor analytics · distributor onboarding flow.

**Dependencies:** Phases 1 and 2.

**Open questions:** **The current wireframe does not cover super-admin screens.** Need a new design pass with the user before building. Also: does a super_admin see one distributor at a time, or aggregate? Billing / pricing model?

**Done bar:** new distributor can be created, an admin assigned, and that admin can log in and bootstrap their own salesmen/shops/products without any engineering involvement.

---

## Cross-cutting concerns (every phase)

- **Tests** — non-trivial logic gets unit tests; new shared widgets get smoke widget tests; route guards get tests.
- **Docs** — update `docs/architecture.md` and ADRs in `docs/decisions/` for material changes; update `.claude/<file>.md` for new patterns.
- **Lints** — `flutter analyze` clean under `very_good_analysis`.
- **Performance** — runtime fonts → bundled TTFs before Phase 1 release; profile on a real low-end Android before each phase ships.
- **Accessibility** — semantic labels on icon-only buttons; min 48dp touch targets; readable contrast in both themes.
- **Error tracking** — once we pick a tool (Sentry / Crashlytics / Supabase logs), wire it in; until then, `logger` writes to console.

## How phases get scheduled

The user is the PM. The order of Phases 2 / 3 / 4 / 5 after Phase 1 is **not fixed** — pick based on which blocks real users first:

- Most distributors onboarding manually? → Phase 2 next.
- Salesmen losing orders in poor signal? → Phase 3 next.
- Admin asks for "speed up the order entry"? → Phase 4 next.
- Admin asks "where do I download the orders"? → Phase 5 next.

Phase 6 should land after at least 2 real distributors are using the app and we understand multi-tenant operationally.
