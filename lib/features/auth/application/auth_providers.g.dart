// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'2f243b04dd88d4803e0fb0a51d03fefcc7e7d876';

/// Raw Supabase auth state stream — used to drive the router refresh.

@ProviderFor(authStateStream)
final authStateStreamProvider = AuthStateStreamProvider._();

/// Raw Supabase auth state stream — used to drive the router refresh.

final class AuthStateStreamProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Raw Supabase auth state stream — used to drive the router refresh.
  AuthStateStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateStreamProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateStreamHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authStateStream(ref);
  }
}

String _$authStateStreamHash() => r'4dca26676db04b80332928a4ce529c2c40995578';

/// The current app-level user record. Re-fetched whenever auth state changes.

@ProviderFor(currentAppUser)
final currentAppUserProvider = CurrentAppUserProvider._();

/// The current app-level user record. Re-fetched whenever auth state changes.

final class CurrentAppUserProvider
    extends
        $FunctionalProvider<AsyncValue<AppUser?>, AppUser?, FutureOr<AppUser?>>
    with $FutureModifier<AppUser?>, $FutureProvider<AppUser?> {
  /// The current app-level user record. Re-fetched whenever auth state changes.
  CurrentAppUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentAppUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentAppUserHash();

  @$internal
  @override
  $FutureProviderElement<AppUser?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AppUser?> create(Ref ref) {
    return currentAppUser(ref);
  }
}

String _$currentAppUserHash() => r'bf0c67d59b48ade23732bb4269a8bc38f579a8eb';

/// The [Salesman] entity for the currently logged-in salesman.
/// Null when the user is not a salesman or no salesman row exists.

@ProviderFor(currentSalesman)
final currentSalesmanProvider = CurrentSalesmanProvider._();

/// The [Salesman] entity for the currently logged-in salesman.
/// Null when the user is not a salesman or no salesman row exists.

final class CurrentSalesmanProvider
    extends
        $FunctionalProvider<
          AsyncValue<Salesman?>,
          Salesman?,
          FutureOr<Salesman?>
        >
    with $FutureModifier<Salesman?>, $FutureProvider<Salesman?> {
  /// The [Salesman] entity for the currently logged-in salesman.
  /// Null when the user is not a salesman or no salesman row exists.
  CurrentSalesmanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSalesmanProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSalesmanHash();

  @$internal
  @override
  $FutureProviderElement<Salesman?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Salesman?> create(Ref ref) {
    return currentSalesman(ref);
  }
}

String _$currentSalesmanHash() => r'91344523d7993be71a60c7b193a199d5496b1415';
