import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Keeps the last successful API responses so the Mandi screen still has
/// something to show offline, and so switching tabs doesn't spend the
/// API's 100-requests-per-15-minutes allowance.
class MandiApiCache {
  MandiApiCache(this._prefs, {DateTime Function()? now, this.maxEntries = 40}) : _now = now ?? DateTime.now;

  final SharedPreferences _prefs;
  final DateTime Function() _now;
  final int maxEntries;

  static const _indexKey = 'mandi_api_cache_index';
  static String _entryKey(String key) => 'mandi_api_cache:$key';

  ({String body, DateTime savedAt})? read(String key) {
    final raw = _prefs.getString(_entryKey(key));
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return (body: json['body'] as String, savedAt: DateTime.parse(json['savedAt'] as String));
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, String body) async {
    await _prefs.setString(_entryKey(key), jsonEncode({'body': body, 'savedAt': _now().toIso8601String()}));
    final index = (_prefs.getStringList(_indexKey) ?? <String>[])..remove(key);
    index.add(key);
    // Drop the oldest entries so the cache can't grow without bound.
    while (index.length > maxEntries) {
      await _prefs.remove(_entryKey(index.removeAt(0)));
    }
    await _prefs.setStringList(_indexKey, index);
  }

  bool isFresh(DateTime savedAt, Duration ttl) => _now().difference(savedAt) < ttl;
}
