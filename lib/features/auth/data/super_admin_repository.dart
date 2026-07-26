import 'package:distro_link/features/auth/domain/distributor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Super-admin-only, cross-tenant data access.
///
/// These calls read/write outside the caller's own distributor, which normal
/// tenant RLS forbids. They rely on the super_admin policies added in migration
/// `0006_super_admin_cross_tenant.sql` (`distributors_super_admin_read`,
/// `areas_super_admin_rw`) and `0007_shops_super_admin_rw.sql`
/// (`shops_super_admin_rw`). A non-super-admin session hitting these gets an
/// RLS error / empty result — defence-in-depth on top of the UI role guard.
class SuperAdminRepository {
  const SuperAdminRepository(this._client);
  final SupabaseClient _client;

  /// Every distributor, alphabetical — for the bulk-import picker.
  Future<List<Distributor>> listDistributors() async {
    final rows =
        await _client.from('distributors').select().order('name');
    return rows.map(Distributor.fromJson).toList();
  }

  /// Lower-cased set of existing area names for [distributorId], used to skip
  /// duplicates before a bulk insert.
  Future<Set<String>> existingAreaNamesLower(String distributorId) async {
    final rows = await _client
        .from('areas')
        .select('name')
        .eq('distributor_id', distributorId);
    return {
      for (final row in rows)
        ((row['name'] as String?) ?? '').trim().toLowerCase(),
    };
  }

  /// Inserts [names] as areas for [distributorId] in one batch. Caller is
  /// responsible for de-duplication; this issues the raw insert.
  Future<void> bulkInsertAreas(
    String distributorId,
    List<String> names,
  ) async {
    if (names.isEmpty) return;
    await _client.from('areas').insert([
      for (final name in names)
        {'distributor_id': distributorId, 'name': name.trim()},
    ]);
  }

  // ─── Shops bulk import ──────────────────────────────────────────────────

  /// Resolves area names → ids for [distributorId] (keys lower-cased/trimmed).
  ///
  /// The returned `map` holds unambiguous names; `ambiguous` holds names shared
  /// by more than one area (those rows must be rejected — there's no unique
  /// constraint on area name).
  Future<({Map<String, String> map, Set<String> ambiguous})> areaNameToIdMap(
    String distributorId,
  ) async {
    final rows = await _client
        .from('areas')
        .select('id, name')
        .eq('distributor_id', distributorId);
    final map = <String, String>{};
    final ambiguous = <String>{};
    for (final row in rows) {
      final key = ((row['name'] as String?) ?? '').trim().toLowerCase();
      if (key.isEmpty) continue;
      if (map.containsKey(key)) {
        ambiguous.add(key);
      } else {
        map[key] = row['id'] as String;
      }
    }
    // Ambiguous names must not resolve to a single (wrong) id.
    ambiguous.forEach(map.remove);
    return (map: map, ambiguous: ambiguous);
  }

  /// Lower-cased set of existing `shop_number` (retailer code) values for
  /// [distributorId], used to skip duplicate shops.
  Future<Set<String>> existingShopNumbersLower(String distributorId) async {
    final rows = await _client
        .from('shops')
        .select('shop_number')
        .eq('distributor_id', distributorId);
    return {
      for (final row in rows)
        if ((row['shop_number'] as String?)?.trim().isNotEmpty ?? false)
          (row['shop_number'] as String).trim().toLowerCase(),
    };
  }

  /// Inserts already-resolved shop [rows] for [distributorId] in a single
  /// atomic statement. Each map must carry the resolved `area_id` and the
  /// `shops` column keys. Caller handles de-duplication/validation.
  Future<void> bulkInsertShops(
    String distributorId,
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) return;
    await _client.from('shops').insert([
      for (final row in rows) {...row, 'distributor_id': distributorId},
    ]);
  }

  // ─── Items (products) bulk import ───────────────────────────────────────

  /// Lower-cased set of existing `item_code` values for [distributorId], to
  /// skip duplicate products.
  Future<Set<String>> existingItemCodesLower(String distributorId) async {
    final rows = await _client
        .from('products')
        .select('item_code')
        .eq('distributor_id', distributorId);
    return {
      for (final row in rows)
        if ((row['item_code'] as String?)?.trim().isNotEmpty ?? false)
          (row['item_code'] as String).trim().toLowerCase(),
    };
  }

  /// Inserts already-typed product [rows] for [distributorId] in a single
  /// atomic statement. Caller handles de-duplication/validation.
  Future<void> bulkInsertProducts(
    String distributorId,
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) return;
    await _client.from('products').insert([
      for (final row in rows) {...row, 'distributor_id': distributorId},
    ]);
  }
}
