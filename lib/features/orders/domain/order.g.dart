// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  orderNumber: json['order_number'] as String,
  distributorId: json['distributor_id'] as String,
  salesmanId: json['salesman_id'] as String,
  shopId: json['shop_id'] as String,
  areaId: json['area_id'] as String,
  subtotal: (json['subtotal'] as num).toDouble(),
  gstTotal: (json['gst_total'] as num).toDouble(),
  grandTotal: (json['grand_total'] as num).toDouble(),
  orderDate: DateTime.parse(json['order_date'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  notes: json['notes'] as String?,
  shopName: json['shop_name'] as String?,
  shopNumber: json['shop_number'] as String?,
  shopAddress: json['shop_address'] as String?,
  areaName: json['area_name'] as String?,
  salesmanName: json['salesman_name'] as String?,
  salesmanPhone: json['salesman_phone'] as String?,
  distributorName: json['distributor_name'] as String?,
  distributorPhone: json['distributor_phone'] as String?,
  distributorEmail: json['distributor_email'] as String?,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'order_number': instance.orderNumber,
  'distributor_id': instance.distributorId,
  'salesman_id': instance.salesmanId,
  'shop_id': instance.shopId,
  'area_id': instance.areaId,
  'subtotal': instance.subtotal,
  'gst_total': instance.gstTotal,
  'grand_total': instance.grandTotal,
  'order_date': instance.orderDate.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'notes': instance.notes,
  'shop_name': instance.shopName,
  'shop_number': instance.shopNumber,
  'shop_address': instance.shopAddress,
  'area_name': instance.areaName,
  'salesman_name': instance.salesmanName,
  'salesman_phone': instance.salesmanPhone,
  'distributor_name': instance.distributorName,
  'distributor_phone': instance.distributorPhone,
  'distributor_email': instance.distributorEmail,
};
