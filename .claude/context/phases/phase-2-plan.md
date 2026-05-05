# Phase 2 — Admin (Distributor) Module

> **Status:** In progress
> **Last updated:** 2026-05-03
> **Where this fits:** Phase 2 of 6. Full ladder: [roadmap.md](./roadmap.md).

---

## Goal

Self-service admin (role = `distributor`) can fully manage the catalog without engineering help.
Removes the dependency on backend-direct edits for salesmen, shops, products, and areas.

## Locked-in decisions

| Topic | Decision |
|---|---|
| Role string | `distributor` (not `admin`) — matches Supabase `users.role` |
| Salesman creation | Supabase Edge Function `create-user` (service-role key server-side); app inserts `public.users` + `public.salesmen` after |
| Areas screen | Dedicated list / add / edit, reachable from the Shops tab |
| Super-admin | Out of scope — `super_admin` gets the same admin shell for now |
| File structure | Admin layers co-located inside existing feature dirs (shops, auth, catalog); `features/admin/` holds only the shell + dashboard |

## Screens

| Screen | Route | Tab |
|---|---|---|
| Admin Dashboard | `/admin/dashboard` | Dashboard |
| Salesmen List | `/admin/salesmen` | Salesmen |
| Add / Edit Salesman | `/admin/salesmen/add`, `/admin/salesmen/:id/edit` | — |
| Shops List | `/admin/shops` | Shops |
| Add / Edit Shop | `/admin/shops/add`, `/admin/shops/:id/edit` | — |
| Areas List | `/admin/areas` | pushed from Shops |
| Add / Edit Area | `/admin/areas/add`, `/admin/areas/:id/edit` | — |
| Products List | `/admin/products` | Products |
| Add / Edit Product | `/admin/products/add`, `/admin/products/:id/edit` | — |

---

## Implementation checklist

### 1. Foundation
- [x] Fix `UserRole` enum: `@JsonValue('admin')` → `@JsonValue('distributor')`
- [x] Update router redirect: `currentAppUserProvider` drives role-based routing; both `distributor` + `super_admin` go to `/admin/dashboard`
- [x] Update `business-rules.md` role table

### 2. Edge Function
- [x] `supabase/functions/create-user/index.ts` — verifies caller is distributor/super_admin, calls `admin.createUser`, returns `auth_user_id`

### 3. Areas CRUD (in `features/shops/`)
- [x] `data/admin_areas_repository.dart` — `list()`, `create(name)`, `update(id, name)`, `delete(id)`
- [x] `application/admin_area_providers.dart` — `adminAreasListProvider` (AsyncNotifier with mutate methods)
- [x] `presentation/admin/areas_list_screen.dart`
- [x] `presentation/admin/add_edit_area_screen.dart`

### 4. Admin Salesmen CRUD (in `features/auth/`)
- [x] `data/admin_salesmen_repository.dart` — `list()`, `create()`, `update()`, `toggleActive()`
- [x] `application/admin_salesman_providers.dart`
- [x] `presentation/admin/salesmen_list_screen.dart`
- [x] `presentation/admin/add_edit_salesman_screen.dart`

### 5. Admin Shops CRUD (in `features/shops/`)
- [x] `data/admin_shops_repository.dart` — `list()`, `create()`, `update()`
- [x] `application/admin_shop_providers.dart`
- [x] `presentation/admin/shops_list_screen.dart`
- [x] `presentation/admin/add_edit_shop_screen.dart`

### 6. Admin Products CRUD (in `features/catalog/`)
- [x] `data/admin_products_repository.dart` — `list()`, `create()`, `update()`, `toggleActive()`
- [x] `application/admin_product_providers.dart`
- [x] `presentation/admin/products_list_screen.dart`
- [x] `presentation/admin/add_edit_product_screen.dart`

### 7. Admin shell + Dashboard (in `features/admin/`)
- [x] `presentation/admin_shell.dart` — bottom nav: Dashboard / Salesmen / Shops / Products
- [x] `data/admin_dashboard_repository.dart` — KPIs + recent activity
- [x] `application/admin_dashboard_providers.dart`
- [x] `presentation/admin_dashboard_screen.dart`

### 8. Router
- [x] New `ShellRoute` at `/admin` with 4-tab nav
- [x] All 9 admin routes registered
- [x] `/admin-not-yet` placeholder removed

### 9. Verification
- [ ] `flutter pub get && dart run build_runner build --delete-conflicting-outputs` — clean
- [ ] `flutter analyze` clean under `very_good_analysis`
- [ ] Login as distributor → lands on admin dashboard
- [ ] Create area → appears in area list and in shop add/edit dropdown
- [ ] Create shop with area → appears in salesman Step 1
- [ ] Create product → appears in salesman Step 3
- [ ] Create salesman → can log in, lands on salesman dashboard
- [ ] Deactivate salesman → login shows "Account disabled"
- [ ] Edit / deactivate product → reflects in catalog

---

## Progress log

- _2026-05-03_ — Phase 2 plan created; implementation starting.
