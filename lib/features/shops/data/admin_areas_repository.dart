import 'package:distro_link/features/shops/domain/area.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAreasRepository {
  const AdminAreasRepository(this._client);
  final SupabaseClient _client;

  Future<List<Area>> list(String distributorId) async {
    final rows = await _client
        .from('areas')
        .select()
        .eq('distributor_id', distributorId)
        .order('name');
    return rows.map(Area.fromJson).toList();
  }

  Future<Area> create(String distributorId, String name) async {
    final row = await _client
        .from('areas')
        .insert({'distributor_id': distributorId, 'name': name.trim()})
        .select()
        .single();
    return Area.fromJson(row);
  }

  Future<Area> update(String id, String name) async {
    final row = await _client
        .from('areas')
        .update({'name': name.trim()})
        .eq('id', id)
        .select()
        .single();
    return Area.fromJson(row);
  }

  Future<void> delete(String id) =>
      _client.from('areas').delete().eq('id', id);
}
