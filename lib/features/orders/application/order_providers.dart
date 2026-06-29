import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/orders/domain/order_type.dart';
import 'package:distro_link/features/orders/domain/order_with_items.dart';
import 'package:distro_link/features/shops/domain/area.dart';
import 'package:distro_link/features/shops/domain/shop.dart';
import 'package:distro_link/services/hive/hive_provider.dart';
import 'package:distro_link/services/hive/outbox_order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_providers.g.dart';

@Riverpod(keepAlive: true)
Future<OrdersRepository> ordersRepository(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final hive = await ref.watch(hiveServiceProvider.future);
  return OrdersRepository(client, hive);
}

// ─── Read providers ───────────────────────────────────────────────

@riverpod
Future<List<Order>> recentOrders(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.recentForSalesman(salesman.id);
}

@riverpod
Future<SalesmanStats> salesmanStats(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return SalesmanStats.empty;
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.salesmanStats(salesman.id);
}

@riverpod
Future<AnalyticsData> analyticsData(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return AnalyticsData.empty;
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.analyticsForSalesman(salesman.id, year: year, month: month);
}

@riverpod
Future<List<TopProduct>> topProducts(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.topProductsForSalesman(salesman.id);
}

@riverpod
Future<List<String>> lastOrderItemNames(Ref ref) async {
  final salesman = await ref.watch(currentSalesmanProvider.future);
  if (salesman == null) return [];
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.lastOrderItemNames(salesman.id);
}

/// Outbox orders waiting to sync (pending + failed).
@riverpod
Future<List<OutboxOrder>> outboxOrders(Ref ref) async {
  final repo = await ref.watch(ordersRepositoryProvider.future);
  return repo.allPendingOrFailed();
}

// ─── Order draft (mutable, 4-step flow) ──────────────────────────

@riverpod
class OrderDraftNotifier extends _$OrderDraftNotifier {
  @override
  OrderDraftState build() {
    ref.keepAlive();
    return const OrderDraftState();
  }

  void selectShop({required Area area, required Shop shop}) {
    state = state.copyWith(area: area, shop: shop);
  }

  /// Seeds the draft from an existing order so it can be edited and saved back
  /// (UPDATE). [catalog] is the current product list, used to recover each
  /// item's `baseRate` (not stored on `order_items`); if a product is no longer
  /// in the catalog we fall back to its snapshot selling rate so the line stays
  /// rate-valid. See `seedForEdit` usage in the order summary screen.
  void seedForEdit({
    required OrderWithItems owt,
    required List<Product> catalog,
  }) {
    final order = owt.order;
    final area = Area(
      id: order.areaId,
      name: order.areaName ?? '',
      distributorId: order.distributorId,
      createdAt: order.createdAt,
    );
    final shop = Shop(
      id: order.shopId,
      distributorId: order.distributorId,
      areaId: order.areaId,
      shopName: order.shopName ?? '',
      shopAddress: order.shopAddress ?? '',
      createdAt: order.createdAt,
      shopNumber: order.shopNumber,
    );
    final items = owt.items.map((oi) {
      final product = catalog.where((p) => p.id == oi.productId).firstOrNull;
      return DraftItem(
        productId: oi.productId,
        itemCode: oi.itemCode,
        itemName: oi.itemName,
        mrp: oi.mrp,
        baseRate: product?.baseRate ?? oi.sellingRate,
        sellingRate: oi.sellingRate,
        quantity: oi.quantity,
        gstPercent: oi.gstPercent,
        discountPercent: oi.discountPercent,
        freeQty: oi.freeQty,
      );
    }).toList();

    state = OrderDraftState(
      area: area,
      shop: shop,
      orderDate: order.orderDate,
      notes: order.notes ?? '',
      items: items,
      editingOrderId: order.id,
    );
  }

  void setDetails({
    DateTime? deliveryDate,
    OrderType? orderType,
    String? notes,
  }) {
    state = state.copyWith(
      deliveryDate: deliveryDate ?? state.deliveryDate,
      orderType: orderType ?? state.orderType,
      notes: notes ?? state.notes,
    );
  }

  void addItem(DraftItem item) {
    final existing = state.items.indexWhere(
      (i) => i.productId == item.productId,
    );
    if (existing >= 0) {
      final updated = List<DraftItem>.from(state.items);
      updated[existing] = updated[existing].copyWith(
        quantity: updated[existing].quantity + 1,
      );
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
  }

  void changeQty(String productId, int delta) {
    final updated = state.items.map((item) {
      if (item.productId != productId) return item;
      final newQty = (item.quantity + delta).clamp(1, 999);
      return item.copyWith(quantity: newQty);
    }).toList();
    state = state.copyWith(items: updated);
  }

  void changeRate(String productId, double rate) {
    final updated = state.items.map((item) {
      if (item.productId != productId) return item;
      return item.copyWith(
        sellingRate: rate.clamp(item.baseRate, item.mrp),
      );
    }).toList();
    state = state.copyWith(items: updated);
  }

  void changeDiscount(String productId, double pct) {
    final updated = state.items.map((item) {
      if (item.productId != productId) return item;
      return item.copyWith(discountPercent: pct.clamp(0, 100));
    }).toList();
    state = state.copyWith(items: updated);
  }

  void changeFreeQty(String productId, int qty) {
    final updated = state.items.map((item) {
      if (item.productId != productId) return item;
      return item.copyWith(freeQty: qty.clamp(0, 999));
    }).toList();
    state = state.copyWith(items: updated);
  }

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items
          .where((i) => i.productId != productId)
          .toList(),
    );
  }

  void clear() => state = const OrderDraftState();
}
