// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_salesman_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminSalesmenRepository)
final adminSalesmenRepositoryProvider = AdminSalesmenRepositoryProvider._();

final class AdminSalesmenRepositoryProvider
    extends
        $FunctionalProvider<
          AdminSalesmenRepository,
          AdminSalesmenRepository,
          AdminSalesmenRepository
        >
    with $Provider<AdminSalesmenRepository> {
  AdminSalesmenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSalesmenRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSalesmenRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminSalesmenRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminSalesmenRepository create(Ref ref) {
    return adminSalesmenRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminSalesmenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminSalesmenRepository>(value),
    );
  }
}

String _$adminSalesmenRepositoryHash() =>
    r'a0be748d01e58b32c0a093cd90d2c27fa3aa91c8';

@ProviderFor(salesmanOrdersTodayMap)
final salesmanOrdersTodayMapProvider = SalesmanOrdersTodayMapProvider._();

final class SalesmanOrdersTodayMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  SalesmanOrdersTodayMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesmanOrdersTodayMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesmanOrdersTodayMapHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return salesmanOrdersTodayMap(ref);
  }
}

String _$salesmanOrdersTodayMapHash() =>
    r'8d0d63096b575645af27fcf5baae2fe9dc79c868';

@ProviderFor(AdminSalesmenList)
final adminSalesmenListProvider = AdminSalesmenListProvider._();

final class AdminSalesmenListProvider
    extends $AsyncNotifierProvider<AdminSalesmenList, List<Salesman>> {
  AdminSalesmenListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSalesmenListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSalesmenListHash();

  @$internal
  @override
  AdminSalesmenList create() => AdminSalesmenList();
}

String _$adminSalesmenListHash() => r'201b57cb4bdaa929b08f6460319ca96f45eaf16c';

abstract class _$AdminSalesmenList extends $AsyncNotifier<List<Salesman>> {
  FutureOr<List<Salesman>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Salesman>>, List<Salesman>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Salesman>>, List<Salesman>>,
              AsyncValue<List<Salesman>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
