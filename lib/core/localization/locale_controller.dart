import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported languages per blueprint §3. Add future languages here only —
/// no other application logic needs to change.
const List<Locale> kSupportedLocales = [
  Locale('en'),
  Locale('hi'),
  Locale('mr'),
];

const _prefsKey = 'app_language';

/// Null while the farmer has not chosen a language yet (drives the
/// first-launch language screen in the router redirect).
class LocaleController extends AsyncNotifier<Locale?> {
  @override
  Future<Locale?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
    state = AsyncData(locale);
  }
}

final localeControllerProvider = AsyncNotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
