import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/catalog/application/admin_product_providers.dart';
import 'package:distro_link/features/exports/application/export_controller.dart';
import 'package:distro_link/features/exports/application/export_providers.dart';
import 'package:distro_link/features/shops/application/admin_area_providers.dart';
import 'package:distro_link/features/shops/application/admin_shop_providers.dart';
import 'package:distro_link/services/export/catalog_export_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_export_controller.g.dart';

/// The master-data lists an admin can export.
enum AdminExportSheet { areas, shops, products, salesmen }

@Riverpod(keepAlive: true)
CatalogExportService catalogExportService(Ref ref) => CatalogExportService();

/// Drives the admin master-data export screen. Reuses [ExportState]
/// (idle/generating/done/error) from the orders-export feature.
@riverpod
class AdminExportController extends _$AdminExportController {
  @override
  ExportState build() => const ExportState.idle();

  Future<void> generateAndShare({required Set<AdminExportSheet> sheets}) async {
    if (sheets.isEmpty) {
      state = const ExportState.error('Select at least one list to export.');
      return;
    }
    state = const ExportState.generating();
    try {
      final user = await ref.read(currentAppUserProvider.future);
      final distributorId = user?.distributorId;
      if (distributorId == null) {
        state = const ExportState.error('No distributor found for this user.');
        return;
      }

      final wantAreas = sheets.contains(AdminExportSheet.areas);
      final wantShops = sheets.contains(AdminExportSheet.shops);
      final wantProducts = sheets.contains(AdminExportSheet.products);
      final wantSalesmen = sheets.contains(AdminExportSheet.salesmen);

      // Areas are also needed to resolve area names on the Shops sheet, so
      // fetch them whenever either Areas or Shops is selected.
      final areas = (wantAreas || wantShops)
          ? await ref.read(adminAreasRepositoryProvider).list(distributorId)
          : null;
      final shops = wantShops
          ? await ref.read(adminShopsRepositoryProvider).list(distributorId)
          : null;
      final products = wantProducts
          ? await ref.read(adminProductsRepositoryProvider).list(distributorId)
          : null;
      final salesmen = wantSalesmen
          ? await ref.read(adminSalesmenRepositoryProvider).list(distributorId)
          : null;

      final file = await ref.read(catalogExportServiceProvider).generate(
            areas: wantAreas ? areas : null,
            shops: shops,
            products: products,
            salesmen: salesmen,
            areasForLookup: areas,
          );

      state = ExportState.done(file);
      await ref
          .read(shareServiceProvider)
          .shareFile(file, subject: 'DistroLink Master Data Export');
    } on Exception catch (e) {
      state = ExportState.error(e.toString());
    }
  }

  Future<void> shareAgain() async {
    final file = state.whenOrNull(done: (f) => f);
    if (file == null) return;
    await ref
        .read(shareServiceProvider)
        .shareFile(file, subject: 'DistroLink Master Data Export');
  }

  void reset() => state = const ExportState.idle();
}
