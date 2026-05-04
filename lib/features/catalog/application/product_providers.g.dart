// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productsRepository)
final productsRepositoryProvider = ProductsRepositoryProvider._();

final class ProductsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProductsRepository>,
          ProductsRepository,
          FutureOr<ProductsRepository>
        >
    with
        $FutureModifier<ProductsRepository>,
        $FutureProvider<ProductsRepository> {
  ProductsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ProductsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProductsRepository> create(Ref ref) {
    return productsRepository(ref);
  }
}

String _$productsRepositoryHash() =>
    r'a575c7d41c82022733b6ad910a0628bdd351900b';

@ProviderFor(products)
final productsProvider = ProductsProvider._();

final class ProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  ProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return products(ref);
  }
}

String _$productsHash() => r'c3c7dd97a51bc5279a81dd66760537f6b7d7295e';

@ProviderFor(productSearch)
final productSearchProvider = ProductSearchFamily._();

final class ProductSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  ProductSearchProvider._({
    required ProductSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productSearchHash();

  @override
  String toString() {
    return r'productSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productSearchHash() => r'25d54d4377e3bfe877fbc9789aedf17986c351c3';

final class ProductSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  ProductSearchFamily._()
    : super(
        retry: null,
        name: r'productSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductSearchProvider call(String query) =>
      ProductSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'productSearchProvider';
}
