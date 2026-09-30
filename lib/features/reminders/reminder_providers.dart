import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/notifications/notification_providers.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/utils/ids.dart';
import 'data/local_reminder_repository.dart';
import 'domain/reminder.dart';
import 'domain/reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return LocalReminderRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final remindersProvider = StreamProvider<List<Reminder>>((ref) => ref.watch(reminderRepositoryProvider).watchReminders());

/// Reminders still to do, soonest first.
final pendingRemindersProvider = Provider<List<Reminder>>((ref) {
  return (ref.watch(remindersProvider).valueOrNull ?? const []).where((r) => !r.completed).toList();
});

/// Pending reminders due today — for the dashboard's "Today" area.
final todaysRemindersProvider = Provider<List<Reminder>>((ref) {
  final today = DateTime.now();
  return ref.watch(pendingRemindersProvider).where((r) => r.isDueOn(today)).toList();
});

/// Creates, edits, completes and deletes reminders, keeping the phone's
/// scheduled notification in step with the saved record.
class ReminderActions {
  ReminderActions(this._repo, this._notifications, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final ReminderRepository _repo;
  final NotificationService _notifications;
  final DateTime Function() _now;

  Future<void> add(Reminder reminder) async {
    final saved = reminder.id.isEmpty
        ? Reminder(
            id: newId(),
            title: reminder.title,
            body: reminder.body,
            scheduledFor: reminder.scheduledFor,
            category: reminder.category,
            repeat: reminder.repeat,
            cropId: reminder.cropId,
            notificationEnabled: reminder.notificationEnabled,
          )
        : reminder;
    await _repo.addReminder(saved);
    await _schedule(saved);
  }

  Future<void> update(Reminder reminder) async {
    await _repo.updateReminder(reminder);
    await _notifications.cancel(notificationIdFor(reminder.id));
    if (!reminder.completed) await _schedule(reminder);
  }

  /// One-off reminders become completed. Repeating ones stay active and
  /// move to their next occurrence, so ticking one off doesn't end it.
  Future<void> complete(Reminder reminder) async {
    if (reminder.repeat == ReminderRepeat.none) {
      await update(reminder.copyWith(completed: true));
    } else {
      await update(reminder.copyWith(scheduledFor: nextOccurrence(reminder.scheduledFor, reminder.repeat, _now())));
    }
  }

  Future<void> reopen(Reminder reminder) => update(reminder.copyWith(completed: false));

  Future<void> delete(String id) async {
    await _repo.deleteReminder(id);
    await _notifications.cancel(notificationIdFor(id));
  }

  Future<void> _schedule(Reminder r) async {
    if (r.completed || !r.notificationEnabled) return;
    // A repeating reminder whose start is in the past fires from its next slot.
    final at = r.repeat == ReminderRepeat.none ? r.scheduledFor : nextOccurrence(r.scheduledFor, r.repeat, _now());
    await _notifications.scheduleOneOff(
      id: notificationIdFor(r.id),
      title: r.title,
      body: r.body ?? 'KisanMitra 360',
      at: at,
      repeat: switch (r.repeat) {
        ReminderRepeat.none => null,
        ReminderRepeat.daily => DateTimeComponents.time,
        ReminderRepeat.weekly => DateTimeComponents.dayOfWeekAndTime,
        ReminderRepeat.monthly => DateTimeComponents.dayOfMonthAndTime,
      },
    );
  }
}

final reminderActionsProvider = Provider<ReminderActions>((ref) {
  return ReminderActions(ref.watch(reminderRepositoryProvider), ref.watch(notificationServiceProvider));
});
