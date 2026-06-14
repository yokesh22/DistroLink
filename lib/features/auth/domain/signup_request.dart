import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

enum SignupRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

/// A distributor's request to use the app, awaiting super-admin review.
/// Until it is approved (which creates the real `users` row), the applicant
/// has no app access — only the pending / declined screens.
@freezed
abstract class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    required String id,
    @JsonKey(name: 'auth_user_id') required String authUserId,
    @JsonKey(name: 'business_name') required String businessName,
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    required String email,
    required SignupRequestStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    // Only populated by list-signup-requests (joins auth.users); defaults false
    // on a plain self-read where verification status isn't exposed.
    @JsonKey(name: 'email_verified') @Default(false) bool emailVerified,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
