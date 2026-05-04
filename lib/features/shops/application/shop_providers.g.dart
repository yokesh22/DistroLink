// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(areasRepository)
final areasRepositoryProvider = AreasRepositoryProvider._();

final class AreasRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AreasRepository>,
          AreasRepository,
          FutureOr<AreasRepository>
        >
    with $FutureModifier<AreasRepository>, $FutureProvider<AreasRepository> {
  AreasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areasRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AreasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AreasRepository> create(Ref ref) {
    return areasRepository(ref);
  }
}

String _$areasRepositoryHash() => r'b31089c8e66a967c595cafdf141a37d95fa6915e';

@ProviderFor(shopsRepository)
final shopsRepositoryProvider = ShopsRepositoryProvider._();

final class ShopsRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShopsRepository>,
          ShopsRepository,
          FutureOr<ShopsRepository>
        >
    with $FutureModifier<ShopsRepository>, $FutureProvider<ShopsRepository> {
  ShopsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopsRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<ShopsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShopsRepository> create(Ref ref) {
    return shopsRepository(ref);
  }
}

String _$shopsRepositoryHash() => r'e519cc320cfc540d5026cda6c7395351bbdc1488';

@ProviderFor(areas)
final areasProvider = AreasProvider._();

final class AreasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Area>>,
          List<Area>,
          FutureOr<List<Area>>
        >
    with $FutureModifier<List<Area>>, $FutureProvider<List<Area>> {
  AreasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'areasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areasHash();

  @$internal
  @override
  $FutureProviderElement<List<Area>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Area>> create(Ref ref) {
    return areas(ref);
  }
}

String _$areasHash() => r'4e25d891ee8671540b00b2a73489399f28fbc35b';

@ProviderFor(shopsByArea)
final shopsByAreaProvider = ShopsByAreaFamily._();

final class ShopsByAreaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  ShopsByAreaProvider._({
    required ShopsByAreaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopsByAreaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopsByAreaHash();

  @override
  String toString() {
    return r'shopsByAreaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    final argument = this.argument as String;
    return shopsByArea(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopsByAreaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopsByAreaHash() => r'22489ad65d8463f93950164b16577067bd7f16e3';

final class ShopsByAreaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Shop>>, String> {
  ShopsByAreaFamily._()
    : super(
        retry: null,
        name: r'shopsByAreaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShopsByAreaProvider call(String areaId) =>
      ShopsByAreaProvider._(argument: areaId, from: this);

  @override
  String toString() => r'shopsByAreaProvider';
}

@ProviderFor(recentShops)
final recentShopsProvider = RecentShopsProvider._();

final class RecentShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  RecentShopsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentShopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentShopsHash();

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    return recentShops(ref);
  }
}

String _$recentShopsHash() => r'9704da7f39b3c20f0c64b67f71ac0e0a5151b5e0';
