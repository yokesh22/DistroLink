-- Role-aware order editing while retaining the existing tenant read/create rules.
-- See .claude/rules/business-rules.md for order ownership and edit permissions.

-- The old *_tenant_rw policies are permissive ALL policies. PostgreSQL ORs
-- permissive policies, so they must be dropped before adding narrower policies.
drop policy if exists orders_tenant_rw on public.orders;
drop policy if exists order_items_tenant_rw on public.order_items;
drop policy if exists orders_tenant_read on public.orders;
drop policy if exists orders_tenant_insert on public.orders;
drop policy if exists orders_edit_update on public.orders;
drop policy if exists orders_edit_delete on public.orders;
drop policy if exists order_items_tenant_read on public.order_items;
drop policy if exists order_items_tenant_insert on public.order_items;
drop policy if exists order_items_edit_update on public.order_items;
drop policy if exists order_items_edit_delete on public.order_items;

create or replace function public.auth_salesman_id() returns uuid
language sql stable security definer set search_path = public as $$
  select s.id
  from public.salesmen s
  join public.users u on u.id = s.user_id
  where u.auth_user_id = auth.uid()
    and u.role = 'salesman'
  limit 1
$$;

revoke all on function public.auth_salesman_id() from public;
grant execute on function public.auth_salesman_id() to authenticated;

create or replace function public.prevent_order_owner_change() returns trigger
language plpgsql set search_path = public as $$
begin
  if new.distributor_id is distinct from old.distributor_id
    or new.salesman_id is distinct from old.salesman_id then
    raise exception 'Order ownership cannot be changed'
      using errcode = '42501';
  end if;
  return new;
end
$$;

drop trigger if exists orders_owner_immutable on public.orders;
create trigger orders_owner_immutable
  before update of distributor_id, salesman_id on public.orders
  for each row execute function public.prevent_order_owner_change();

create policy orders_tenant_read on public.orders
  for select
  using (distributor_id = public.auth_distributor_id());

create policy orders_tenant_insert on public.orders
  for insert
  with check (distributor_id = public.auth_distributor_id());

create policy orders_edit_update on public.orders
  for update
  using (
    distributor_id = public.auth_distributor_id()
    and (
      public.auth_user_role() = 'admin'
      or (
        public.auth_user_role() = 'salesman'
        and salesman_id = public.auth_salesman_id()
      )
    )
  )
  with check (
    distributor_id = public.auth_distributor_id()
    and (
      public.auth_user_role() = 'admin'
      or (
        public.auth_user_role() = 'salesman'
        and salesman_id = public.auth_salesman_id()
      )
    )
  );

create policy orders_edit_delete on public.orders
  for delete
  using (
    distributor_id = public.auth_distributor_id()
    and (
      public.auth_user_role() = 'admin'
      or (
        public.auth_user_role() = 'salesman'
        and salesman_id = public.auth_salesman_id()
      )
    )
  );

create policy order_items_tenant_read on public.order_items
  for select
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
    )
  );

-- Preserve the existing tenant-scoped insert behavior. The order flow supplies
-- its authenticated salesman's id; update/delete policies below enforce ownership.
create policy order_items_tenant_insert on public.order_items
  for insert
  with check (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
        and (
          public.auth_user_role() = 'admin'
          or (
            public.auth_user_role() = 'salesman'
            and o.salesman_id = public.auth_salesman_id()
          )
        )
    )
  );

create policy order_items_edit_update on public.order_items
  for update
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
        and (
          public.auth_user_role() = 'admin'
          or (
            public.auth_user_role() = 'salesman'
            and o.salesman_id = public.auth_salesman_id()
          )
        )
    )
  )
  with check (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
        and (
          public.auth_user_role() = 'admin'
          or (
            public.auth_user_role() = 'salesman'
            and o.salesman_id = public.auth_salesman_id()
          )
        )
    )
  );

create policy order_items_edit_delete on public.order_items
  for delete
  using (
    exists (
      select 1 from public.orders o
      where o.id = order_items.order_id
        and o.distributor_id = public.auth_distributor_id()
        and (
          public.auth_user_role() = 'admin'
          or (
            public.auth_user_role() = 'salesman'
            and o.salesman_id = public.auth_salesman_id()
          )
        )
    )
  );

create or replace function public.list_distributor_orders(
  p_distributor_id uuid,
  p_salesman_id uuid default null,
  p_from date default null,
  p_before date default null,
  p_search text default null,
  p_limit integer default 26,
  p_offset integer default 0
)
returns table (
  id uuid,
  order_number text,
  distributor_id uuid,
  salesman_id uuid,
  shop_id uuid,
  area_id uuid,
  subtotal numeric,
  gst_total numeric,
  grand_total numeric,
  order_date date,
  created_at timestamptz,
  notes text,
  shop_name text,
  shop_number text,
  shop_address text,
  area_name text,
  salesman_name text,
  salesman_phone text,
  distributor_name text,
  distributor_phone text,
  distributor_email text
)
language sql stable security invoker set search_path = public as $$
  select
    o.id,
    o.order_number,
    o.distributor_id,
    o.salesman_id,
    o.shop_id,
    o.area_id,
    o.subtotal,
    o.gst_total,
    o.grand_total,
    o.order_date,
    o.created_at,
    o.notes,
    sh.shop_name,
    sh.shop_number,
    sh.shop_address,
    a.name as area_name,
    s.name as salesman_name,
    s.phone as salesman_phone,
    d.name as distributor_name,
    d.phone as distributor_phone,
    d.email as distributor_email
  from public.orders o
  join public.shops sh on sh.id = o.shop_id
  join public.areas a on a.id = o.area_id
  join public.salesmen s on s.id = o.salesman_id
  join public.distributors d on d.id = o.distributor_id
  where p_distributor_id = public.auth_distributor_id()
    and public.auth_user_role() = 'admin'
    and o.distributor_id = p_distributor_id
    and o.deleted_at is null
    and (p_salesman_id is null or o.salesman_id = p_salesman_id)
    and (p_from is null or o.order_date >= p_from)
    and (p_before is null or o.order_date < p_before)
    and (
      p_search is null
      or btrim(p_search) = ''
      or position(lower(btrim(p_search)) in lower(o.order_number)) > 0
      or position(lower(btrim(p_search)) in lower(sh.shop_name)) > 0
    )
  order by o.created_at desc, o.id desc
  limit least(greatest(coalesce(p_limit, 26), 1), 101)
  offset greatest(coalesce(p_offset, 0), 0)
$$;

revoke all on function public.list_distributor_orders(uuid, uuid, date, date, text, integer, integer) from public;
grant execute on function public.list_distributor_orders(uuid, uuid, date, date, text, integer, integer) to authenticated;

notify pgrst, 'reload schema';
