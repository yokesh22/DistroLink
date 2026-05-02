// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted theme mode. Reads from SharedPreferences on first access.

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

/// Persisted theme mode. Reads from SharedPreferences on first access.
final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, ThemeMode> {
  /// Persisted theme mode. Reads from SharedPreferences on first access.
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeNotifierHash() => r'7f970122d1788598588e48dcecf153df9e56fa82';

/// Persisted theme mode. Reads from SharedPreferences on first access.

abstract class _$ThemeModeNotifier extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Debug-only "Simulate Offline" toggle — never persisted.

@ProviderFor(OfflineSimNotifier)
final offlineSimProvider = OfflineSimNotifierProvider._();

/// Debug-only "Simulate Offline" toggle — never persisted.
final class OfflineSimNotifierProvider
    extends $NotifierProvider<OfflineSimNotifier, bool> {
  /// Debug-only "Simulate Offline" toggle — never persisted.
  OfflineSimNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineSimProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineSimNotifierHash();

  @$internal
  @override
  OfflineSimNotifier create() => OfflineSimNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$offlineSimNotifierHash() =>
    r'ca9d35c168ca6d3a2346cb1a3d7f6945a2b05086';

/// Debug-only "Simulate Offline" toggle — never persisted.

abstract class _$OfflineSimNotifier extends $Notifier<bool> {
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
