-- Distributor-scoped tenancy for `areas` and `shops`.
--
-- Brings areas/shops up to the same per-distributor isolation that products and
-- salesmen already have. After this migration each distributor only ever sees its
-- own areas and shops (enforced by RLS server-side + filtered client-side).
--
-- PM confirmed (2026-06-14) all current data is test data and can be cleared, so
-- there is no backfill — we wipe and re-seed rather than guess a distributor for
-- existing rows.

-- 1. Clear test data first. Order matters for FKs (order_items -> orders -> shops -> areas).
delete from order_items;
delete from orders;
delete from shops;
delete from areas;

-- 2. Add the tenant column to both tables.
alter table areas
  add column distributor_id uuid not null references distributors(id) on delete cascade;
alter table shops
  add column distributor_id uuid not null references distributors(id) on delete cascade;

-- 3. Indexes for the new filter paths.
create index if not exists areas_distributor_id_idx on areas (distributor_id);
create index if not exists shops_distributor_id_idx on shops (distributor_id);
create index if not exists shops_area_id_idx on shops (area_id);

-- 4. Helper: resolve the current auth user's distributor.
--    security definer so RLS policies can read the users table regardless of the
--    caller's own row-level access to it.
create or replace function public.auth_distributor_id() returns uuid
language sql stable security definer set search_path = public as $$
  select distributor_id from public.users where auth_user_id = auth.uid() limit 1
$$;

-- 5. Row-Level Security: a row is visible/writable only within the caller's distributor.
alter table areas enable row level security;
alter table shops enable row level security;

drop policy if exists areas_tenant_rw on areas;
create policy areas_tenant_rw on areas
  using (distributor_id = public.auth_distributor_id())
  with check (distributor_id = public.auth_distributor_id());

drop policy if exists shops_tenant_rw on shops;
create policy shops_tenant_rw on shops
  using (distributor_id = public.auth_distributor_id())
  with check (distributor_id = public.auth_distributor_id());

-- ─────────────────────────────────────────────────────────────────────────────
-- OPTIONAL (uncomment if products / salesmen do NOT already have RLS policies).
-- The app assumes tenant RLS exists for these but no policy SQL is tracked in the
-- repo. Confirm in the Supabase dashboard; if missing, enable below.
--
alter table products enable row level security;
drop policy if exists products_tenant_rw on products;
create policy products_tenant_rw on products
  using (distributor_id = public.auth_distributor_id())
  with check (distributor_id = public.auth_distributor_id());

alter table salesmen enable row level security;
drop policy if exists salesmen_tenant_rw on salesmen;
create policy salesmen_tenant_rw on salesmen
  using (distributor_id = public.auth_distributor_id())
  with check (distributor_id = public.auth_distributor_id());
