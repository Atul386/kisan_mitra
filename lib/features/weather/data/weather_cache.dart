import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/weather_snapshot.dart';

/// "Store last successful response locally" (blueprint §17, §23) so the
/// weather card still shows something useful when offline.
class WeatherCache {
  WeatherCache(this._prefs);

  final SharedPreferences _prefs;

  String _key(String farmId) => 'weather_cache_$farmId';

  WeatherSnapshot? read(String farmId) {
    final raw = _prefs.getString(_key(farmId));
    if (raw == null) return null;
    try {
      return WeatherSnapshot.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String farmId, WeatherSnapshot snapshot) {
    return _prefs.setString(_key(farmId), jsonEncode(snapshot.toJson()));
  }
}
