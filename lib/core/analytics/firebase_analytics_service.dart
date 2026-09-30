import 'package:firebase_analytics/firebase_analytics.dart';

import '../utils/error_reporter.dart';
import 'analytics_service.dart';

/// Sends product-usage events to Firebase Analytics. Per the analytics
/// rules, callers pass only non-sensitive values (ids of crops/screens, never
/// names, phone numbers or amounts).
class FirebaseAnalyticsService implements AnalyticsService {
  FirebaseAnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    _analytics.logEvent(name: name, parameters: sanitizeParameters(parameters)).catchError((Object e, StackTrace st) {
      reportError(e, st, context: 'analytics');
    });
  }

  /// Firebase accepts only String and num values: drop nulls, turn booleans
  /// into 1/0 and everything else into text.
  static Map<String, Object> sanitizeParameters(Map<String, Object?> parameters) => {
        for (final e in parameters.entries)
          if (e.value != null)
            e.key: switch (e.value) {
              final num n => n,
              final bool b => b ? 1 : 0,
              final v => v.toString(),
            },
      };
}
