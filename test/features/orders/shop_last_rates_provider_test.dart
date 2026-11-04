import 'package:distro_link/features/orders/application/order_providers.dart';
import 'package:distro_link/features/orders/data/orders_repository.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/preferences/last_rate_preference_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late _MockOrdersRepository repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = _MockOrdersRepository();
    when(
      () => repo.lastSellingRatesForShop('s1'),
    ).thenAnswer((_) async => {'p1': 27.5});
  });

  Future<ProviderContainer> makeContainer({
    required bool enabled,
    required bool online,
  }) async {
    final container = ProviderContainer(
      overrides: [
        isOnlineProvider.overrideWithValue(online),
        ordersRepositoryProvider.overrideWith((ref) async => repo),
      ],
    );
    addTearDown(container.dispose);
    await container
        .read(useLastShopRateProvider.notifier)
        .set(enabled: enabled);
    return container;
  }

  group('shopLastRatesProvider', () {
    test('is empty and skips the lookup when the toggle is off', () async {
      final container = await makeContainer(enabled: false, online: true);
      final rates = await container.read(shopLastRatesProvider('s1').future);
      expect(rates, isEmpty);
      verifyNever(() => repo.lastSellingRatesForShop(any()));
    });

    test('is empty and skips the lookup when offline', () async {
      final container = await makeContainer(enabled: true, online: false);
      final rates = await container.read(shopLastRatesProvider('s1').future);
      expect(rates, isEmpty);
      verifyNever(() => repo.lastSellingRatesForShop(any()));
    });

    test('returns the repository rates when on and online', () async {
      final container = await makeContainer(enabled: true, online: true);
      final rates = await container.read(shopLastRatesProvider('s1').future);
      expect(rates, {'p1': 27.5});
    });
  });

  test('toggle persists to SharedPreferences', () async {
    await makeContainer(enabled: true, online: true);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('use_last_shop_rate'), isTrue);
  });
}
