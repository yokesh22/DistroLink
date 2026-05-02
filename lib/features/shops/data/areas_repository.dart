import 'package:flutter/foundation.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AreasRepository {
  const AreasRepository(this._client);
  final SupabaseClient _client;

  Future<List<Area>> listAreas() async {
    debugPrint(
      'Areas query -> userId: ${_client.auth.currentUser?.id}, '
      'hasSession: ${_client.auth.currentSession != null}',
    );
    final rows = await _client
        .from('areas')
        .select('id, name, created_at')
        .order('name');
    debugPrint('Areas raw rows count: ${rows.length}');
    final areas = rows
        .map(Area.fromJson)
        .toList();
    debugPrint('Fetched areas (${areas.length}): ${areas.map((a) => a.name).toList()}');
    return areas;
  }
}
