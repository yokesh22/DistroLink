import 'package:distro_link/features/shops/domain/area.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminAreasRepository {
  const AdminAreasRepository(this._client);
  final SupabaseClient _client;

  Future<List<Area>> list() async {
    final rows = await _client.from('areas').select().order('name');
    return rows.map(Area.fromJson).toList();
  }

  Future<Area> create(String name) async {
    final row = await _client
        .from('areas')
        .insert({'name': name.trim()})
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
