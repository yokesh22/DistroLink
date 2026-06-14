// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Area _$AreaFromJson(Map<String, dynamic> json) => _Area(
  id: json['id'] as String,
  name: json['name'] as String,
  distributorId: json['distributor_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$AreaToJson(_Area instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'distributor_id': instance.distributorId,
  'created_at': instance.createdAt.toIso8601String(),
};
