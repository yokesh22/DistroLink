import 'package:distro_link/features/auth/application/auth_providers.dart';
import 'package:distro_link/features/settings/presentation/settings_screen.dart';
import 'package:distro_link/services/connectivity/connectivity_provider.dart';
import 'package:distro_link/services/preferences/last_rate_preference_provider.dart';
import 'package:distro_link/services/sync/pending_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer(
      overrides: [
        currentAppUserProvider.overrideWith((ref) async => null),
        currentSalesmanProvider.overrideWith((ref) async => null),
        isOnlineProvider.overrideWithValue(true),
        pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
      ],
    );
    addTearDown(container.dispose);
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder toggle() => find.descendant(
    of: find
        .ancestor(
          of: find.text('Use last shop rate'),
          matching: find.byType(Row),
        )
        .first,
    matching: find.byType(Switch),
  );

  bool enabled() => container.read(useLastShopRateProvider);

  testWidgets('enabling shows the notice; X keeps it off', (tester) async {
    await pumpSettings(tester);
    await tester.tap(toggle());
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(enabled(), isFalse);
  });

  testWidgets('OK on the notice turns it on', (tester) async {
    await pumpSettings(tester);
    await tester.tap(toggle());
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(enabled(), isTrue);
  });

  testWidgets('disabling applies immediately without a notice', (tester) async {
    await container.read(useLastShopRateProvider.notifier).set(enabled: true);
    await pumpSettings(tester);

    await tester.tap(toggle());
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(enabled(), isFalse);
  });
}
