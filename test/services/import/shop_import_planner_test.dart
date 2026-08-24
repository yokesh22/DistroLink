import 'package:distro_link/services/import/import_models.dart';
import 'package:distro_link/services/import/shop_import_planner.dart';
import 'package:flutter_test/flutter_test.dart';

ShopRow _shop({
  int row = 2,
  String area = 'MG Road',
  String shop = 'Kumar Store',
  String code = '',
  String address = '12 Main St',
  String gst = '',
  String mobile = '',
  String owner = '',
}) => ShopRow(
  rowNumber: row,
  area: area,
  shop: shop,
  retailerCode: code,
  address: address,
  gstNo: gst,
  mobile: mobile,
  shopOwner: owner,
);

ImportPlan _plan(
  List<ShopRow> rows, {
  Map<String, String> areaMap = const {'mg road': 'A1'},
  Set<String> ambiguous = const {},
  Set<String> existingCodes = const {},
  Set<String> existingNameAreaKeys = const {},
  List<RowIssue> structuralIssues = const [],
}) => buildShopImportPlan(
  rows: rows,
  structuralIssues: structuralIssues,
  areaMap: areaMap,
  ambiguousAreas: ambiguous,
  existingCodes: existingCodes,
  existingNameAreaKeys: existingNameAreaKeys,
);

void main() {
  group('shopNameAreaKey', () {
    test('normalizes case and trims whitespace', () {
      expect(
        shopNameAreaKey('A1', '  Kumar Store  '),
        shopNameAreaKey('A1', 'kumar store'),
      );
    });

    test('same name in different areas does not collide', () {
      expect(
        shopNameAreaKey('A1', 'Kumar Store'),
        isNot(shopNameAreaKey('A2', 'Kumar Store')),
      );
    });
  });

  group('code-less dedup by name + area', () {
    test('skips a code-less row already existing by name + area', () {
      final plan = _plan(
        [_shop()], // default shop 'Kumar Store', area 'MG Road'
        existingNameAreaKeys: {shopNameAreaKey('A1', 'Kumar Store')},
      );

      expect(plan.toInsert, isEmpty);
      expect(plan.skipped.length, 1);
      expect(plan.skipped.single.issue, 'shop already exists in this area');
    });

    test('inserts a code-less row that is new by name + area', () {
      final plan = _plan([_shop(shop: 'Fresh Mart')]);

      expect(plan.toInsert.length, 1);
      expect(plan.skipped, isEmpty);
      // Blank retailer_code must not be written (NULL, not '').
      expect(plan.toInsert.single.containsKey('shop_number'), isFalse);
    });

    test('two identical code-less rows: first inserts, second skips', () {
      final plan = _plan([
        _shop(), // row 2, 'Kumar Store'
        _shop(row: 3, shop: 'kumar store'), // same shop, different case
      ]);

      expect(plan.toInsert.length, 1);
      expect(plan.skipped.length, 1);
      expect(plan.skipped.single.row.rowNumber, 3);
    });

    test('same name in different areas both insert (no false collision)', () {
      final plan = _plan(
        [
          _shop(), // MG Road / Kumar Store
          _shop(row: 3, area: 'Sector 12'), // Sector 12 / Kumar Store
        ],
        areaMap: const {'mg road': 'A1', 'sector 12': 'A2'},
      );

      expect(plan.toInsert.length, 2);
      expect(plan.skipped, isEmpty);
    });
  });

  group('coded dedup is unchanged and independent of name + area', () {
    test('skips a coded row whose retailer_code already exists', () {
      final plan = _plan(
        [_shop(code: 'SH-001')],
        existingCodes: {'sh-001'},
      );

      expect(plan.toInsert, isEmpty);
      expect(plan.skipped.single.issue, 'retailer_code already exists');
    });

    test(
      'coded row with a new code inserts even if name + area already exists',
      () {
        // Two branches of the same-named shop in one area are allowed when they
        // carry distinct codes — a code is an explicit "different shop" signal.
        final plan = _plan(
          [_shop(code: 'SH-NEW')], // default name 'Kumar Store'
          existingNameAreaKeys: {shopNameAreaKey('A1', 'Kumar Store')},
        );

        expect(plan.toInsert.length, 1);
        expect(plan.toInsert.single['shop_number'], 'SH-NEW');
        expect(plan.skipped, isEmpty);
      },
    );
  });

  group('area resolution and structural issues still block', () {
    test('area not found is blocking', () {
      final plan = _plan([_shop(area: 'Unknown')]);

      expect(plan.toInsert, isEmpty);
      expect(plan.canImport, isFalse);
      expect(plan.blocking.single.issue, 'area not found');
    });

    test('ambiguous area is blocking', () {
      final plan = _plan(
        [_shop()],
        areaMap: const {},
        ambiguous: {'mg road'},
      );

      expect(plan.canImport, isFalse);
      expect(plan.blocking.single.issue, 'ambiguous area name');
    });

    test('structural issues are carried into blocking and skip those rows', () {
      final badRow = _shop(shop: '');
      final plan = _plan(
        [badRow, _shop(row: 3, shop: 'Good Store')],
        structuralIssues: [
          RowIssue(row: badRow, issue: 'missing: shop'),
        ],
      );

      expect(plan.canImport, isFalse);
      expect(plan.blocking.single.row.rowNumber, 2);
      expect(plan.toInsert.length, 1); // only the good row
    });
  });
}
