// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Shop _$ShopFromJson(Map<String, dynamic> json) => _Shop(
  id: json['id'] as String,
  areaId: json['area_id'] as String,
  shopName: json['shop_name'] as String,
  shopAddress: json['shop_address'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  shopNumber: json['shop_number'] as String?,
  shopOwner: json['shop_owner'] as String?,
  phoneNo: json['phone_no'] as String?,
  gstin: json['gstin'] as String?,
);

Map<String, dynamic> _$ShopToJson(_Shop instance) => <String, dynamic>{
  'id': instance.id,
  'area_id': instance.areaId,
  'shop_name': instance.shopName,
  'shop_address': instance.shopAddress,
  'created_at': instance.createdAt.toIso8601String(),
  'shop_number': instance.shopNumber,
  'shop_owner': instance.shopOwner,
  'phone_no': instance.phoneNo,
  'gstin': instance.gstin,
};
