/// Today backed by [LocalAnalyticsService] (debug-log only). Swap for a
/// `FirebaseAnalyticsService` once Firebase exists — call sites elsewhere
/// in the app don't change (blueprint §30, §35).
///
/// Per §30: log product-usage events only, never personal or sensitive
/// values as parameters.
abstract class AnalyticsService {
  void logEvent(String name, {Map<String, Object?> parameters = const {}});
}
