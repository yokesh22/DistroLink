// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shop_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminShopsRepository)
final adminShopsRepositoryProvider = AdminShopsRepositoryProvider._();

final class AdminShopsRepositoryProvider
    extends
        $FunctionalProvider<
          AdminShopsRepository,
          AdminShopsRepository,
          AdminShopsRepository
        >
    with $Provider<AdminShopsRepository> {
  AdminShopsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminShopsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminShopsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminShopsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminShopsRepository create(Ref ref) {
    return adminShopsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminShopsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminShopsRepository>(value),
    );
  }
}

String _$adminShopsRepositoryHash() =>
    r'55b8c3d848dc99c8798898cc19ce430ecd5efe55';

@ProviderFor(AdminShopsList)
final adminShopsListProvider = AdminShopsListProvider._();

final class AdminShopsListProvider
    extends $AsyncNotifierProvider<AdminShopsList, List<Shop>> {
  AdminShopsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminShopsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminShopsListHash();

  @$internal
  @override
  AdminShopsList create() => AdminShopsList();
}

String _$adminShopsListHash() => r'954e1366a000e5dbc6c902e8d7e939546895ca9d';

abstract class _$AdminShopsList extends $AsyncNotifier<List<Shop>> {
  FutureOr<List<Shop>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Shop>>, List<Shop>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Shop>>, List<Shop>>,
              AsyncValue<List<Shop>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
