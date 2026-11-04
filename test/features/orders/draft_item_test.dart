import 'package:distro_link/features/catalog/domain/product.dart';
import 'package:distro_link/features/orders/domain/order_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final product = Product(
    id: 'p1',
    distributorId: 'd1',
    itemCode: 'SUN-01',
    itemName: 'Sunlight Bar',
    mrp: 30,
    baseRate: 29,
    gstPercent: 18,
    isActive: true,
    createdAt: DateTime(2026),
  );

  // "Use last shop rate" resolution — business-rules.md, Step 3.
  group('DraftItem.fromProduct', () {
    test('uses base rate when there is no last shop rate', () {
      final item = DraftItem.fromProduct(product);
      expect(item.sellingRate, 29);
      expect(item.quantity, 1);
    });

    test('uses base rate when the last rate equals base (not edited)', () {
      final item = DraftItem.fromProduct(product, lastRate: 29);
      expect(item.sellingRate, 29);
    });

    test('uses an edited last rate below base', () {
      final item = DraftItem.fromProduct(product, lastRate: 27.5);
      expect(item.sellingRate, 27.5);
      expect(item.baseRate, 29);
    });

    test('uses an edited last rate above base (and above MRP)', () {
      final item = DraftItem.fromProduct(product, lastRate: 31);
      expect(item.sellingRate, 31);
    });
  });
}
