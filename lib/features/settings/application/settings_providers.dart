import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

const _kThemeKey = 'theme_mode';

/// Persisted theme mode. Reads from SharedPreferences on first access.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    unawaited(_loadPersisted());
    return ThemeMode.system;
  }

  Future<void> _loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_kThemeKey);
    if (value == null) return;
    state = ThemeMode.values.firstWhere(
      (m) => m.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeKey, mode.name);
  }

  void toggle() => unawaited(
        set(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark),
      );
}

/// Debug-only "Simulate Offline" toggle — never persisted.
@Riverpod(keepAlive: true)
class OfflineSimNotifier extends _$OfflineSimNotifier {
  @override
  bool build() => false;

  bool get simulating => state;
  set simulating(bool value) => state = value;

  void toggle() => state = !state;
}
