// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  authUserId: json['auth_user_id'] as String,
  distributorId: json['distributor_id'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  fullName: json['full_name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'auth_user_id': instance.authUserId,
  'distributor_id': instance.distributorId,
  'role': _$UserRoleEnumMap[instance.role]!,
  'full_name': instance.fullName,
  'phone': instance.phone,
  'email': instance.email,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'super_admin',
  UserRole.admin: 'admin',
  UserRole.salesman: 'salesman',
};

_Salesman _$SalesmanFromJson(Map<String, dynamic> json) => _Salesman(
  id: json['id'] as String,
  distributorId: json['distributor_id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$SalesmanToJson(_Salesman instance) => <String, dynamic>{
  'id': instance.id,
  'distributor_id': instance.distributorId,
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
  'user_id': instance.userId,
};
