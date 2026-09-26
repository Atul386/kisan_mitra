import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/shared_preferences_provider.dart';

const _prefsKey = 'theme_mode';

/// Follows the phone's setting until the farmer flips the Dark mode switch.
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final saved = ref.read(sharedPreferencesProvider).getString(_prefsKey);
    return ThemeMode.values.firstWhere((m) => m.name == saved, orElse: () => ThemeMode.system);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(_prefsKey, mode.name);
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
