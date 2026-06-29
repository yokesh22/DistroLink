// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: json['id'] as String,
  orderId: json['order_id'] as String,
  productId: json['product_id'] as String,
  itemCode: json['item_code'] as String,
  itemName: json['item_name'] as String,
  mrp: (json['mrp'] as num).toDouble(),
  sellingRate: (json['selling_rate'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  gstPercent: (json['gst_percent'] as num).toDouble(),
  lineTotal: (json['line_total'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
  freeQty: (json['free_qty'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'item_code': instance.itemCode,
      'item_name': instance.itemName,
      'mrp': instance.mrp,
      'selling_rate': instance.sellingRate,
      'quantity': instance.quantity,
      'gst_percent': instance.gstPercent,
      'line_total': instance.lineTotal,
      'created_at': instance.createdAt.toIso8601String(),
      'discount_percent': instance.discountPercent,
      'free_qty': instance.freeQty,
    };
