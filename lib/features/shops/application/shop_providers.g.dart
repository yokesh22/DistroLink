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
        $FunctionalProvider<AreasRepository, AreasRepository, AreasRepository>
    with $Provider<AreasRepository> {
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
  $ProviderElement<AreasRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AreasRepository create(Ref ref) {
    return areasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AreasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AreasRepository>(value),
    );
  }
}

String _$areasRepositoryHash() => r'cb0f0e043e750f68012700a588a806e617be64b9';

@ProviderFor(shopsRepository)
final shopsRepositoryProvider = ShopsRepositoryProvider._();

final class ShopsRepositoryProvider
    extends
        $FunctionalProvider<ShopsRepository, ShopsRepository, ShopsRepository>
    with $Provider<ShopsRepository> {
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
  $ProviderElement<ShopsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShopsRepository create(Ref ref) {
    return shopsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShopsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShopsRepository>(value),
    );
  }
}

String _$shopsRepositoryHash() => r'3aaf2f684a0a61d1932469b1ab5759b4b7bacc4d';

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

String _$areasHash() => r'5a59b6d4eb6584d5d3c3192ca3362b64d890526d';

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

String _$shopsByAreaHash() => r'e7058a66d07eeb3b67524f5aeb87bd1282c20889';

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

/// Recent shops for the current salesman (Step 1 shortcut).

@ProviderFor(recentShops)
final recentShopsProvider = RecentShopsProvider._();

/// Recent shops for the current salesman (Step 1 shortcut).

final class RecentShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  /// Recent shops for the current salesman (Step 1 shortcut).
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

String _$recentShopsHash() => r'95f7e212f5215fc7842db6b95cc750ab65e47ca2';
