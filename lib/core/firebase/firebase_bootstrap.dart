import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../utils/error_reporter.dart';

/// True once [initializeFirebase] has completed successfully. Checked by
/// `auth_providers.dart` (and, later, other feature providers) to decide
/// between a `Firebase*Repository` and the offline-only `Local*Repository`
/// — the app must keep working when Firebase isn't configured for the
/// current platform (blueprint §7).
bool isFirebaseAvailable = false;

/// Called once from `main()`, before `runApp`. Never throws — a farmer on
/// a platform without Firebase configured (iOS/macOS today) still gets a
/// fully working offline-first app, just without cloud sync until that
/// platform is added in the Firebase console.
Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    isFirebaseAvailable = true;
  } catch (e, st) {
    isFirebaseAvailable = false;
    if (kDebugMode) {
      reportError(e, st, context: 'initializeFirebase');
    }
  }
}
