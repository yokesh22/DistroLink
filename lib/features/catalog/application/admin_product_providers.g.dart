// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminProductsRepository)
final adminProductsRepositoryProvider = AdminProductsRepositoryProvider._();

final class AdminProductsRepositoryProvider
    extends
        $FunctionalProvider<
          AdminProductsRepository,
          AdminProductsRepository,
          AdminProductsRepository
        >
    with $Provider<AdminProductsRepository> {
  AdminProductsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminProductsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminProductsRepository create(Ref ref) {
    return adminProductsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminProductsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminProductsRepository>(value),
    );
  }
}

String _$adminProductsRepositoryHash() =>
    r'd20e5771a24e2450507896cb0083571b373f0aed';

@ProviderFor(AdminProductsList)
final adminProductsListProvider = AdminProductsListProvider._();

final class AdminProductsListProvider
    extends $AsyncNotifierProvider<AdminProductsList, List<Product>> {
  AdminProductsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductsListHash();

  @$internal
  @override
  AdminProductsList create() => AdminProductsList();
}

String _$adminProductsListHash() => r'b41032723bf8cb359f5e23504a104764337e9f86';

abstract class _$AdminProductsList extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
