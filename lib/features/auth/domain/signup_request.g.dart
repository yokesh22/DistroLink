// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignupRequest _$SignupRequestFromJson(Map<String, dynamic> json) =>
    _SignupRequest(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String,
      businessName: json['business_name'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      status: $enumDecode(_$SignupRequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      emailVerified: json['email_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$SignupRequestToJson(_SignupRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auth_user_id': instance.authUserId,
      'business_name': instance.businessName,
      'full_name': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'status': _$SignupRequestStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
      'reviewed_at': instance.reviewedAt?.toIso8601String(),
      'email_verified': instance.emailVerified,
    };

const _$SignupRequestStatusEnumMap = {
  SignupRequestStatus.pending: 'pending',
  SignupRequestStatus.approved: 'approved',
  SignupRequestStatus.rejected: 'rejected',
};
