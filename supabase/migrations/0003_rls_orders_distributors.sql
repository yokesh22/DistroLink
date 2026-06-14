-- RLS policies for the remaining app tables: distributors, orders,
-- order_items, exports.
--
-- RLS was manually enabled on ALL tables. Migration 0001 covered
-- areas/shops/products/salesmen and 0002 covered users. This fills the rest so
-- order creation, the admin dashboard, and onboarding work again.
--
-- Depends on public.auth_distributor_id() (created in migration 0001).

-- ── distributors ─────────────────────────────────────────────────────────────
-- A user can read their own distributor (onboarding shows the business name).
-- Writes happen via the service-role create-distributor edge function.
alter table public.distributors enable row level security;

drop policy if exists distributors_self_read on public.distributors;
create policy distributors_self_read on public.distributors
  for select
  using (id = public.auth_distributor_id());

-- ── orders ───────────────────────────────────────────────────────────────────
-- Tenant-scoped: any user in the distributor can read; inserts/updates must
-- belong to the caller's distributor. Salesman-vs-own-orders narrowing is done
-- client-side (the app filters by salesman_id); this is defence-in-depth.
alter table public.orders enable row level security;

drop policy if exists orders_tenant_rw on public.orders;
create policy orders_tenant_rw on public.orders
  using (distributor_id = public.auth_distributor_id())
  with check (distributor_id = public.auth_distributor_id());

-- ── order_items ──────────────────────────────────────────────────────────────
-- No distributor_id column; scope through the parent order.
alter table public.order_items enable row level security;

drop policy if exists order_items_tenant_rw on public.order_items;
create policy order_items_tenant_rw on public.order_items
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
    )
  )
  with check (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
    )
  );

-- ── exports ──────────────────────────────────────────────────────────────────
-- Phase-2 table; scope through the parent order so it's ready when wired up.
alter table public.exports enable row level security;

drop policy if exists exports_tenant_rw on public.exports;
create policy exports_tenant_rw on public.exports
  using (
    exists (
      select 1 from public.orders o
      where o.id = exports.order_id
        and o.distributor_id = public.auth_distributor_id()
    )
  )
  with check (
    exists (
      select 1 from public.orders o
      where o.id = exports.order_id
        and o.distributor_id = public.auth_distributor_id()
    )
  );
