-- RLS self-read policy for `users`.
--
-- `users` had RLS enabled but no SELECT policy, so the app (querying with the
-- end-user's JWT) could not read its own identity row — `currentAppUser()`
-- returned null and login dead-ended at "account not set up".
--
-- The SQL Editor bypasses RLS (runs as a privileged role), which is why the row
-- is visible there but not to the app.

alter table public.users enable row level security;

-- Every authenticated user can read their own identity row, keyed by auth.uid().
-- This is what login needs to resolve role + distributor_id.
drop policy if exists users_self_read on public.users;
create policy users_self_read on public.users
  for select
  using (auth_user_id = auth.uid());

-- Note: writes to `users` happen via the service-role edge functions
-- (create-user / create-distributor), which bypass RLS — so no insert/update
-- policy is required here for current flows.
