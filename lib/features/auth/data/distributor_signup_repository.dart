import 'package:supabase_flutter/supabase_flutter.dart';

class DistributorSignupRepository {
  const DistributorSignupRepository(this._client);
  final SupabaseClient _client;

  /// Signs up a new distributor:
  /// 1. Creates a Supabase auth user and sends a confirmation email.
  /// 2. Calls the `submit-signup-request` Edge Function to file a *pending*
  ///    request (service-role, hence Edge Fn).
  ///
  /// The distributor + users rows are NOT created here — that happens only when
  /// a super_admin approves the request (review-signup-request). Until then the
  /// app shows the pending-approval screen.
  ///
  /// Throws if either step fails. If the Edge Function fails after auth
  /// sign-up, the auth user exists without a request row — acceptable debt
  /// (the user can retry; submit is idempotent on auth_user_id).
  Future<void> signup({
    required String email,
    required String password,
    required String businessName,
    required String fullName,
    required String phone,
  }) async {
    // Step 1: create the auth user + trigger confirmation email.
    // emailRedirectTo ensures the confirmation link opens the app via deep
    // link instead of the Supabase project's default Site URL (localhost).
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: 'io.supabase.distrolink://login-callback',
    );

    final authUserId = response.user?.id;
    if (authUserId == null) {
      throw Exception(
        'Sign-up failed: no user returned. '
        'The email may already be registered.',
      );
    }

    // Step 2: file a pending signup request via Edge Function.
    final fnResponse = await _client.functions.invoke(
      'submit-signup-request',
      body: {
        'authUserId': authUserId,
        'businessName': businessName.trim(),
        'fullName': fullName.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
      },
    );

    if (fnResponse.status != 200) {
      final error = (fnResponse.data as Map<String, dynamic>?)?['error']
          as String? ??
          'Failed to submit your signup request';
      throw Exception(error);
    }
  }
}
