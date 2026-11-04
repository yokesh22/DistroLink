-- "Use last shop rate" lookup (added 2026-10-03).
--
-- When the salesman turns on the Settings toggle "Use last shop rate", items
-- added to an order for a shop start at the selling rate last used for that
-- (shop, product) pair. The app compares that rate to the product's current
-- base_rate and only uses it when it differs ("edited") — see
-- .claude/rules/business-rules.md, Step 3.
--
-- Why a function instead of a new table: DISTINCT ON returns at most one row
-- per product, in a single round trip, and its cost is bounded by that one
-- shop's order history (served by orders_shop_created_idx). A trigger-maintained
-- shop_product_rates table would also have to stay correct through order edits
-- (items are deleted + re-inserted), soft deletes and outbox sync.
--
-- `security invoker` → the caller's RLS applies (orders_tenant_rw /
-- order_items_tenant_rw), so results are scoped to the caller's distributor.
-- History from ANY salesman in the distributor counts (per PM).

create index if not exists orders_shop_created_idx
  on public.orders (shop_id, created_at desc)
  where deleted_at is null;

create index if not exists order_items_order_id_idx
  on public.order_items (order_id);

create or replace function public.last_shop_selling_rates(p_shop_id uuid)
returns table (product_id uuid, selling_rate numeric)
language sql
stable
security invoker
as $$
  select distinct on (oi.product_id) oi.product_id, oi.selling_rate
  from public.order_items oi
  join public.orders o on o.id = oi.order_id
  where o.shop_id = p_shop_id
    and o.deleted_at is null
  order by oi.product_id, o.created_at desc;
$$;

grant execute on function public.last_shop_selling_rates(uuid) to authenticated;
