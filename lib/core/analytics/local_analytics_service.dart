import 'package:flutter/foundation.dart';

import 'analytics_service.dart';

/// No backend yet — just a debug log, so event call sites throughout the
/// app are already correct once Firebase Analytics is wired in.
class LocalAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, {Map<String, Object?> parameters = const {}}) {
    if (kDebugMode) {
      debugPrint('[analytics] $name $parameters');
    }
  }
}
