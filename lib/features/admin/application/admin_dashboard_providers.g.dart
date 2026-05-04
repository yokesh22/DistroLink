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
    r'1729cbadb12fda69c10000a4ac4093c0d1f94501';
