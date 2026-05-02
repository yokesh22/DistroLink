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
| name | text | |
| created_at | timestamptz | |

**Has many:** `shops`.

> Areas are **not** scoped per-salesman in the schema. Filter shops by area at the UI; assignment of areas-to-salesmen (if needed) is a future enhancement.

---

## Table: `shops`

Catalog of shops a salesman can place orders against. **Salesmen cannot create shops** — admin-only.

| Column | Type | Notes |
|---|---|---|
| id | uuid PK | |
| area_id | uuid | FK → `areas.id` |
| shop_name | text | |
| shop_number | text | Human-readable code, e.g. `SH-041` |
| shop_address | text | |
| created_at | timestamptz | |

> No `is_active` column today. If a shop needs to be hidden, plan an `is_active` migration.

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
| created_at | timestamptz | |

> **Selling rate validation:** `base_rate ≤ selling_rate ≤ mrp`. See [business-rules.md](./business-rules.md).

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
| selling_rate | numeric | Salesman-overridable; validated `base_rate ≤ rate ≤ mrp` |
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

## Business invariants (enforced in code; document why)

1. `selling_rate ∈ [base_rate, mrp]` — validated at form-submit time and again at repository layer.
2. `quantity ≥ 1` — qty stepper enforces; repo validates.
3. `subtotal = sum(line_total)`, `grand_total = subtotal + gst_total` — compute in app, send all three (server can recompute as a check).
4. Snapshots in `order_items` (`item_code`, `item_name`, `mrp`, `gst_percent`) make orders historically stable. Never reach back to `products` to render an old order.
5. `order_number` generation strategy is **not yet decided** — confirm with user before first implementation.
