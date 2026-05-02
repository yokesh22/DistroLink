# DistroLink Roadmap — 6 Phases

The full path from "scaffold" to "every wireframe screen + every feature working end-to-end". Each phase ships independent, deployable value. Detailed checklists live in `phase-<N>-plan.md` and are created when that phase begins.

> **Currently in flight: Phase 1.** See [phase-1-plan.md](./phase-1-plan.md).

## Phase ladder at a glance

| # | Phase | Status | Detailed plan |
|---|---|---|---|
| 1 | Salesman Core | **In planning** | [phase-1-plan.md](./phase-1-plan.md) |
| 2 | Admin Module | Not started | _(create `phase-2-plan.md` when starting)_ |
| 3 | Offline-First | Not started | _(create `phase-3-plan.md` when starting)_ |
| 4 | Field Productivity | Not started | _(create `phase-4-plan.md` when starting)_ |
| 5 | Export & Share | Not started | _(create `phase-5-plan.md` when starting)_ |
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

## Phase 4 — Field Productivity

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

**Goal:** Orders flow back into the distributor's existing back-office workflow (Excel) and the salesman can share a bill from the shop.

**Ships these wireframe affordances:**
- Settings → "Export to Excel (.xlsx)" → `excel` package
- Settings → "Export PDF Report" → `pdf` package
- Step 4 → "📤 WhatsApp" → generates PDF + `share_plus` to WhatsApp
- `exports` table tracking (status: pending → done | failed) — already in schema

**Dependencies:** Phase 1 (orders exist). Phase 2 unlocks admin-side bulk export. Independent of Phase 3 / 4.

**Open questions:** Excel export scope — single salesman / all salesmen / one distributor? PDF bill template — what fields, what branding? Need to align with user's existing back-office format.

**Done bar:** click export → `.xlsx` lands on device with last-N-days orders matching what's in Supabase; share PDF from Step 4 → opens WhatsApp with attached bill.

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
