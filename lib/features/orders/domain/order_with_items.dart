import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_with_items.freezed.dart';

@freezed
abstract class OrderWithItems with _$OrderWithItems {
  const factory OrderWithItems({
    required Order order,
    required List<OrderItem> items,
  }) = _OrderWithItems;
}
