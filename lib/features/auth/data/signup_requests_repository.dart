import 'package:distro_link/features/auth/domain/signup_request.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads / reviews distributor signup requests.
///
/// - [myRequest] is a plain RLS self-read (any signed-in user) — drives the
///   pending / declined screens.
/// - [listByStatus], [approve] and [reject] go through super-admin-only
///   Edge Functions
///   (they need service-role access and the applicant's email verification
///   status, which the client cannot read directly).
class SignupRequestsRepository {
  const SignupRequestsRepository(this._client);
  final SupabaseClient _client;

  /// The signed-in user's own request, or null if none exists.
  Future<SignupRequest?> myRequest() async {
    final auth = _client.auth.currentUser;
    if (auth == null) return null;
    final data = await _client
        .from('signup_requests')
        .select()
        .eq('auth_user_id', auth.id)
        .maybeSingle();
    return data == null ? null : SignupRequest.fromJson(data);
  }

  /// All requests with the given [status], newest first. Super-admin only.
  Future<List<SignupRequest>> listByStatus(SignupRequestStatus status) async {
    final response = await _client.functions.invoke(
      'list-signup-requests',
      body: {'status': status.name},
    );
    if (response.status != 200) {
      throw Exception(_errorOf(response.data) ?? 'Failed to load requests');
    }
    final raw = (response.data as Map<String, dynamic>?)?['requests'] as List?;
    return (raw ?? [])
        .map((e) => SignupRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Approves a pending request, provisioning the distributor + admin user.
  Future<void> approve(String requestId) =>
      _review(requestId: requestId, action: 'approve');

  /// Rejects a pending request with an optional reason.
  Future<void> reject(String requestId, {String? reason}) =>
      _review(requestId: requestId, action: 'reject', reason: reason);

  Future<void> _review({
    required String requestId,
    required String action,
    String? reason,
  }) async {
    final response = await _client.functions.invoke(
      'review-signup-request',
      body: {
        'requestId': requestId,
        'action': action,
        'rejectionReason': ?reason,
      },
    );
    if (response.status != 200) {
      throw Exception(_errorOf(response.data) ?? 'Failed to review request');
    }
  }

  String? _errorOf(dynamic data) =>
      (data as Map<String, dynamic>?)?['error'] as String?;
}
