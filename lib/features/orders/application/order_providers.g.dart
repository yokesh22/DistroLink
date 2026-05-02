// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ordersRepository)
final ordersRepositoryProvider = OrdersRepositoryProvider._();

final class OrdersRepositoryProvider
    extends
        $FunctionalProvider<
          OrdersRepository,
          OrdersRepository,
          OrdersRepository
        >
    with $Provider<OrdersRepository> {
  OrdersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrdersRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrdersRepository create(Ref ref) {
    return ordersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrdersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrdersRepository>(value),
    );
  }
}

String _$ordersRepositoryHash() => r'be64e7c3a647f46c17bb6ee7c468c0ba1502fdbe';

@ProviderFor(recentOrders)
final recentOrdersProvider = RecentOrdersProvider._();

final class RecentOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Order>>,
          List<Order>,
          FutureOr<List<Order>>
        >
    with $FutureModifier<List<Order>>, $FutureProvider<List<Order>> {
  RecentOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<Order>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Order>> create(Ref ref) {
    return recentOrders(ref);
  }
}

String _$recentOrdersHash() => r'5c442bb353848e6aebed9963669ac9951b7ec647';

@ProviderFor(salesmanStats)
final salesmanStatsProvider = SalesmanStatsProvider._();

final class SalesmanStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SalesmanStats>,
          SalesmanStats,
          FutureOr<SalesmanStats>
        >
    with $FutureModifier<SalesmanStats>, $FutureProvider<SalesmanStats> {
  SalesmanStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'salesmanStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$salesmanStatsHash();

  @$internal
  @override
  $FutureProviderElement<SalesmanStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SalesmanStats> create(Ref ref) {
    return salesmanStats(ref);
  }
}

String _$salesmanStatsHash() => r'a8f23e777f8c37c83247561d4c36d404063c3246';

@ProviderFor(analyticsData)
final analyticsDataProvider = AnalyticsDataFamily._();

final class AnalyticsDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalyticsData>,
          AnalyticsData,
          FutureOr<AnalyticsData>
        >
    with $FutureModifier<AnalyticsData>, $FutureProvider<AnalyticsData> {
  AnalyticsDataProvider._({
    required AnalyticsDataFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'analyticsDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$analyticsDataHash();

  @override
  String toString() {
    return r'analyticsDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<AnalyticsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalyticsData> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return analyticsData(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is AnalyticsDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$analyticsDataHash() => r'cf40bf94771cbd4fd3ec296f7e55c4d6cab4ad97';

final class AnalyticsDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<AnalyticsData>,
          ({int year, int month})
        > {
  AnalyticsDataFamily._()
    : super(
        retry: null,
        name: r'analyticsDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AnalyticsDataProvider call({required int year, required int month}) =>
      AnalyticsDataProvider._(argument: (year: year, month: month), from: this);

  @override
  String toString() => r'analyticsDataProvider';
}

@ProviderFor(topProducts)
final topProductsProvider = TopProductsProvider._();

final class TopProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TopProduct>>,
          List<TopProduct>,
          FutureOr<List<TopProduct>>
        >
    with $FutureModifier<List<TopProduct>>, $FutureProvider<List<TopProduct>> {
  TopProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'topProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$topProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<TopProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TopProduct>> create(Ref ref) {
    return topProducts(ref);
  }
}

String _$topProductsHash() => r'1de29e9040a473b3ffbc6a38e302dd9544bdcdda';

@ProviderFor(lastOrderItemNames)
final lastOrderItemNamesProvider = LastOrderItemNamesProvider._();

final class LastOrderItemNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  LastOrderItemNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastOrderItemNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastOrderItemNamesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return lastOrderItemNames(ref);
  }
}

String _$lastOrderItemNamesHash() =>
    r'8097a5dac55370dfbf86642ee1c68c3b8474099b';

@ProviderFor(OrderDraftNotifier)
final orderDraftProvider = OrderDraftNotifierProvider._();

final class OrderDraftNotifierProvider
    extends $NotifierProvider<OrderDraftNotifier, OrderDraftState> {
  OrderDraftNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderDraftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderDraftNotifierHash();

  @$internal
  @override
  OrderDraftNotifier create() => OrderDraftNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderDraftState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderDraftState>(value),
    );
  }
}

String _$orderDraftNotifierHash() =>
    r'78a2de6c4327f448e383bce62e88b10d9c858263';

abstract class _$OrderDraftNotifier extends $Notifier<OrderDraftState> {
  OrderDraftState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OrderDraftState, OrderDraftState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OrderDraftState, OrderDraftState>,
              OrderDraftState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
