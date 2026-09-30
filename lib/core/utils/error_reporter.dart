import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../firebase/firebase_bootstrap.dart';

/// Central place errors land (blueprint §31, §42): technical details stay
/// in logs / Crashlytics, never shown to the farmer.
void reportError(Object error, StackTrace stackTrace, {String? context}) {
  if (kDebugMode) {
    debugPrint('[error]${context != null ? ' [$context]' : ''} $error');
    debugPrintStack(stackTrace: stackTrace);
    return;
  }
  if (isFirebaseAvailable) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: context);
  }
}
