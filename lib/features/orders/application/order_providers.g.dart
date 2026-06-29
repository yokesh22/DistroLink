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
          AsyncValue<OrdersRepository>,
          OrdersRepository,
          FutureOr<OrdersRepository>
        >
    with $FutureModifier<OrdersRepository>, $FutureProvider<OrdersRepository> {
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
  $FutureProviderElement<OrdersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrdersRepository> create(Ref ref) {
    return ordersRepository(ref);
  }
}

String _$ordersRepositoryHash() => r'e0e53895bf716170205d67e7a2f8688294c0c2d0';

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

String _$recentOrdersHash() => r'eb766152f6a4ee3cd671411da91435350d19eab7';

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

String _$salesmanStatsHash() => r'f3980f6af3d813d95098f6a8a7f695412110f187';

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

String _$analyticsDataHash() => r'02eaaa540e38e00b0f06e7de922fd6c5c958ffac';

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

String _$topProductsHash() => r'624c927d194c94ecca99e3aacce142b9a275df1c';

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
    r'8d5827eb3c2d0e028b6ce845fde6f9f8d7b85dbe';

/// Outbox orders waiting to sync (pending + failed).

@ProviderFor(outboxOrders)
final outboxOrdersProvider = OutboxOrdersProvider._();

/// Outbox orders waiting to sync (pending + failed).

final class OutboxOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OutboxOrder>>,
          List<OutboxOrder>,
          FutureOr<List<OutboxOrder>>
        >
    with
        $FutureModifier<List<OutboxOrder>>,
        $FutureProvider<List<OutboxOrder>> {
  /// Outbox orders waiting to sync (pending + failed).
  OutboxOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'outboxOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$outboxOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<OutboxOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OutboxOrder>> create(Ref ref) {
    return outboxOrders(ref);
  }
}

String _$outboxOrdersHash() => r'8c3c4538be44caa34f646847b5e19b96364a661f';

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
    r'cf8489fa4aa6da3570e097ecfadd4bdb302cdd5e';

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
