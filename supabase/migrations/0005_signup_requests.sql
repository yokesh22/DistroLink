-- Distributor signup approval queue.
--
-- Previously, distributor signup created the `distributors` + `users` rows
-- immediately (create-distributor edge fn), granting access as soon as the
-- email was verified. To stop reshared APKs from self-provisioning, signup now
-- only files a *pending request* here. A super_admin reviews it; only on
-- approval are the distributor + users rows created (review-signup-request fn).
--
-- The real access gate is unchanged: no `users` row => no app. This table just
-- lets the app show a "pending / declined" screen instead of bouncing to login.
--
-- Depends on public.auth_user_role() (migration 0004).

create table if not exists public.signup_requests (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users (id) on delete cascade,
  business_name text not null,
  full_name text not null,
  phone text not null,
  email text not null,
  status text not null default 'pending'
    check (status in ('pending', 'approved', 'rejected')),
  rejection_reason text,
  reviewed_by uuid references auth.users (id),
  reviewed_at timestamptz,
  created_at timestamptz not null default now()
);

-- One outstanding request per auth user (signup upserts on this).
create unique index if not exists signup_requests_auth_user_uq
  on public.signup_requests (auth_user_id);

alter table public.signup_requests enable row level security;

-- A requester can read their own row — drives the pending / declined screen.
drop policy if exists signup_requests_self_read on public.signup_requests;
create policy signup_requests_self_read on public.signup_requests
  for select
  using (auth_user_id = auth.uid());

-- A super_admin can read every request (defence-in-depth; the approvals list is
-- served by the service-role list-signup-requests fn to include verification
-- status, but this keeps direct reads possible too).
drop policy if exists signup_requests_superadmin_read on public.signup_requests;
create policy signup_requests_superadmin_read on public.signup_requests
  for select
  using (public.auth_user_role() = 'super_admin');

-- Note: no INSERT/UPDATE policies. All writes go through the service-role edge
-- functions (submit-signup-request, review-signup-request), which bypass RLS.
