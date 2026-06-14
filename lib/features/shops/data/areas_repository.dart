import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/services/hive/hive_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AreasRepository {
  AreasRepository(this._client, this._hive);

  final SupabaseClient _client;
  final HiveService _hive;

  Future<List<Area>> listAreas(String distributorId) async {
    final cached = _hive.areasBox.values
        .map(_toArea)
        .where((a) => a.distributorId == distributorId)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (cached.isNotEmpty) {
      _revalidate(distributorId).ignore();
      return cached;
    }
    try {
      return await _revalidate(distributorId);
    } on Exception {
      throw Exception(
        'No internet connection and no cached areas available. '
        'Please connect to the internet and try again.',
      );
    }
  }

  Future<List<Area>> _revalidate(String distributorId) async {
    final rows = await _client
        .from('areas')
        .select('id, name, distributor_id, created_at')
        .eq('distributor_id', distributorId)
        .order('name');
    final areas = rows.map(Area.fromJson).toList();
    await _hive.areasBox.clear();
    for (final area in areas) {
      await _hive.areasBox.put(area.id, area.toJson());
    }
    return areas;
  }

  Area _toArea(dynamic raw) =>
      Area.fromJson(Map<String, dynamic>.from(raw as Map));
}
