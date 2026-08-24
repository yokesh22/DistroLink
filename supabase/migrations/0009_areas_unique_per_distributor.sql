-- Per-distributor uniqueness for `areas.name`.
--
-- Areas are scoped per distributor (0001 added `distributor_id` + tenant RLS): two
-- distributors may each legitimately have an area named e.g. "Sector 12". But the
-- base table shipped with a GLOBAL `unique (name)` constraint (`areas_name_key`),
-- so once distributor A owns "Sector 12", distributor B's super-admin bulk import
-- of the same name failed with a unique-key violation ("already exists") even
-- though the app layer correctly scopes its duplicate check to B's own areas.
--
-- Fix: drop the global constraint and make uniqueness composite with
-- `distributor_id`. No backfill needed — the old global constraint already
-- guaranteed no duplicate names exist anywhere, so the looser composite constraint
-- is immediately satisfiable on existing rows.
--
-- Case-sensitivity: this constraint is case-sensitive, matching the previous
-- behavior and the app's own case-insensitive skip in `_submitAreas` (so no
-- normal-flow regression). A stricter `unique index on areas (distributor_id,
-- lower(name))` could enforce case-insensitivity at the DB level if desired.

alter table public.areas drop constraint if exists areas_name_key;

alter table public.areas
  add constraint areas_distributor_id_name_key unique (distributor_id, name);
