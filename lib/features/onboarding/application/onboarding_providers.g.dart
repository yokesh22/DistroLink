// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks whether the admin has explicitly dismissed the onboarding wizard
/// (by tapping "Go to Dashboard"). Kept alive so it persists across the
/// dashboard rebuild — prevents the redirect loop when 0 salesmen exist.

@ProviderFor(OnboardingDismissed)
final onboardingDismissedProvider = OnboardingDismissedProvider._();

/// Tracks whether the admin has explicitly dismissed the onboarding wizard
/// (by tapping "Go to Dashboard"). Kept alive so it persists across the
/// dashboard rebuild — prevents the redirect loop when 0 salesmen exist.
final class OnboardingDismissedProvider
    extends $NotifierProvider<OnboardingDismissed, bool> {
  /// Tracks whether the admin has explicitly dismissed the onboarding wizard
  /// (by tapping "Go to Dashboard"). Kept alive so it persists across the
  /// dashboard rebuild — prevents the redirect loop when 0 salesmen exist.
  OnboardingDismissedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingDismissedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingDismissedHash();

  @$internal
  @override
  OnboardingDismissed create() => OnboardingDismissed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingDismissedHash() =>
    r'341ddafe5507251c204d1f83d4011ee8d8f0de92';

/// Tracks whether the admin has explicitly dismissed the onboarding wizard
/// (by tapping "Go to Dashboard"). Kept alive so it persists across the
/// dashboard rebuild — prevents the redirect loop when 0 salesmen exist.

abstract class _$OnboardingDismissed extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
