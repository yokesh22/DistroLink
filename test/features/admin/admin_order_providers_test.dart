import 'package:distro_link/features/admin/application/admin_order_providers.dart';
import 'package:distro_link/features/admin/presentation/admin_orders_screen.dart';
import 'package:distro_link/features/auth/application/admin_salesman_providers.dart';
import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/auth/domain/app_user.dart';
import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:distro_link/features/orders/domain/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockOrdersRepository extends Mock implements OrdersRepository {}

class _FakeAdminSalesmenList extends AdminSalesmenList {
  _FakeAdminSalesmenList(this.salesmen);

  final List<Salesman> salesmen;

  @override
  Future<List<Salesman>> build() async => salesmen;
}

void main() {
  late _MockOrdersRepository repository;

  setUp(() {
    repository = _MockOrdersRepository();
    when(
      () => repository.listForDistributor(
        distributorId: any(named: 'distributorId'),
        page: any(named: 'page'),
        salesmanId: any(named: 'salesmanId'),
        from: any(named: 'from'),
        before: any(named: 'before'),
        search: any(named: 'search'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => []);
  });

  test('admin page query uses the current distributor and filters', () async {
    final from = DateTime(2026, 11, 2);
    final before = DateTime(2026, 11, 5);
    final container = ProviderContainer(
      overrides: [
        currentAppUserProvider.overrideWith(
          (ref) async => _user(role: UserRole.admin),
        ),
        ordersRepositoryProvider.overrideWith((ref) async => repository),
      ],
    );
    addTearDown(container.dispose);

    await container.read(
      adminOrdersPageProvider(
        page: 2,
        salesmanId: 'salesman-1',
        from: from,
        before: before,
        search: 'Market',
      ).future,
    );

    verify(
      () => repository.listForDistributor(
        distributorId: 'distributor-1',
        page: 2,
        salesmanId: 'salesman-1',
        from: from,
        before: before,
        search: 'Market',
      ),
    ).called(1);
  });

  testWidgets('renders order rows and filters them by salesman',
      (tester) async {
    final order = Order(
      id: 'order-1',
      orderNumber: 'ORD-1',
      distributorId: 'distributor-1',
      salesmanId: 'salesman-1',
      shopId: 'shop-1',
      areaId: 'area-1',
      subtotal: 100,
      gstTotal: 5,
      grandTotal: 105,
      orderDate: DateTime(2026, 11, 3),
      createdAt: DateTime(2026, 11, 3),
      shopName: 'Corner Shop',
      salesmanName: 'Alex Salesman',
    );
    final salesman = Salesman(
      id: 'salesman-1',
      distributorId: 'distributor-1',
      name: 'Alex Salesman',
      phone: '',
      email: '',
      isActive: true,
      createdAt: DateTime(2026),
    );
    when(
      () => repository.listForDistributor(
        distributorId: any(named: 'distributorId'),
        page: any(named: 'page'),
        salesmanId: any(named: 'salesmanId'),
        from: any(named: 'from'),
        before: any(named: 'before'),
        search: any(named: 'search'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => [order]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentAppUserProvider.overrideWith(
            (ref) async => _user(role: UserRole.admin),
          ),
          adminSalesmenListProvider.overrideWith(
            () => _FakeAdminSalesmenList([salesman]),
          ),
          ordersRepositoryProvider.overrideWith((ref) async => repository),
        ],
        child: const MaterialApp(home: AdminOrdersScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Corner Shop'), findsOneWidget);
    expect(find.textContaining('ORD-1'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alex Salesman').last);
    await tester.pumpAndSettle();

    verify(
      () => repository.listForDistributor(
        distributorId: 'distributor-1',
        page: 0,
        salesmanId: 'salesman-1',
        from: null,
        before: null,
        search: '',
      ),
    ).called(1);
  });

  test('non-admin users cannot read distributor orders through the provider',
      () async {
    final container = ProviderContainer(
      overrides: [
        currentAppUserProvider.overrideWith(
          (ref) async => _user(role: UserRole.salesman),
        ),
        ordersRepositoryProvider.overrideWith((ref) async => repository),
      ],
    );
    addTearDown(container.dispose);

    final orders = await container.read(
      adminOrdersPageProvider(page: 0).future,
    );

    expect(orders, isEmpty);
    verifyNever(
      () => repository.listForDistributor(
        distributorId: any(named: 'distributorId'),
        page: any(named: 'page'),
        salesmanId: any(named: 'salesmanId'),
        from: any(named: 'from'),
        before: any(named: 'before'),
        search: any(named: 'search'),
        pageSize: any(named: 'pageSize'),
      ),
    );
  });
}

AppUser _user({required UserRole role}) => AppUser(
  id: 'app-user-1',
  authUserId: 'auth-user-1',
  distributorId: 'distributor-1',
  role: role,
  fullName: 'Test User',
  phone: '',
  email: 'test@example.com',
  isActive: true,
  createdAt: DateTime(2026),
);
