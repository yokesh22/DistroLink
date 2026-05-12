// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_area_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminAreasRepository)
final adminAreasRepositoryProvider = AdminAreasRepositoryProvider._();

final class AdminAreasRepositoryProvider
    extends
        $FunctionalProvider<
          AdminAreasRepository,
          AdminAreasRepository,
          AdminAreasRepository
        >
    with $Provider<AdminAreasRepository> {
  AdminAreasRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAreasRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAreasRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminAreasRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminAreasRepository create(Ref ref) {
    return adminAreasRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminAreasRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminAreasRepository>(value),
    );
  }
}

String _$adminAreasRepositoryHash() =>
    r'6addb9e8d4831eda91acee8826929aaed9df2a4f';

@ProviderFor(AdminAreasList)
final adminAreasListProvider = AdminAreasListProvider._();

final class AdminAreasListProvider
    extends $AsyncNotifierProvider<AdminAreasList, List<Area>> {
  AdminAreasListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAreasListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAreasListHash();

  @$internal
  @override
  AdminAreasList create() => AdminAreasList();
}

String _$adminAreasListHash() => r'febda72b93485620b22e8bca838f212a88ef27e9';

abstract class _$AdminAreasList extends $AsyncNotifier<List<Area>> {
  FutureOr<List<Area>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Area>>, List<Area>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Area>>, List<Area>>,
              AsyncValue<List<Area>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
