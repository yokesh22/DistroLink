import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/orders/application/order_providers.dart'
    show OrderDraftNotifier;
import 'package:distro_link/features/orders/data/orders_repository.dart'
    show OrdersRepository;
import 'package:distro_link/features/orders/domain/order_type.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_draft.freezed.dart';

/// In-memory state for the 4-step order creation flow.
/// Never serialized to JSON — lives only in [OrderDraftNotifier].
@freezed
abstract class OrderDraftState with _$OrderDraftState {
  const factory OrderDraftState({
    Area? area,
    Shop? shop,
    DateTime? orderDate,
    DateTime? deliveryDate,
    @Default(OrderType.regular) OrderType orderType,
    @Default('') String notes,
    @Default([]) List<DraftItem> items,
  }) = _OrderDraftState;

  const OrderDraftState._();

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  double get gstTotal => items.fold(0, (sum, item) => sum + item.gstAmount);

  double get grandTotal => subtotal + gstTotal;

  bool get isValid => area != null && shop != null && items.isNotEmpty;
}

/// A single line in the order draft.
@freezed
abstract class DraftItem with _$DraftItem {
  const factory DraftItem({
    required String productId,
    required String itemCode,
    required String itemName,
    required double mrp,
    required double baseRate,
    required double sellingRate,
    required int quantity,
    required double gstPercent,
  }) = _DraftItem;

  /// Build a draft item from a [Product] using the selling rate as the default
  /// selling rate — called when the salesman taps a Quick Add chip.
  factory DraftItem.fromProduct(Product p) => DraftItem(
    productId: p.id,
    itemCode: p.itemCode,
    itemName: p.itemName,
    mrp: p.mrp,
    baseRate: p.baseRate,
    sellingRate: p.baseRate,
    quantity: 1,
    gstPercent: p.gstPercent,
  );

  const DraftItem._();

  double get lineTotal => sellingRate * quantity;

  /// Rounded to the nearest rupee, per business-rules.md GST math.
  double get gstAmount => (lineTotal * gstPercent / 100).round().toDouble();

  int get cgst => (gstAmount / 2).round();

  int get sgst => gstAmount.round() - cgst;

  bool isRateValid() => sellingRate >= baseRate && sellingRate <= mrp;
}

/// Simple data class for the stats the dashboard displays.
/// Not serialized; computed by [OrdersRepository.salesmanStats].
class SalesmanStats {
  const SalesmanStats({
    required this.ordersToday,
    required this.revenueToday,
    required this.shopsVisited,
    this.pendingSync = 0,
  });

  final int ordersToday;
  final double revenueToday;
  final int shopsVisited;
  final int pendingSync;

  static const empty = SalesmanStats(
    ordersToday: 0,
    revenueToday: 0,
    shopsVisited: 0,
  );
}
