-- Per-distributor uniqueness for `shops.shop_number` (retailer code).
--
-- Companion to 0009 (areas). Goal: the three super-admin bulk imports behave
-- consistently — each catalog table's business key is unique *within a
-- distributor*, and a second distributor may reuse a code a first one already
-- owns.
--
-- Audit of the live schema (2026-08-24):
--   * areas    — had a GLOBAL unique(name); fixed by 0009 → unique(distributor_id, name).
--   * products — ALREADY unique(distributor_id, item_code); no change needed.
--   * shops    — had NO unique constraint on shop_number at all → this migration.
--
-- `shop_number` is OPTIONAL (admin/inline "add shop" omits it when blank, storing
-- NULL; the edit path can store ''). So instead of a plain constraint we use a
-- PARTIAL unique index that ignores NULL/empty codes — this matches the app's own
-- de-dup, which only tracks non-empty `shop_number`
-- (`SuperAdminRepository.existingShopNumbersLower`, admin add-shop guards). Coded
-- shops become unique per distributor; un-coded shops are never blocked.
--
-- NOTE: shops had no prior constraint, so existing rows MAY already contain
-- duplicate (distributor_id, shop_number) pairs — the index creation will then
-- fail (transactionally; nothing partially applied). Run this pre-check first and
-- resolve any rows it returns before applying:
--
--   select distributor_id, lower(shop_number) as code, count(*)
--   from public.shops
--   where shop_number is not null and shop_number <> ''
--   group by distributor_id, lower(shop_number)
--   having count(*) > 1;
--
-- (The app de-dups case-insensitively; this index is case-sensitive, mirroring
-- 0009/products. A stricter `(distributor_id, lower(shop_number))` index could
-- enforce case-insensitivity at the DB level if desired.)

create unique index if not exists shops_distributor_id_shop_number_key
  on public.shops (distributor_id, shop_number)
  where shop_number is not null and shop_number <> '';
