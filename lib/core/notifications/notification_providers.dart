import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase/firebase_bootstrap.dart';
import '../sync/sync_providers.dart';
import '../utils/error_reporter.dart';
import '../utils/shared_preferences_provider.dart';
import 'notification_service.dart';
import 'push_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

/// Stable int id for a scheduled reminder from a string entity id — the
/// plugin's API requires an int (Android notification id).
int notificationIdFor(String entityId) => entityId.hashCode & 0x7fffffff;

const _dailyReminderPrefsKey = 'daily_reminder_enabled';

/// Farmer's on/off choice for the 8 AM daily farm-plan reminder (on by default).
class DailyReminderEnabled extends Notifier<bool> {
  @override
  bool build() => ref.read(sharedPreferencesProvider).getBool(_dailyReminderPrefsKey) ?? true;

  Future<void> set(bool enabled) async {
    state = enabled;
    await ref.read(sharedPreferencesProvider).setBool(_dailyReminderPrefsKey, enabled);
  }
}

final dailyReminderEnabledProvider = NotifierProvider<DailyReminderEnabled, bool>(DailyReminderEnabled.new);

/// Null without Firebase or a signed-in Firebase user (guest mode): no push
/// then, since the server can only address a signed-in farmer.
final pushServiceProvider = Provider<PushService?>((ref) {
  if (!isFirebaseAvailable) return null;
  final service = PushService(
    messaging: FirebasePushMessaging(FirebaseMessaging.instance),
    store: ref.watch(cloudStoreProvider),
    prefs: ref.watch(sharedPreferencesProvider),
    showForeground: (title, body) => ref.read(notificationServiceProvider).showNow(
          id: DateTime.now().millisecondsSinceEpoch & 0x7fffffff,
          title: title,
          body: body,
        ),
  );
  ref.onDispose(service.dispose);
  return service;
});

/// Registers for push once a Firebase user exists. Watched from the app root.
final pushRegistrationProvider = FutureProvider<void>((ref) async {
  final uid = ref.watch(firebaseUidProvider).valueOrNull;
  final service = ref.watch(pushServiceProvider);
  if (uid == null || service == null) return;
  try {
    await service.register(uid);
  } catch (e, st) {
    reportError(e, st, context: 'pushRegistration');
  }
});
