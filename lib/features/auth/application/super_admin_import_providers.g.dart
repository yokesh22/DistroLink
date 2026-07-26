// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_admin_import_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(superAdminRepository)
final superAdminRepositoryProvider = SuperAdminRepositoryProvider._();

final class SuperAdminRepositoryProvider
    extends
        $FunctionalProvider<
          SuperAdminRepository,
          SuperAdminRepository,
          SuperAdminRepository
        >
    with $Provider<SuperAdminRepository> {
  SuperAdminRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'superAdminRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$superAdminRepositoryHash();

  @$internal
  @override
  $ProviderElement<SuperAdminRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SuperAdminRepository create(Ref ref) {
    return superAdminRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuperAdminRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuperAdminRepository>(value),
    );
  }
}

String _$superAdminRepositoryHash() =>
    r'4e340d889200fe0976442d0f11ba22e0cb53307e';

@ProviderFor(excelImportService)
final excelImportServiceProvider = ExcelImportServiceProvider._();

final class ExcelImportServiceProvider
    extends
        $FunctionalProvider<
          ExcelImportService,
          ExcelImportService,
          ExcelImportService
        >
    with $Provider<ExcelImportService> {
  ExcelImportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excelImportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excelImportServiceHash();

  @$internal
  @override
  $ProviderElement<ExcelImportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExcelImportService create(Ref ref) {
    return excelImportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcelImportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcelImportService>(value),
    );
  }
}

String _$excelImportServiceHash() =>
    r'ab55d96393b5c3b98ae5fb8f67715bce1fe21260';

@ProviderFor(importReportService)
final importReportServiceProvider = ImportReportServiceProvider._();

final class ImportReportServiceProvider
    extends
        $FunctionalProvider<
          ImportReportService,
          ImportReportService,
          ImportReportService
        >
    with $Provider<ImportReportService> {
  ImportReportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importReportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importReportServiceHash();

  @$internal
  @override
  $ProviderElement<ImportReportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ImportReportService create(Ref ref) {
    return importReportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImportReportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImportReportService>(value),
    );
  }
}

String _$importReportServiceHash() =>
    r'b7f070e3203329ce073b1a2a4c687febeffa65e3';

@ProviderFor(importShareService)
final importShareServiceProvider = ImportShareServiceProvider._();

final class ImportShareServiceProvider
    extends $FunctionalProvider<ShareService, ShareService, ShareService>
    with $Provider<ShareService> {
  ImportShareServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'importShareServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$importShareServiceHash();

  @$internal
  @override
  $ProviderElement<ShareService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareService create(Ref ref) {
    return importShareService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareService>(value),
    );
  }
}

String _$importShareServiceHash() =>
    r'24f19441f75d59399a23fd0ba647b87db06e39ec';

/// All distributors, for the bulk-import picker.

@ProviderFor(distributorsList)
final distributorsListProvider = DistributorsListProvider._();

/// All distributors, for the bulk-import picker.

final class DistributorsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Distributor>>,
          List<Distributor>,
          FutureOr<List<Distributor>>
        >
    with
        $FutureModifier<List<Distributor>>,
        $FutureProvider<List<Distributor>> {
  /// All distributors, for the bulk-import picker.
  DistributorsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distributorsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distributorsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Distributor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Distributor>> create(Ref ref) {
    return distributorsList(ref);
  }
}

String _$distributorsListHash() => r'54453897c52d7f06b069e8d1478bd044aa074435';

@ProviderFor(BulkImport)
final bulkImportProvider = BulkImportProvider._();

final class BulkImportProvider
    extends $NotifierProvider<BulkImport, BulkImportState> {
  BulkImportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bulkImportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bulkImportHash();

  @$internal
  @override
  BulkImport create() => BulkImport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BulkImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BulkImportState>(value),
    );
  }
}

String _$bulkImportHash() => r'620029aac9d6a04dc9cff2aab7da56625b3963e3';

abstract class _$BulkImport extends $Notifier<BulkImportState> {
  BulkImportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BulkImportState, BulkImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BulkImportState, BulkImportState>,
              BulkImportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
