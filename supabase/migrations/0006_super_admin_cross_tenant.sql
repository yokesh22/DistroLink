-- Cross-tenant access for super_admin: distributor listing + bulk area import.
--
-- The tenant policies from 0001/0003 scope every read and write to the caller's
-- own distributor (`distributor_id = public.auth_distributor_id()`), with no
-- super_admin exception. That prevents a super admin from (a) listing all
-- distributors for the bulk-import picker and (b) inserting areas into another
-- distributor's tenant.
--
-- These policies are *permissive* and OR together with the existing tenant
-- policies, so a super admin gains cross-tenant access while admins/salesmen stay
-- scoped to their own distributor. Depends on public.auth_user_role() (0004) and
-- the tenant policies in 0001/0003.

-- A super_admin can read every distributor (for the searchable import picker).
-- (0003 already grants each user read of their own distributor row; this ORs in
-- the rest for super_admin only.)
drop policy if exists distributors_super_admin_read on public.distributors;
create policy distributors_super_admin_read on public.distributors
  for select
  using (public.auth_user_role() = 'super_admin');

-- A super_admin can read/write areas in ANY tenant. Read is needed for the
-- duplicate check before insert; write is the bulk import itself.
drop policy if exists areas_super_admin_rw on public.areas;
create policy areas_super_admin_rw on public.areas
  for all
  using (public.auth_user_role() = 'super_admin')
  with check (public.auth_user_role() = 'super_admin');

-- Future bulk imports (shops, products) will add analogous cross-tenant policies
-- (shops_super_admin_rw / products_super_admin_rw) of the same shape.
