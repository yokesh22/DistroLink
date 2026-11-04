import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'last_rate_preference_provider.g.dart';

const _kUseLastShopRateKey = 'use_last_shop_rate';

/// Persisted "Use last shop rate" toggle (Settings). When on, items added to an
/// order start at the rate last used for that shop, if it was edited — see
/// business-rules.md, Step 3. Per-device, off by default.
///
/// Lives in `services/` because both `settings` (toggle) and `orders` (rate
/// lookup) read it, and features never import each other.
@Riverpod(keepAlive: true)
class UseLastShopRateNotifier extends _$UseLastShopRateNotifier {
  @override
  bool build() {
    unawaited(_loadPersisted());
    return false;
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_kUseLastShopRateKey);
    if (value != null) state = value;
  }

  Future<void> set({required bool enabled}) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kUseLastShopRateKey, enabled);
  }
}
