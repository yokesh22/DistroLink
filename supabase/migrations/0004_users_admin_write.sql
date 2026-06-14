-- Admin write policies for `users`.
--
-- The "add salesman" / "edit salesman" / "toggle active" admin flows insert and
-- update `public.users` rows client-side with the admin's JWT
-- (see AdminSalesmenRepository). With RLS on, `users` only had a SELECT policy
-- (users_self_read), so those writes failed:
--   "new row violates row-level security policy for table users" (42501).
--
-- Allow an admin / super_admin to insert & update users within their own
-- distributor. (The auth user itself is still created by the service-role
-- create-user edge function; distributor signup still inserts via service role.)
--
-- Depends on public.auth_distributor_id() (migration 0001).

-- Helper: current auth user's app role. security definer so it can read users
-- regardless of the caller's RLS (and avoids policy recursion).
create or replace function public.auth_user_role() returns text
language sql stable security definer set search_path = public as $$
  select role from public.users where auth_user_id = auth.uid() limit 1
$$;

-- Admin can read users in their own distributor. Needed because the insert in
-- step 2 below does `.insert(...).select('id').single()` — PostgREST applies the
-- SELECT policy to the RETURNING row, and users_self_read only covers the
-- admin's own row.
drop policy if exists users_admin_read on public.users;
create policy users_admin_read on public.users
  for select
  using (
    public.auth_user_role() in ('admin', 'super_admin')
    and distributor_id = public.auth_distributor_id()
  );

-- Admin can create users in their own distributor.
drop policy if exists users_admin_insert on public.users;
create policy users_admin_insert on public.users
  for insert
  with check (
    public.auth_user_role() in ('admin', 'super_admin')
    and distributor_id = public.auth_distributor_id()
  );

-- Admin can update users in their own distributor (edit details / toggle active).
drop policy if exists users_admin_update on public.users;
create policy users_admin_update on public.users
  for update
  using (
    public.auth_user_role() in ('admin', 'super_admin')
    and distributor_id = public.auth_distributor_id()
  )
  with check (
    public.auth_user_role() in ('admin', 'super_admin')
    and distributor_id = public.auth_distributor_id()
  );

-- Note: users_self_read (migration 0002) still provides each user's own-row
-- SELECT. These two policies are INSERT/UPDATE-only, so they compose cleanly.
