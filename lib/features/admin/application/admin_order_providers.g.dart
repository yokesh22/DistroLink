// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminOrderDetail)
final adminOrderDetailProvider = AdminOrderDetailFamily._();

final class AdminOrderDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderWithItems>,
          OrderWithItems,
          FutureOr<OrderWithItems>
        >
    with $FutureModifier<OrderWithItems>, $FutureProvider<OrderWithItems> {
  AdminOrderDetailProvider._({
    required AdminOrderDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminOrderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminOrderDetailHash();

  @override
  String toString() {
    return r'adminOrderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderWithItems> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderWithItems> create(Ref ref) {
    final argument = this.argument as String;
    return adminOrderDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminOrderDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminOrderDetailHash() => r'6dc8e2f015d52cf255a2fae41a74662095f06667';

final class AdminOrderDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderWithItems>, String> {
  AdminOrderDetailFamily._()
    : super(
        retry: null,
        name: r'adminOrderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminOrderDetailProvider call(String orderId) =>
      AdminOrderDetailProvider._(argument: orderId, from: this);

  @override
  String toString() => r'adminOrderDetailProvider';
}

@ProviderFor(SingleOrderExportController)
final singleOrderExportControllerProvider =
    SingleOrderExportControllerFamily._();

final class SingleOrderExportControllerProvider
    extends $NotifierProvider<SingleOrderExportController, ExportState> {
  SingleOrderExportControllerProvider._({
    required SingleOrderExportControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'singleOrderExportControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$singleOrderExportControllerHash();

  @override
  String toString() {
    return r'singleOrderExportControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SingleOrderExportController create() => SingleOrderExportController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SingleOrderExportControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$singleOrderExportControllerHash() =>
    r'51c47d4151b1aa78ece27a6fbdaab5d354c93fcb';

final class SingleOrderExportControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SingleOrderExportController,
          ExportState,
          ExportState,
          ExportState,
          String
        > {
  SingleOrderExportControllerFamily._()
    : super(
        retry: null,
        name: r'singleOrderExportControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SingleOrderExportControllerProvider call(String orderId) =>
      SingleOrderExportControllerProvider._(argument: orderId, from: this);

  @override
  String toString() => r'singleOrderExportControllerProvider';
}

abstract class _$SingleOrderExportController extends $Notifier<ExportState> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  ExportState build(String orderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ExportState, ExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportState, ExportState>,
              ExportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
