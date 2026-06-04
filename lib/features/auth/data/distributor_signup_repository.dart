import 'package:supabase_flutter/supabase_flutter.dart';

class DistributorSignupRepository {
  const DistributorSignupRepository(this._client);
  final SupabaseClient _client;

  /// Signs up a new distributor:
  /// 1. Creates a Supabase auth user and sends a confirmation email.
  /// 2. Calls the `create-distributor` Edge Function to insert the
  ///    `distributors` + `users` rows (requires service-role, hence Edge Fn).
  ///
  /// Throws if either step fails. If the Edge Function fails after
  /// auth sign-up, the auth user exists without DB rows — acceptable Phase 1
  /// debt (cleaned up manually or via a future cron).
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

    // Step 2: create distributor + users rows via Edge Function.
    final fnResponse = await _client.functions.invoke(
      'create-distributor',
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
          'Failed to set up distributor account';
      throw Exception(error);
    }
  }
}
