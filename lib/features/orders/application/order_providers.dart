import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:distro_link/features/orders/domain/order_type.dart';
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

  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items
          .where((i) => i.productId != productId)
          .toList(),
    );
  }

  void clear() => state = const OrderDraftState();
}
