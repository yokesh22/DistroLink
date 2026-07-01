# Business Rules

Encode these in code (with a short comment pointing here for any non-obvious one). Validate at the UI for fast feedback **and** at the repository layer for safety.

## Roles & permissions

| Action | super_admin | admin | salesman |
|---|:-:|:-:|:-:|
| Manage distributors | ✓ | — | — |
| Add / edit salesmen | — | ✓ | — |
| Add / edit shops | — | ✓ | — |
| Add / edit products | — | ✓ | — |
| Create orders | — | — | ✓ |
| View own orders | n/a | n/a | ✓ |
| View all orders (within distributor) | ✓ | ✓ | — |
| Excel export | ✓ | ✓ | — |

> **Salesmen cannot create shops or salesmen.** This is a hard rule; the UI must not surface those CTAs to salesmen, and the repository layer must reject if it ever happens (defence in depth).

## Auth & routing

- Auth = Supabase Auth, **email + password**. No custom hashing.
- After `signInWithPassword`, fetch the `users` row by `auth_user_id` and resolve `role`. Cache in `currentAppUserProvider`.
- Route guard:
  - Not signed in → `/login`
  - Signed in + `role == 'salesman'` → `/home`
  - Signed in + `role in ('admin', 'super_admin')` → Phase 1: `/admin-not-yet`. Phase 2: admin shell.
  - Signed in + `users.is_active == false` → sign out + show "Account disabled" message.

## Order creation rules

### Step 1 — Shop selection
- Salesman picks an **area** (dropdown of `areas`).
- Then picks a **shop** filtered by that area, OR taps from "Recent Shops" (their own last 5 distinct `shop_id`s ordered by most recent `orders.created_at`).
- Salesman cannot add a new shop here. If the shop they need is missing, surface "Ask admin to add this shop".

### Step 2 — Details
- `order_date` auto-set to today (read-only).
- `created_at` auto-set on insert.
- Delivery date defaults to tomorrow; user can change.
- Order type: `Regular` (default) | `Urgent` | `Credit`. (Stored where? Currently no column on `orders` — confirm with user before adding; for Phase 1, hold in the draft and skip persistence.)
- Notes: optional free text.

### Step 3 — Items
- Item rows: each shows `item_code`, `item_name`, `MRP`, `base_rate`, `gst_percent`.
- Qty: `+/−` stepper, **minimum 1** (the `−` button is disabled at 1; tap `✕` to remove the line).
- Selling rate is editable and **set per order** by the salesman. **Validation:** `0 ≤ selling_rate ≤ mrp` — there is **no base-rate floor** (a salesman may sell below `base_rate`, e.g. a negotiated price); MRP is the only ceiling. Show inline error and disable "Next" if any line is above MRP. (Was `base_rate ≤ selling_rate ≤ mrp`; base-rate floor removed 2026-07-01 per PM.)
- "Quick Add" chips show items from the salesman's most recent order — tapping adds at qty 1 with `selling_rate = base_rate`.
- Subtotal in sticky footer = `Σ (selling_rate × quantity)`.

### Step 4 — Bill preview & confirm
- Show items table, then totals breakdown.
- **GST math:**
  - Per item: `gst_amount = round(line_total * gst_percent / 100)`
  - `cgst = round(gst_amount / 2)`, `sgst = gst_amount - cgst` (so they sum exactly).
  - `gst_total = Σ gst_amount`
  - `grand_total = subtotal + gst_total`
- "Confirm & Save Order":
  - Insert `orders` row (computed totals).
  - Insert all `order_items` (snapshot `item_code`, `item_name`, `mrp`, `gst_percent` from product at this moment).
  - Invalidate `recentOrdersProvider`, `salesmanStatsProvider`, `recentShopsProvider`.
  - Navigate back to `/home` with a success snackbar.
- Phase 2: WhatsApp share button generates a PDF and shares via `share_plus`.

### Offline rule (Phase 1 design hook)
- If `connectivity_plus` reports offline at confirm time, **Phase 1**: show a banner "Saving offline isn't ready yet — please retry when online" and keep the draft in memory.
- **Phase 2**: persist the draft to Isar outbox and surface it as "Pending sync" everywhere.

## Stats & dashboard

The salesman dashboard shows:
- **Orders Today** — count of `orders` where `salesman_id == self` AND `order_date == today`.
- **Revenue Today** — sum of `grand_total` for the same set.
- **Shops Visited** — count of distinct `shop_id` for the same set.
- **Pending Sync** — count of orders held in the offline outbox (Phase 2; Phase 1 = always 0 unless "Simulate Offline" is on).
- **Today's Target** — currently a **placeholder** (₹80K hard-coded). Promote to a real configurable field later (probably on `users` or a `targets` table); confirm with user before persisting.

## Recent Orders / Recent Shops

- Recent Orders on dashboard = last 3 orders by this salesman, ordered by `created_at` desc.
- Recent Shops in Step 1 = last 5 distinct `shop_id`s for this salesman, ordered by most recent order.

## Numbers & formatting

- Currency: prefix `₹`, no decimals if whole rupees, comma-grouped (Indian grouping is fine but keep it simple — `intl`'s `NumberFormat.currency(locale: 'en_IN', symbol: '₹')`).
- Use `AppTypography.numeric(...)` for all prices/quantities/totals so columns align.
- Dates: `intl` `DateFormat`. Examples: `Thu, 01 May 2026` for full, `01 May 2026` for compact.
- Times: 12-hour with am/pm, e.g. `09:41 AM`.

## Soft rules (when in doubt, ask)

- **`order_number` generation** — TBD. Server default? Client-side `ORD-{seq}`? Defer until first persistence pass and ask user.
- **Order type column** — not in current schema. Hold in draft only until user confirms whether to add a column or drop the field.
- **Today's Target** — placeholder; needs schema decision.
