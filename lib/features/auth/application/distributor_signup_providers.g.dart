// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distributor_signup_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(distributorSignupRepository)
final distributorSignupRepositoryProvider =
    DistributorSignupRepositoryProvider._();

final class DistributorSignupRepositoryProvider
    extends
        $FunctionalProvider<
          DistributorSignupRepository,
          DistributorSignupRepository,
          DistributorSignupRepository
        >
    with $Provider<DistributorSignupRepository> {
  DistributorSignupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distributorSignupRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distributorSignupRepositoryHash();

  @$internal
  @override
  $ProviderElement<DistributorSignupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DistributorSignupRepository create(Ref ref) {
    return distributorSignupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DistributorSignupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DistributorSignupRepository>(value),
    );
  }
}

String _$distributorSignupRepositoryHash() =>
    r'ba8ad9aa7173738c7396a575821b41ad0240a16f';
