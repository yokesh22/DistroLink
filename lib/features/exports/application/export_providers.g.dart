// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(excelExportService)
final excelExportServiceProvider = ExcelExportServiceProvider._();

final class ExcelExportServiceProvider
    extends
        $FunctionalProvider<
          ExcelExportService,
          ExcelExportService,
          ExcelExportService
        >
    with $Provider<ExcelExportService> {
  ExcelExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'excelExportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$excelExportServiceHash();

  @$internal
  @override
  $ProviderElement<ExcelExportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExcelExportService create(Ref ref) {
    return excelExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExcelExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExcelExportService>(value),
    );
  }
}

String _$excelExportServiceHash() =>
    r'5054ac409766fdda2e8ae5b272a99d9eb32ca11e';

@ProviderFor(pdfExportService)
final pdfExportServiceProvider = PdfExportServiceProvider._();

final class PdfExportServiceProvider
    extends
        $FunctionalProvider<
          PdfExportService,
          PdfExportService,
          PdfExportService
        >
    with $Provider<PdfExportService> {
  PdfExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfExportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfExportServiceHash();

  @$internal
  @override
  $ProviderElement<PdfExportService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfExportService create(Ref ref) {
    return pdfExportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfExportService>(value),
    );
  }
}

String _$pdfExportServiceHash() => r'76d9c20e397c691d9f06b375375a6a2934197b1f';

@ProviderFor(shareService)
final shareServiceProvider = ShareServiceProvider._();

final class ShareServiceProvider
    extends $FunctionalProvider<ShareService, ShareService, ShareService>
    with $Provider<ShareService> {
  ShareServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shareServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shareServiceHash();

  @$internal
  @override
  $ProviderElement<ShareService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShareService create(Ref ref) {
    return shareService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShareService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShareService>(value),
    );
  }
}

String _$shareServiceHash() => r'04c6c07ab5ad3a615e36c99fa1035232d7b2b553';

@ProviderFor(ordersInRange)
final ordersInRangeProvider = OrdersInRangeFamily._();

final class OrdersInRangeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderWithItems>>,
          List<OrderWithItems>,
          FutureOr<List<OrderWithItems>>
        >
    with
        $FutureModifier<List<OrderWithItems>>,
        $FutureProvider<List<OrderWithItems>> {
  OrdersInRangeProvider._({
    required OrdersInRangeFamily super.from,
    required ({DateTime from, DateTime to}) super.argument,
  }) : super(
         retry: null,
         name: r'ordersInRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ordersInRangeHash();

  @override
  String toString() {
    return r'ordersInRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<OrderWithItems>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderWithItems>> create(Ref ref) {
    final argument = this.argument as ({DateTime from, DateTime to});
    return ordersInRange(ref, from: argument.from, to: argument.to);
  }

  @override
  bool operator ==(Object other) {
    return other is OrdersInRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ordersInRangeHash() => r'049218cc0a8e58a5c759352ffb9169fd6f9c5382';

final class OrdersInRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<OrderWithItems>>,
          ({DateTime from, DateTime to})
        > {
  OrdersInRangeFamily._()
    : super(
        retry: null,
        name: r'ordersInRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrdersInRangeProvider call({required DateTime from, required DateTime to}) =>
      OrdersInRangeProvider._(argument: (from: from, to: to), from: this);

  @override
  String toString() => r'ordersInRangeProvider';
}
