import 'package:flutter/foundation.dart';

/// Central place errors land (blueprint §31, §42): technical details stay
/// in logs, never shown to the farmer. Swap the body for
/// `FirebaseCrashlytics.instance.recordError(...)` once Firebase exists —
/// call sites don't change.
void reportError(Object error, StackTrace stackTrace, {String? context}) {
  if (kDebugMode) {
    debugPrint('[error]${context != null ? ' [$context]' : ''} $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
