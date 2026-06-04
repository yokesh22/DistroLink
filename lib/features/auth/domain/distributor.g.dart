// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distributor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Distributor _$DistributorFromJson(Map<String, dynamic> json) => _Distributor(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  email: json['email'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$DistributorToJson(_Distributor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'created_at': instance.createdAt.toIso8601String(),
    };
