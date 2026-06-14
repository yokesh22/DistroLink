import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/data/signup_requests_repository.dart';
import 'package:distro_link/features/auth/domain/signup_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_request_providers.g.dart';

@Riverpod(keepAlive: true)
SignupRequestsRepository signupRequestsRepository(Ref ref) =>
    SignupRequestsRepository(ref.watch(supabaseClientProvider));

/// The signed-in user's own signup request (null if none). Re-fetched on auth
/// changes. The router reads this to decide pending vs declined routing when a
/// logged-in user has no provisioned `users` row.
@Riverpod(keepAlive: true)
Future<SignupRequest?> mySignupRequest(Ref ref) async {
  ref.watch(authStateStreamProvider);
  return ref.watch(signupRequestsRepositoryProvider).myRequest();
}

/// Requests for the super-admin approvals screen, filtered by [status]
/// (one provider instance per tab).
@riverpod
Future<List<SignupRequest>> signupRequestsByStatus(
  Ref ref,
  SignupRequestStatus status,
) =>
    ref.watch(signupRequestsRepositoryProvider).listByStatus(status);
