// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hiveService)
final hiveServiceProvider = HiveServiceProvider._();

final class HiveServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<HiveService>,
          HiveService,
          FutureOr<HiveService>
        >
    with $FutureModifier<HiveService>, $FutureProvider<HiveService> {
  HiveServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveServiceHash();

  @$internal
  @override
  $FutureProviderElement<HiveService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HiveService> create(Ref ref) {
    return hiveService(ref);
  }
}

String _$hiveServiceHash() => r'0a1313a98a905ecc2d8b4dc7e5fa67e5e5dee643';
