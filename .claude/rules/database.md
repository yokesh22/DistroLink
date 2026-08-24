# Supabase Schema

Supabase is the **source of truth at runtime**. Tables and seed data already exist in the user's Supabase project. Don't generate schema — use what's defined here. If a column is missing or wrong, **stop and ask** before assuming.

All primary keys are `uuid`. Timestamps are `timestamptz` named `created_at` / `updated_at`. Foreign keys cascade according to business intent (see notes per table).

---

## Auth

Supabase Auth (`auth.users`) is used directly — **do not** create custom password logic, custom hashing, or a parallel users table for credentials. Sessions, refresh, and auth-state changes go through `supabase.auth`.

App-level identity lives in the `users` table, joined to `auth.users` via `auth_user_id`.

---

## Table: `distributors`

The tenant root. Each distributor is a self-contained business unit.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| name | text | Distributor business name |
| phone | text | |
| email | text | |
| created_at | timestamptz | |

**Has many:** `users`, `salesmen`, `products`, `orders` (transitively through salesman/shop).

---

## Table: `users`

Maps a Supabase auth user to a role within a distributor.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| auth_user_id | uuid | FK → `auth.users.id`. **Source of identity.** |
| distributor_id | uuid | FK → `distributors.id` |
| role | text enum | `super_admin` \| `admin` \| `salesman` |
| full_name | text | |
| phone | text | |
| email | text | |
| is_active | bool | Soft-delete / disable login |
| created_at, updated_at | timestamptz | |

**On every login**, fetch the `users` row by `auth_user_id` to get `role` and `distributor_id`. Cache it in `currentAppUserProvider`. Route based on role:
- `salesman` → `/home` (dashboard)
- `admin` / `super_admin` → `/admin-not-yet` (Phase 1) or admin shell (Phase 2+)

---

## Table: `salesmen`

Business entity for salesmen. Distinct from `users` (a user with role=salesman) — keeps salesman-specific business fields separate from auth/identity.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | **Used as `orders.salesman_id`**, not `users.id`. |
| distributor_id | uuid | FK → `distributors.id` |
| user_id | uuid | FK → `users.id` (nullable if salesman has no login yet) |
| name | text | |
| phone | text | |
| email | text | |
| is_active | bool | Deactivated salesmen can't log in / appear in lists |
| created_at | timestamptz | |

> ⚠ `users` and `salesmen` are two tables. `users` is identity/auth-glue; `salesmen` is business entity. To get the current salesman's id, query `salesmen.where(user_id == currentAppUser.id)`.

---

## Table: `areas`

Admin-controlled list of geographic areas (e.g. "Sector 12", "MG Road").

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| distributor_id | uuid | FK → `distributors.id`. **Per-distributor tenant scope** (added migration `0001`). |
| name | text | Unique **per distributor**: `unique (distributor_id, name)` (migration `0009`). |
| created_at | timestamptz | |

**Has many:** `shops`. **Belongs to:** `distributors`.

> Areas are scoped per-**distributor** (not per-salesman). RLS (`areas_tenant_rw`) restricts rows to the caller's distributor via `public.auth_distributor_id()`; the app also filters by `distributor_id` as defence-in-depth. Assignment of areas-to-salesmen (if needed) is a future enhancement.
>
> **Uniqueness is composite** — `unique (distributor_id, name)` (migration `0009_areas_unique_per_distributor.sql`). The table originally shipped with a **global** `unique (name)` (`areas_name_key`), which blocked a second distributor from bulk-importing an area name a first distributor already owned. `0009` drops the global constraint and replaces it with the per-distributor composite. The constraint is case-sensitive; the app dedups case-insensitively (`_submitAreas` / `existingAreaNamesLower`).

---

## Table: `shops`

Catalog of shops a salesman can place orders against. Admins add/edit shops; **salesmen may _add_ (not edit) shops** in their own distributor from the order flow (changed 2026-07-24 — see [business-rules.md](./business-rules.md)). RLS (`shops_tenant_rw`) already scopes inserts to the caller's distributor, so no migration was needed.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| distributor_id | uuid | FK → `distributors.id`. **Per-distributor tenant scope** (added migration `0001`). |
| area_id | uuid | FK → `areas.id` |
| shop_name | text | |
| shop_number | text | Human-readable code, e.g. `SH-041`. Optional. Unique **per distributor** among non-empty values via a partial index (migration `0010`). |
| shop_address | text | |
| shop_owner | text | Optional |
| phone_no | text | Optional |
| gstin | text | Optional |
| created_at | timestamptz | |

> Scoped per-**distributor**. RLS (`shops_tenant_rw`) restricts rows to the caller's distributor via `public.auth_distributor_id()`; the app also filters by `distributor_id`.
> No `is_active` column today. If a shop needs to be hidden, plan an `is_active` migration.
>
> **`shop_number` uniqueness** — a partial unique index `unique (distributor_id, shop_number) where shop_number is not null and shop_number <> ''` (migration `0010_shops_unique_per_distributor.sql`). Shops originally had **no** unique constraint on the code; `0010` adds per-distributor uniqueness (matching `areas`/`products`) but only for coded shops, since `shop_number` is optional (blank → NULL on add, possibly `''` on edit). Case-sensitive, matching the app's non-empty de-dup.

---

## Table: `products`

Product catalog scoped per distributor. **Salesmen cannot create products** — admin-only.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| distributor_id | uuid | FK → `distributors.id` |
| item_code | text | Distributor-unique short code, e.g. `SUN-01` |
| item_name | text | |
| mrp | numeric | Maximum Retail Price (the **ceiling** for selling rate) |
| base_rate | numeric | Distributor's base/floor rate |
| gst_percent | numeric | GST slab (0, 5, 12, 18, 28) |
| is_active | bool | Inactive products don't appear in catalog list |
| brand | text | Added 2026-07-26 (bulk item import). Nullable. |
| hsn_code | text | HSN tax code. Added 2026-07-26 (bulk item import). Nullable. |
| pack | int4 | Units per pack. Added 2026-07-26 (bulk item import). Nullable. |
| created_at | timestamptz | |

> `brand` / `hsn_code` / `pack` were added directly in the Supabase dashboard (no tracked column
> migration). They're **nullable** in the Dart `Product` model so products created before they
> existed still parse; only the super-admin **bulk item import** writes them today (the admin
> add/edit product form doesn't yet). The item import validates `gst` against the slab **{0, 5, 12,
> 18, 28, 40}** per PM (2026-07-26) — same as the standard slabs plus 40.

> **Selling rate validation:** `0 ≤ selling_rate ≤ mrp` (MRP is the ceiling; **no base-rate floor** — base-rate floor removed 2026-07-01). `base_rate` is a reference/default only. See [business-rules.md](./business-rules.md).

---

## Table: `orders`

Header row for an order placed by a salesman against a shop.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| order_number | text | Human-readable, e.g. `ORD-241`. Generation strategy TBD; for now, server-side default or sequential per distributor. **Confirm with user before generating client-side.** |
| distributor_id | uuid | FK → `distributors.id` (denormalised from salesman, for query speed) |
| salesman_id | uuid | FK → `salesmen.id` |
| shop_id | uuid | FK → `shops.id` |
| area_id | uuid | FK → `areas.id` (denormalised from shop) |
| subtotal | numeric | Sum of `order_items.line_total` (without GST) |
| gst_total | numeric | Sum of GST across all items |
| grand_total | numeric | `subtotal + gst_total` |
| notes | text | Optional |
| order_date | date | Date the order was placed (auto = today) |
| created_at | timestamptz | |

> Insert `orders` and `order_items` together. Prefer a Postgres function (RPC) for atomicity if available; otherwise insert order header → use returned id → insert items in one batch.

---

## Table: `order_items`

Line items for an order. Snapshots product fields at order time so retroactive product edits don't change history.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| order_id | uuid | FK → `orders.id` (cascade delete) |
| product_id | uuid | FK → `products.id` |
| item_code | text | **Snapshot** of product.item_code at order time |
| item_name | text | **Snapshot** of product.item_name |
| mrp | numeric | **Snapshot** |
| selling_rate | numeric | Salesman-overridable per order; validated `0 ≤ rate ≤ mrp` (no base-rate floor) |
| quantity | int | ≥ 1 |
| gst_percent | numeric | **Snapshot** |
| line_total | numeric | `selling_rate * quantity` (excludes GST). GST is computed from `line_total * gst_percent / 100`. |
| created_at | timestamptz | |

---

## Table: `exports`

Tracks Excel export status. Phase 2.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| order_id | uuid | FK → `orders.id` |
| export_status | text | e.g. `pending` \| `done` \| `failed` |
| exported_at | timestamptz | |
| created_at | timestamptz | |

---

## RLS expectations (verify in Supabase dashboard)

The app assumes Supabase Row-Level Security enforces:
- A salesman can only read shops, products, areas under their distributor.
- A salesman can only insert `orders` / `order_items` where `salesman_id` matches their own.
- A salesman can only read `orders` they created.
- An admin can read/write everything within their distributor.

If RLS is missing or weaker, **filter client-side as a defence-in-depth measure**, but flag the gap to the user.

### Super-admin cross-tenant access (migration `0006`, added 2026-07-25)

The tenant policies above scope every read/write to the caller's own distributor. Migration
`0006_super_admin_cross_tenant.sql` adds two **permissive** policies (they OR with the tenant
policies, so admins/salesmen stay scoped) so a `super_admin` can:
- `distributors_super_admin_read` — `select` **all** distributors (feeds the bulk-import picker).
- `areas_super_admin_rw` — read/write areas in **any** tenant (bulk area import + its duplicate
  check).

Migrations `0007_shops_super_admin_rw.sql` and `0008_products_super_admin_rw.sql` (added 2026-07-26)
add the analogous `shops_super_admin_rw` / `products_super_admin_rw` (read/write in **any** tenant)
for the shops and items bulk imports — read is needed for the duplicate-key check, write for the
insert; area resolution reuses `areas_super_admin_rw`.

Migration `0009_areas_unique_per_distributor.sql` (added 2026-08-24) fixes a **cross-tenant bulk-import
bug**: `areas` shipped with a global `unique (name)` (`areas_name_key`), so a second distributor could
not bulk-import an area name a first distributor already owned (Postgres unique-key violation on
insert, despite the app's per-distributor duplicate check passing). `0009` drops the global constraint
and adds `unique (distributor_id, name)`.

Audit of the analogous *distributor-unique* codes (2026-08-24) found: `products.item_code` was
**already** `unique (distributor_id, item_code)` (no change needed), while `shops.shop_number` had
**no** unique constraint at all. Migration `0010_shops_unique_per_distributor.sql` adds a **partial**
unique index `unique (distributor_id, shop_number) where shop_number is not null and shop_number <> ''`
— per-distributor uniqueness for coded shops only (`shop_number` is optional). Because shops had no
prior constraint, run the duplicate pre-check in `0010`'s header before applying (the index build fails
transactionally if existing dup codes exist within a distributor).

Powers the super-admin **Bulk Import** screen (`/super-admin/import`): **Areas** (single `area`
column), **Shops** (`area, shop, retailer_code, address, gst_no, mobile, shop_owner`) and **Items**
(`brand, item_code, item, hsn, mrp, rate, gst, pack`). Parsing is client-side (`ExcelImportService`;
shops/items parse in a `compute` isolate), the write goes directly through `SuperAdminRepository` in
one atomic batch insert (no Edge Function / RPC). Shops: `area` resolves to `area_id`
(unknown/ambiguous → blocking); `mobile` and `shop_owner` are optional **values** (their columns must
still be present, but cells may be blank → stored NULL) while `gst_no` is fully optional (its column
may be omitted entirely); `area`, `shop`, `retailer_code`, `address` mandatory. Items: `brand` and `hsn` are optional **values** (columns still required, blank →
NULL); `item_code`, `item`, `mrp`, `rate`, `gst`, `pack` mandatory; `rate`→`base_rate`,
`gst` ∈ {0,5,12,18,28,40} as int, `mrp`/`rate` exact decimals, `pack` int, `is_active=true`. Both:
whole-sheet all-or-nothing validation; existing `retailer_code`/`item_code` skipped; affected rows
emitted as a re-upload-ready `.xlsx` report (original columns + `issue`).

## Business invariants (enforced in code; document why)

1. `selling_rate ∈ [0, mrp]` — MRP ceiling only, no base-rate floor (changed 2026-07-01). Validated at form-submit time; the draft clamps to `[0, mrp]`.
2. `quantity ≥ 1` — qty stepper enforces; repo validates.
3. `subtotal = sum(line_total)`, `grand_total = subtotal + gst_total` — compute in app, send all three (server can recompute as a check).
4. Snapshots in `order_items` (`item_code`, `item_name`, `mrp`, `gst_percent`) make orders historically stable. Never reach back to `products` to render an old order.
5. `order_number` generation strategy is **not yet decided** — confirm with user before first implementation.
