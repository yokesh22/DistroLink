import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'item_code') required String itemCode,
    @JsonKey(name: 'item_name') required String itemName,
    required double mrp,
    @JsonKey(name: 'selling_rate') required double sellingRate,
    required int quantity,
    @JsonKey(name: 'gst_percent') required double gstPercent,
    @JsonKey(name: 'line_total') required double lineTotal,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'discount_percent') @Default(0) double discountPercent,
    @JsonKey(name: 'free_qty') @Default(0) int freeQty,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}
