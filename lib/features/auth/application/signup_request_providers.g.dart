// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(signupRequestsRepository)
final signupRequestsRepositoryProvider = SignupRequestsRepositoryProvider._();

final class SignupRequestsRepositoryProvider
    extends
        $FunctionalProvider<
          SignupRequestsRepository,
          SignupRequestsRepository,
          SignupRequestsRepository
        >
    with $Provider<SignupRequestsRepository> {
  SignupRequestsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupRequestsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupRequestsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SignupRequestsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SignupRequestsRepository create(Ref ref) {
    return signupRequestsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignupRequestsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignupRequestsRepository>(value),
    );
  }
}

String _$signupRequestsRepositoryHash() =>
    r'13aec03dba15f69013cfc22d8973d52037becaad';

/// The signed-in user's own signup request (null if none). Re-fetched on auth
/// changes. The router reads this to decide pending vs declined routing when a
/// logged-in user has no provisioned `users` row.

@ProviderFor(mySignupRequest)
final mySignupRequestProvider = MySignupRequestProvider._();

/// The signed-in user's own signup request (null if none). Re-fetched on auth
/// changes. The router reads this to decide pending vs declined routing when a
/// logged-in user has no provisioned `users` row.

final class MySignupRequestProvider
    extends
        $FunctionalProvider<
          AsyncValue<SignupRequest?>,
          SignupRequest?,
          FutureOr<SignupRequest?>
        >
    with $FutureModifier<SignupRequest?>, $FutureProvider<SignupRequest?> {
  /// The signed-in user's own signup request (null if none). Re-fetched on auth
  /// changes. The router reads this to decide pending vs declined routing when a
  /// logged-in user has no provisioned `users` row.
  MySignupRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mySignupRequestProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mySignupRequestHash();

  @$internal
  @override
  $FutureProviderElement<SignupRequest?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SignupRequest?> create(Ref ref) {
    return mySignupRequest(ref);
  }
}

String _$mySignupRequestHash() => r'139b73404157f6e754e1dd3a42c3df052dfbf191';

/// Requests for the super-admin approvals screen, filtered by [status]
/// (one provider instance per tab).

@ProviderFor(signupRequestsByStatus)
final signupRequestsByStatusProvider = SignupRequestsByStatusFamily._();

/// Requests for the super-admin approvals screen, filtered by [status]
/// (one provider instance per tab).

final class SignupRequestsByStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SignupRequest>>,
          List<SignupRequest>,
          FutureOr<List<SignupRequest>>
        >
    with
        $FutureModifier<List<SignupRequest>>,
        $FutureProvider<List<SignupRequest>> {
  /// Requests for the super-admin approvals screen, filtered by [status]
  /// (one provider instance per tab).
  SignupRequestsByStatusProvider._({
    required SignupRequestsByStatusFamily super.from,
    required SignupRequestStatus super.argument,
  }) : super(
         retry: null,
         name: r'signupRequestsByStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$signupRequestsByStatusHash();

  @override
  String toString() {
    return r'signupRequestsByStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SignupRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SignupRequest>> create(Ref ref) {
    final argument = this.argument as SignupRequestStatus;
    return signupRequestsByStatus(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SignupRequestsByStatusProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$signupRequestsByStatusHash() =>
    r'0a28a08e6a92e355d85b6f3c4becab79d0e22060';

/// Requests for the super-admin approvals screen, filtered by [status]
/// (one provider instance per tab).

final class SignupRequestsByStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<SignupRequest>>,
          SignupRequestStatus
        > {
  SignupRequestsByStatusFamily._()
    : super(
        retry: null,
        name: r'signupRequestsByStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Requests for the super-admin approvals screen, filtered by [status]
  /// (one provider instance per tab).

  SignupRequestsByStatusProvider call(SignupRequestStatus status) =>
      SignupRequestsByStatusProvider._(argument: status, from: this);

  @override
  String toString() => r'signupRequestsByStatusProvider';
}
