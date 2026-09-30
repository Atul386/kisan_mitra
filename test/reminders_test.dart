import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/notifications/notification_providers.dart';
import 'package:kisan_mitra/core/notifications/notification_service.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/reminders/data/local_reminder_repository.dart';
import 'package:kisan_mitra/features/reminders/domain/reminder.dart';
import 'package:kisan_mitra/features/reminders/reminder_providers.dart';

class FakeNotifications implements NotificationService {
  final scheduled = <({int id, DateTime at, DateTimeComponents? repeat, String title})>[];
  final cancelled = <int>[];

  @override
  Future<void> scheduleOneOff({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    DateTimeComponents? repeat,
  }) async => scheduled.add((id: id, at: at, repeat: repeat, title: title));

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

void main() {
  group('nextOccurrence', () {
    final now = DateTime(2026, 9, 30, 9, 0);

    test('a non-repeating reminder is unchanged', () {
      final at = DateTime(2026, 9, 1, 7);
      expect(nextOccurrence(at, ReminderRepeat.none, now), at);
    });

    test('daily keeps the time of day and lands after now', () {
      expect(nextOccurrence(DateTime(2026, 9, 25, 7, 30), ReminderRepeat.daily, now), DateTime(2026, 10, 1, 7, 30));
      // Already later today: stays today.
      expect(nextOccurrence(DateTime(2026, 9, 30, 18), ReminderRepeat.daily, now), DateTime(2026, 9, 30, 18));
    });

    test('weekly keeps the weekday', () {
      final start = DateTime(2026, 9, 7, 6); // a Monday
      final next = nextOccurrence(start, ReminderRepeat.weekly, now);
      expect(next.weekday, DateTime.monday);
      expect(next, DateTime(2026, 10, 5, 6));
      expect(next.isAfter(now), isTrue);
    });

    test('monthly keeps the day of month, clamping to short months', () {
      expect(nextOccurrence(DateTime(2026, 8, 15, 8), ReminderRepeat.monthly, now), DateTime(2026, 10, 15, 8));
      // The 31st lands on the last day of a 30-day month, then returns to the 31st.
      final jan31 = DateTime(2026, 1, 31, 8);
      expect(nextOccurrence(jan31, ReminderRepeat.monthly, DateTime(2026, 2, 1)), DateTime(2026, 2, 28, 8));
      expect(nextOccurrence(jan31, ReminderRepeat.monthly, DateTime(2026, 3, 1)), DateTime(2026, 3, 31, 8));
      // December rolls into the next year.
      expect(nextOccurrence(DateTime(2026, 12, 10, 8), ReminderRepeat.monthly, DateTime(2026, 12, 11)), DateTime(2027, 1, 10, 8));
    });
  });

  group('ReminderActions', () {
    late AppDatabase db;
    late LocalReminderRepository repo;
    late FakeNotifications notifications;
    late ReminderActions actions;
    final now = DateTime(2026, 9, 30, 9, 0);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = LocalReminderRepository(db, SyncQueueRepository(db));
      notifications = FakeNotifications();
      actions = ReminderActions(repo, notifications, now: () => now);
    });

    tearDown(() => db.close());

    Reminder r({ReminderRepeat repeat = ReminderRepeat.none, DateTime? at}) => Reminder(
          id: '',
          title: 'Water the onions',
          scheduledFor: at ?? DateTime(2026, 10, 2, 7),
          category: ReminderCategory.irrigation,
          repeat: repeat,
        );

    test('creating saves the reminder and schedules one notification', () async {
      await actions.add(r());
      final saved = (await repo.watchReminders().first).single;
      expect(saved.title, 'Water the onions');
      expect(saved.category, ReminderCategory.irrigation);
      expect(notifications.scheduled, hasLength(1));
      expect(notifications.scheduled.single.id, notificationIdFor(saved.id));
      expect(notifications.scheduled.single.repeat, isNull);
    });

    test('repeat rules map to the matching notification repeat', () async {
      await actions.add(r(repeat: ReminderRepeat.daily));
      await actions.add(r(repeat: ReminderRepeat.weekly));
      await actions.add(r(repeat: ReminderRepeat.monthly));
      expect(notifications.scheduled.map((s) => s.repeat), [
        DateTimeComponents.time,
        DateTimeComponents.dayOfWeekAndTime,
        DateTimeComponents.dayOfMonthAndTime,
      ]);
    });

    test('a repeating reminder that starts in the past fires from its next slot', () async {
      await actions.add(r(repeat: ReminderRepeat.daily, at: DateTime(2026, 9, 1, 7)));
      expect(notifications.scheduled.single.at, DateTime(2026, 10, 1, 7));
    });

    test('completing a one-off moves it to completed and cancels the notification', () async {
      await actions.add(r());
      final saved = (await repo.watchReminders().first).single;
      await actions.complete(saved);

      final after = (await repo.watchReminders().first).single;
      expect(after.completed, isTrue);
      expect(notifications.cancelled, contains(notificationIdFor(saved.id)));
      // Not rescheduled after completion.
      expect(notifications.scheduled, hasLength(1));
    });

    test('completing a repeating reminder keeps it active and moves it forward', () async {
      await actions.add(r(repeat: ReminderRepeat.weekly, at: DateTime(2026, 9, 28, 7)));
      final saved = (await repo.watchReminders().first).single;
      await actions.complete(saved);

      final after = (await repo.watchReminders().first).single;
      expect(after.completed, isFalse);
      expect(after.scheduledFor, DateTime(2026, 10, 5, 7));
    });

    test('editing reschedules, deleting cancels', () async {
      await actions.add(r());
      final saved = (await repo.watchReminders().first).single;

      await actions.update(saved.copyWith(title: 'Water early', scheduledFor: DateTime(2026, 10, 3, 6)));
      expect((await repo.getReminder(saved.id))!.title, 'Water early');
      expect(notifications.scheduled.last.at, DateTime(2026, 10, 3, 6));

      await actions.delete(saved.id);
      expect(await repo.watchReminders().first, isEmpty);
      expect(notifications.cancelled.last, notificationIdFor(saved.id));
    });

    test('reopening a completed reminder schedules it again', () async {
      await actions.add(r());
      final saved = (await repo.watchReminders().first).single;
      await actions.complete(saved);
      await actions.reopen((await repo.getReminder(saved.id))!);
      expect((await repo.getReminder(saved.id))!.completed, isFalse);
      expect(notifications.scheduled, hasLength(2));
    });

    test('isDueOn matches the calendar day only', () {
      final reminder = r(at: DateTime(2026, 9, 30, 23, 59));
      expect(reminder.isDueOn(DateTime(2026, 9, 30)), isTrue);
      expect(reminder.isDueOn(DateTime(2026, 10, 1)), isFalse);
    });
  });
}
