import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'core/utils/error_reporter.dart';
import 'core/utils/shared_preferences_provider.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Crashlytics-equivalent hook (§31) until Firebase exists — routes
      // both framework and async errors through the same [reportError]
      // call site that will forward to Crashlytics later.
      FlutterError.onError = (details) {
        reportError(details.exception, details.stack ?? StackTrace.current, context: 'flutter');
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        reportError(error, stack, context: 'platform');
        return true;
      };

      // Never throws — falls back to offline/local-only mode on platforms
      // without Firebase configured yet (blueprint §7).
      await initializeFirebase();

      final prefs = await SharedPreferences.getInstance();

      runApp(
        ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: const KisanMitraApp(),
        ),
      );
    },
    (error, stack) => reportError(error, stack, context: 'zone'),
  );
}
