// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminDashboardRepository)
final adminDashboardRepositoryProvider = AdminDashboardRepositoryProvider._();

final class AdminDashboardRepositoryProvider
    extends
        $FunctionalProvider<
          AdminDashboardRepository,
          AdminDashboardRepository,
          AdminDashboardRepository
        >
    with $Provider<AdminDashboardRepository> {
  AdminDashboardRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminDashboardRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminDashboardRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminDashboardRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminDashboardRepository create(Ref ref) {
    return adminDashboardRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminDashboardRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminDashboardRepository>(value),
    );
  }
}

String _$adminDashboardRepositoryHash() =>
    r'2d55bd6a31cf401894ce97029103ba07db24dd88';

@ProviderFor(adminDashboardKpis)
final adminDashboardKpisProvider = AdminDashboardKpisProvider._();

final class AdminDashboardKpisProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminDashboardKpis>,
          AdminDashboardKpis,
          FutureOr<AdminDashboardKpis>
        >
    with
        $FutureModifier<AdminDashboardKpis>,
        $FutureProvider<AdminDashboardKpis> {
  AdminDashboardKpisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminDashboardKpisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminDashboardKpisHash();

  @$internal
  @override
  $FutureProviderElement<AdminDashboardKpis> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminDashboardKpis> create(Ref ref) {
    return adminDashboardKpis(ref);
  }
}

String _$adminDashboardKpisHash() =>
    r'5f37fb66ade25e5481c87d42c5340ce78c7b9223';

@ProviderFor(ActivityFilterNotifier)
final activityFilterProvider = ActivityFilterNotifierProvider._();

final class ActivityFilterNotifierProvider
    extends $NotifierProvider<ActivityFilterNotifier, ActivityFilter> {
  ActivityFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityFilterNotifierHash();

  @$internal
  @override
  ActivityFilterNotifier create() => ActivityFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityFilter>(value),
    );
  }
}

String _$activityFilterNotifierHash() =>
    r'978e2ec6428409d41f930275a6c3c64d4f4f132a';

abstract class _$ActivityFilterNotifier extends $Notifier<ActivityFilter> {
  ActivityFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActivityFilter, ActivityFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityFilter, ActivityFilter>,
              ActivityFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(adminRecentActivity)
final adminRecentActivityProvider = AdminRecentActivityProvider._();

final class AdminRecentActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminRecentOrder>>,
          List<AdminRecentOrder>,
          FutureOr<List<AdminRecentOrder>>
        >
    with
        $FutureModifier<List<AdminRecentOrder>>,
        $FutureProvider<List<AdminRecentOrder>> {
  AdminRecentActivityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRecentActivityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRecentActivityHash();

  @$internal
  @override
  $FutureProviderElement<List<AdminRecentOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminRecentOrder>> create(Ref ref) {
    return adminRecentActivity(ref);
  }
}

String _$adminRecentActivityHash() =>
    r'651cf13571a9553256ba1c33721a5473457e2027';
