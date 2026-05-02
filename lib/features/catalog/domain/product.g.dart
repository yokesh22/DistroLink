// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  distributorId: json['distributor_id'] as String,
  itemCode: json['item_code'] as String,
  itemName: json['item_name'] as String,
  mrp: (json['mrp'] as num).toDouble(),
  baseRate: (json['base_rate'] as num).toDouble(),
  gstPercent: (json['gst_percent'] as num).toDouble(),
  isActive: json['is_active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'distributor_id': instance.distributorId,
  'item_code': instance.itemCode,
  'item_name': instance.itemName,
  'mrp': instance.mrp,
  'base_rate': instance.baseRate,
  'gst_percent': instance.gstPercent,
  'is_active': instance.isActive,
  'created_at': instance.createdAt.toIso8601String(),
};
