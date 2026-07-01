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

    /// When non-null, this draft is editing an existing order (UPDATE) rather
    /// than creating a new one (INSERT). Holds the `orders.id` being edited.
    String? editingOrderId,
  }) = _OrderDraftState;

  const OrderDraftState._();

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);

  /// Pre-discount subtotal (Σ selling_rate × qty). Used by the bill preview and
  /// exports to show the discount as its own line.
  double get grossSubtotal =>
      items.fold(0, (sum, item) => sum + item.grossLineTotal);

  /// Total discount given across all lines (`grossSubtotal − subtotal`).
  double get discountTotal => grossSubtotal - subtotal;

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
    @Default(0) double discountPercent,
    @Default(0) int freeQty,
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

  /// Pre-discount line total (`selling_rate × quantity`).
  double get grossLineTotal => sellingRate * quantity;

  /// Discount amount, applied on top of [grossLineTotal].
  double get discountAmount => grossLineTotal * discountPercent / 100;

  /// Net taxable line total after discount. GST is charged on this value.
  double get lineTotal => grossLineTotal - discountAmount;

  /// Rounded to the nearest rupee, per business-rules.md GST math.
  double get gstAmount => (lineTotal * gstPercent / 100).round().toDouble();

  int get cgst => (gstAmount / 2).round();

  int get sgst => gstAmount.round() - cgst;

  // Selling rate is per-order: any value from 0 up to MRP is allowed (no
  // base-rate floor). See business-rules.md.
  bool isRateValid() => sellingRate >= 0 && sellingRate <= mrp;

  bool isDiscountValid() => discountPercent >= 0 && discountPercent <= 100;
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
