// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_export_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogExportService)
final catalogExportServiceProvider = CatalogExportServiceProvider._();

final class CatalogExportServiceProvider
    extends
        $FunctionalProvider<
          CatalogExportService,
          CatalogExportService,
          CatalogExportService
        >
    with $Provider<CatalogExportService> {
  CatalogExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogExportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogExportServiceHash();

  @$internal
  @override
  $ProviderElement<CatalogExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CatalogExportService create(Ref ref) {
    return catalogExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogExportService>(value),
    );
  }
}

String _$catalogExportServiceHash() =>
    r'bad74127e734f3a5e59295e74c0e26fd325f0263';

/// Drives the admin master-data export screen. Reuses [ExportState]
/// (idle/generating/done/error) from the orders-export feature.

@ProviderFor(AdminExportController)
final adminExportControllerProvider = AdminExportControllerProvider._();

/// Drives the admin master-data export screen. Reuses [ExportState]
/// (idle/generating/done/error) from the orders-export feature.
final class AdminExportControllerProvider
    extends $NotifierProvider<AdminExportController, ExportState> {
  /// Drives the admin master-data export screen. Reuses [ExportState]
  /// (idle/generating/done/error) from the orders-export feature.
  AdminExportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminExportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminExportControllerHash();

  @$internal
  @override
  AdminExportController create() => AdminExportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportState>(value),
    );
  }
}

String _$adminExportControllerHash() =>
    r'72a0b7536c939be25656d88c7cb85f00a764585f';

/// Drives the admin master-data export screen. Reuses [ExportState]
/// (idle/generating/done/error) from the orders-export feature.

abstract class _$AdminExportController extends $Notifier<ExportState> {
  ExportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportState, ExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportState, ExportState>,
              ExportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
