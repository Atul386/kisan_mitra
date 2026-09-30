import 'reminder.dart';

abstract class ReminderRepository {
  /// Soonest first.
  Stream<List<Reminder>> watchReminders();
  Future<Reminder?> getReminder(String id);
  Future<void> addReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
}
