# ADR 0007 — Last shop rate lookup via a Postgres function (no new table)

**Status:** Accepted (2026-10-03)

> Numbered 0007 because 0006 is reserved for the pending "Supabase as backend" ADR that supersedes [ADR-0004](0004-google-sheets-as-backend.md).

## Context

Salesmen often agree a custom selling rate with a shop for a product, and used to retype it on every order. The PM asked for a Settings toggle, **"Use last shop rate"**. When it's on, an item added for a shop starts at the rate last used for that shop and product, as long as that rate was edited. The full rule is in `.claude/rules/business-rules.md`, Step 3.

The data already exists: `order_items.selling_rate` joined to `orders.shop_id`. The question was how to read it in a way that keeps working as order history grows.

Options considered:

1. **Client-side query + reduce in Dart.** Fetch every past line for the shop, keep the latest per product. Simple, but the payload grows with the shop's history.
2. **Postgres function with `DISTINCT ON (product_id)` + an index.** One round trip, returns at most one row per product, and cost is bounded by that one shop's orders.
3. **Trigger-maintained `shop_product_rates` table.** Fastest reads, but it must stay correct through order edits (items are deleted and re-inserted), soft deletes (`orders.deleted_at`) and offline outbox sync.

## Decision

Option 2. Migration [`0011_last_shop_rates.sql`](../../supabase/migrations/0011_last_shop_rates.sql) adds:

- `public.last_shop_selling_rates(p_shop_id uuid) returns table (product_id uuid, selling_rate numeric)`. It returns the latest rate per product for the shop, excluding soft-deleted orders. It is `security invoker`, so the existing tenant RLS scopes results to the caller's distributor. Orders from **any salesman** in the distributor count.
- Index `orders_shop_created_idx` on `orders (shop_id, created_at desc) where deleted_at is null`, and index `order_items_order_id_idx` on `order_items (order_id)`.

The "edited?" check happens in Dart, not SQL: `DraftItem.fromProduct(p, lastRate:)` uses the last rate only if it differs from the product's **current** `base_rate`. That keeps the business rule unit-testable.

The toggle is a per-device preference in SharedPreferences (`use_last_shop_rate`, off by default). It lives in `lib/services/preferences/` because both the `settings` and `orders` features read it, and features never import each other ([ADR-0001](0001-feature-first-architecture.md)).

## Consequences

- No schema change to existing tables. One migration applied in the Supabase dashboard.
- **Online only.** When offline, or if the lookup fails or hasn't loaded yet, items fall back to `base_rate`. Order entry is never blocked. A Hive cache can be added later if the PM wants offline support.
- **Known edge case.** `order_items` doesn't snapshot `base_rate`. If an admin changes a product's base rate, an old unedited rate will look "edited" and be pre-filled. Fixing this exactly would mean adding a `base_rate` snapshot column to `order_items`; the PM declined that for now.
- **Upgrade path.** If a single shop ever reaches thousands of orders and the lookup slows down, move to option 3. The function signature can stay the same.
