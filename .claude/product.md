# Product Context

DistroLink is a mobile order-taking app for **FMCG distributors**. Salesmen visit shops in their assigned areas, take orders product-by-product, and submit them to a central Supabase backend. Admins manage the catalog (salesmen, shops, products); super admins manage distributors. Excel export feeds existing back-office workflows.

Domain: Indian FMCG distribution. Currency `₹` (INR). GST splits 50/50 into CGST + SGST.

## Personas

- **Super Admin** — manages distributors. Internal/back-office. Phase 3.
- **Admin** (one or more per distributor) — manages salesmen, shops, products, views aggregate analytics.
- **Salesman** — visits shops, creates orders. The hot path of the app. ~80% of usage.

## The hot path: salesman creating an order

This must be **fast** — ideally <30 seconds for a regular shop with ~5 items.

1. Open app in a shop (already logged in).
2. Tap "+ Start New Order" on Dashboard or `+` FAB.
3. **Step 1 — Shop:** Pick area (or use "Recent Shops" shortcut) → pick shop. GPS-based "shops nearby" is a secondary option.
4. **Step 2 — Details:** Order date/time auto-filled. Pick delivery date, order type (Regular / Urgent / Credit), optional notes.
5. **Step 3 — Items:** Search product by name/code OR pick from "Quick Add" chips (last order's items) OR (Phase 2) barcode scan / voice. Use +/− stepper for qty. Optionally edit selling rate (must stay between `base_rate` and `mrp`).
6. **Step 4 — Bill:** Preview with subtotal, CGST + SGST, grand total. Confirm → write `orders` + `order_items` rows. (Phase 2: WhatsApp share PDF.)

Every step minimises typing — dropdowns, recent-values, steppers, segmented controls.

## Constraints

- **Platforms:** Android 8+ (API 26+) and iOS only — see ADR 0003.
- **Devices:** often low-end Android. Avoid heavy animations, large images, runtime asset fetches.
- **Connectivity:** patchy in shops. Offline-first is a hard requirement (Phase 2 implements; Phase 1 designs around it — never block submit on network if a draft can be saved locally).
- **Languages:** English only for now. i18n hooks (`l10n/`) exist for later.

## Phase ladder

Full breakdown with scope, dependencies, and Done-bar per phase: **[roadmap.md](./roadmap.md)**.

| # | Phase | Hot summary |
|---|---|---|
| 1 | Salesman Core *(current)* | Email+password login → Dashboard → 4-step order flow → Orders/Analytics/Settings, online only |
| 2 | Admin Module | Admin Dashboard + Salesmen/Shops/Products CRUD; replaces `/admin-not-yet` |
| 3 | Offline-First | Isar read-cache + order outbox + sync worker; real Pending Sync counts |
| 4 | Field Productivity | Barcode scan, voice search, SMS OTP autofill, GPS "shops nearby", phone-OTP |
| 5 | Export & Share | Excel `.xlsx`, PDF bill, WhatsApp share, `exports` table |
| 6 | Super Admin & Multi-Tenant | Distributor management, cross-distributor analytics (needs new design) |

Phases 2/3/4/5 depend only on Phase 1, so the order between them is flexible based on what blocks real users first.

## UX principles (always)

1. **Fast data entry beats pretty.** Forms minimise typing — prefer dropdowns, autocomplete, recent-values shortcuts, steppers.
2. **Large touch targets.** 48dp min for primary actions. Buttons enforce this via theme.
3. **Step-based flows.** Order creation is 4 small steps, not one massive form.
4. **One screen, one job.** Hide secondary actions behind menus.
5. **Offline-aware.** Show a banner when offline; show pending-sync count clearly; never lie about whether data is saved remotely.

## Design source

Canonical design = the Claude Design handoff bundle (`distolink/project/DistroLink Wireframes.html`). 17 screens across 5 sections, fully aligned with the schema. **Re-fetch from the original URL** if needed — the bundle was extracted to `/tmp/...` (ephemeral). Don't redesign without checking back with the user — the design has been iterated multiple times and reflects intent.
