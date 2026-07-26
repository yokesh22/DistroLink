-- Cross-tenant products access for super_admin: bulk item import.
--
-- Mirrors `areas_super_admin_rw` (0006) and `shops_super_admin_rw` (0007), both
-- of which anticipated this. `products_tenant_rw` (0001) scopes every access to
-- the caller's own distributor with no super_admin exception, so a super admin
-- cannot insert products into another tenant or read another tenant's products
-- (needed for the duplicate item_code check). This *permissive* policy ORs in
-- super_admin access while admins/salesmen stay tenant-scoped. Depends on
-- public.auth_user_role() (0004).
--
-- Note: the `products` table also gained three columns in the Supabase dashboard
-- (hsn_code text, pack int4, brand text) for this import; no migration for them
-- is tracked here since they were added directly.

drop policy if exists products_super_admin_rw on public.products;
create policy products_super_admin_rw on public.products
  for all
  using (public.auth_user_role() = 'super_admin')
  with check (public.auth_user_role() = 'super_admin');
