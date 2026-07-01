import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // A line whose selling rate defaults to the base rate (29.00), with headroom
  // up to MRP (30.00) — the exact shape of the "rate looks stuck at 29" report.
  const item = DraftItem(
    productId: 'p1',
    itemCode: 'SUN-01',
    itemName: 'Sunlight Bar',
    mrp: 30,
    baseRate: 29,
    sellingRate: 29,
    quantity: 2,
    gstPercent: 18,
  );

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(orderDraftProvider.notifier).addItem(item);
    return container;
  }

  group('OrderDraftNotifier.changeRate', () {
    test('accepts a rate BELOW the base rate (no base-rate floor)', () {
      final container = makeContainer();

      container.read(orderDraftProvider.notifier).changeRate('p1', 28.5);

      final line = container.read(orderDraftProvider).items.single;
      expect(line.sellingRate, 28.5);
      // Totals must follow the new rate: 28.5 × 2 = 57.
      expect(line.lineTotal, 57);
      expect(container.read(orderDraftProvider).subtotal, 57);
    });

    test('caps a rate above MRP at MRP', () {
      final container = makeContainer();

      container.read(orderDraftProvider.notifier).changeRate('p1', 999);

      expect(container.read(orderDraftProvider).items.single.sellingRate, 30);
    });

    test('floors a negative rate at 0', () {
      final container = makeContainer();

      container.read(orderDraftProvider.notifier).changeRate('p1', -5);

      expect(container.read(orderDraftProvider).items.single.sellingRate, 0);
    });
  });
}
