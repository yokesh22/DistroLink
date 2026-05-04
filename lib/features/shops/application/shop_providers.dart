import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/shops/data/areas_repository.dart';
import 'package:distro_link/features/shops/data/shops_repository.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/services/hive/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_providers.g.dart';

@riverpod
Future<AreasRepository> areasRepository(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final hive = await ref.watch(hiveServiceProvider.future);
  return AreasRepository(client, hive);
}

@riverpod
Future<ShopsRepository> shopsRepository(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final hive = await ref.watch(hiveServiceProvider.future);
  return ShopsRepository(client, hive);
}

@riverpod
Future<List<Area>> areas(Ref ref) async {
  final repo = await ref.watch(areasRepositoryProvider.future);
  return repo.listAreas();
}

@riverpod
Future<List<Shop>> shopsByArea(Ref ref, String areaId) async {
  final repo = await ref.watch(shopsRepositoryProvider.future);
  return repo.listByArea(areaId);
}

@riverpod
Future<List<Shop>> recentShops(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  final repo = await ref.watch(shopsRepositoryProvider.future);
  return repo.recentForSalesman(salesman.id);
}
