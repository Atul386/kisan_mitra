import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_bootstrap.dart';
import 'analytics_service.dart';
import 'firebase_analytics_service.dart';
import 'local_analytics_service.dart';

/// Firebase Analytics where Firebase is configured, otherwise a debug log —
/// call sites are identical either way.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return isFirebaseAvailable ? FirebaseAnalyticsService(FirebaseAnalytics.instance) : LocalAnalyticsService();
});
