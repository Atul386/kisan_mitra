import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/shared_preferences_provider.dart';
import 'notification_service.dart';

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
