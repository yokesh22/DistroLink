import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/shops/data/areas_repository.dart';
import 'package:distro_link/features/shops/data/shops_repository.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_providers.g.dart';

@riverpod
AreasRepository areasRepository(Ref ref) =>
    AreasRepository(ref.watch(supabaseClientProvider));

@riverpod
ShopsRepository shopsRepository(Ref ref) =>
    ShopsRepository(ref.watch(supabaseClientProvider));

@riverpod
Future<List<Area>> areas(Ref ref) =>
    ref.watch(areasRepositoryProvider).listAreas();

@riverpod
Future<List<Shop>> shopsByArea(Ref ref, String areaId) =>
    ref.watch(shopsRepositoryProvider).listByArea(areaId);

/// Recent shops for the current salesman (Step 1 shortcut).
@riverpod
Future<List<Shop>> recentShops(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  return ref
      .watch(shopsRepositoryProvider)
      .recentForSalesman(salesman.id);
}
