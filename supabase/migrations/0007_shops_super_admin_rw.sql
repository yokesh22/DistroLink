-- Cross-tenant shops access for super_admin: bulk shop import.
--
-- Mirrors `areas_super_admin_rw` from 0006 (which explicitly anticipated this).
-- `shops_tenant_rw` (0001) scopes every access to the caller's own distributor
-- with no super_admin exception, so a super admin cannot insert shops into
-- another tenant or read another tenant's shops (needed for the duplicate
-- retailer_code check). This *permissive* policy ORs in super_admin access
-- while admins/salesmen stay tenant-scoped. Depends on public.auth_user_role()
-- (0004).
--
-- Area name -> area_id resolution during the shop import reads `areas`, already
-- covered by `areas_super_admin_rw` (0006).

drop policy if exists shops_super_admin_rw on public.shops;
create policy shops_super_admin_rw on public.shops
  for all
  using (public.auth_user_role() = 'super_admin')
  with check (public.auth_user_role() = 'super_admin');

-- Future items import will add an analogous products_super_admin_rw policy.
