// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(distributorName)
final distributorNameProvider = DistributorNameProvider._();

final class DistributorNameProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  DistributorNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'distributorNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$distributorNameHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return distributorName(ref);
  }
}

String _$distributorNameHash() => r'0419c49f47db4528e836a881c041c00d32997d87';
