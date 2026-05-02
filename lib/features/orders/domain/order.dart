import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'order_number') required String orderNumber,
    @JsonKey(name: 'distributor_id') required String distributorId,
    @JsonKey(name: 'salesman_id') required String salesmanId,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'area_id') required String areaId,
    required double subtotal,
    @JsonKey(name: 'gst_total') required double gstTotal,
    @JsonKey(name: 'grand_total') required double grandTotal,
    @JsonKey(name: 'order_date') required DateTime orderDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Optional fields
    String? notes,
    // Joined from shops — populated by repo queries that include a shop join
    @JsonKey(name: 'shop_name') String? shopName,
    @JsonKey(name: 'shop_number') String? shopNumber,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
