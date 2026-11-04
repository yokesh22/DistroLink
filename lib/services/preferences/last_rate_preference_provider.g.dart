// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_rate_preference_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted "Use last shop rate" toggle (Settings). When on, items added to an
/// order start at the rate last used for that shop, if it was edited — see
/// business-rules.md, Step 3. Per-device, off by default.
///
/// Lives in `services/` because both `settings` (toggle) and `orders` (rate
/// lookup) read it, and features never import each other.

@ProviderFor(UseLastShopRateNotifier)
final useLastShopRateProvider = UseLastShopRateNotifierProvider._();

/// Persisted "Use last shop rate" toggle (Settings). When on, items added to an
/// order start at the rate last used for that shop, if it was edited — see
/// business-rules.md, Step 3. Per-device, off by default.
///
/// Lives in `services/` because both `settings` (toggle) and `orders` (rate
/// lookup) read it, and features never import each other.
final class UseLastShopRateNotifierProvider
    extends $NotifierProvider<UseLastShopRateNotifier, bool> {
  /// Persisted "Use last shop rate" toggle (Settings). When on, items added to an
  /// order start at the rate last used for that shop, if it was edited — see
  /// business-rules.md, Step 3. Per-device, off by default.
  ///
  /// Lives in `services/` because both `settings` (toggle) and `orders` (rate
  /// lookup) read it, and features never import each other.
  UseLastShopRateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'useLastShopRateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$useLastShopRateNotifierHash();

  @$internal
  @override
  UseLastShopRateNotifier create() => UseLastShopRateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$useLastShopRateNotifierHash() =>
    r'029fc7dd844d52eed50e8c4a389b036c0a6b23ef';

/// Persisted "Use last shop rate" toggle (Settings). When on, items added to an
/// order start at the rate last used for that shop, if it was edited — see
/// business-rules.md, Step 3. Per-device, off by default.
///
/// Lives in `services/` because both `settings` (toggle) and `orders` (rate
/// lookup) read it, and features never import each other.

abstract class _$UseLastShopRateNotifier extends $Notifier<bool> {
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
