## New Order Step 1 - Location Dropdown Analysis

### Issue observed
- In the order-taking flow (`New Order` step 1), the area/location dropdown was not reliably working and locations were not appearing as expected from Supabase data.

### Root causes found
- The UI stored the selected area as a full `Area` object and bound that object directly to `DropdownButtonFormField`.
- Async reloads can rebuild item objects; using full objects for selection can make the dropdown state brittle compared to using a stable primitive key.
- Repository mapping relied on implicit dynamic typing (`rows.map(Area.fromJson)`), which is less defensive and can break silently depending on Supabase response shape.
- The `Next` action assumed `_selectedArea` is always non-null; that is unsafe if a user picks a recent shop first.

### Fix implemented
- Updated step-1 state to track `String? _selectedAreaId` instead of `Area?`.
- Changed area dropdown to `DropdownButtonFormField<String>` with `area.id` as item value.
- Shops query now uses `_selectedAreaId` directly (`shopsByAreaProvider(_selectedAreaId!)`).
- Added `_resolveSelectedArea(...)` helper to safely resolve area before moving to step 2.
  - Also supports recent-shop-first flow by inferring area from `shop.areaId`.
- Hardened `AreasRepository.listAreas()`:
  - Explicit select columns: `id, name, created_at`
  - Explicit cast from Supabase rows to `Map<String, dynamic>` for `Area.fromJson`.

### Files changed
- `lib/features/orders/presentation/new_order/select_shop_screen.dart`
- `lib/features/shops/data/areas_repository.dart`
- `.claude/new-order-location-analysis.md`

### Verification checklist
- Login as salesman and open `New Order`.
- Confirm area dropdown opens and shows all areas from Supabase.
- Select an area and confirm shop list loads for that area.
- Search and select a shop, then continue to step 2.
- Also test selecting from `Recent Shops` first, then continue to step 2.

---

## Additional fixes (navigation + layout crash)

### Back button ("No pop found")
- Root cause: Step-1 (`/orders/new/1`) is opened with `context.go(...)`, which replaces route stack and may not have a back entry to pop.
- Fix: back handler now uses:
  - `context.pop()` when `context.canPop()`
  - fallback `context.go('/orders')` when no route can be popped

### Blank screen on step 2 with infinite width error
- Error seen: `BoxConstraints forces an infinite width` with `RenderPhysicalShape` in `OrderDetailsScreen`.
- Root cause: app-wide button theme used `minimumSize: Size.fromHeight(48)`.
  - `Size.fromHeight(48)` means width is `double.infinity`.
  - This is invalid for buttons placed as non-flex children inside `Row` (e.g. back button row in step 2).
- Fix applied in theme:
  - `ElevatedButtonThemeData` minimum size -> `Size(0, 48)`
  - `OutlinedButtonThemeData` minimum size -> `Size(0, 48)`
- Result: buttons keep 48 height but no forced infinite width, removing the render crash.
