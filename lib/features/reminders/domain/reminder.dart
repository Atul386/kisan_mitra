/// What a reminder is about. Stored by [name].
enum ReminderCategory {
  irrigation('💧'),
  fertilizer('🧪'),
  spray('🧴'),
  inspection('🔍'),
  harvest('🌾'),
  labour('👷'),
  equipment('🔧'),
  governmentDeadline('🏛️'),
  insuranceDeadline('🛡️'),
  custom('⏰');

  const ReminderCategory(this.emoji);
  final String emoji;

  static ReminderCategory fromName(String name) =>
      ReminderCategory.values.firstWhere((c) => c.name == name, orElse: () => ReminderCategory.custom);
}

enum ReminderRepeat {
  none,
  daily,
  weekly,
  monthly;

  static ReminderRepeat fromName(String name) =>
      ReminderRepeat.values.firstWhere((r) => r.name == name, orElse: () => ReminderRepeat.none);
}

class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.scheduledFor,
    this.body,
    this.category = ReminderCategory.custom,
    this.repeat = ReminderRepeat.none,
    this.completed = false,
    this.cropId,
    this.notificationEnabled = true,
  });

  final String id;
  final String title;
  final String? body;

  /// When it next fires. For repeating reminders this moves forward each time.
  final DateTime scheduledFor;
  final ReminderCategory category;
  final ReminderRepeat repeat;
  final bool completed;

  /// Crop (season id) this reminder is about, if any.
  final String? cropId;

  /// When false it is only listed in the app and never sent as a notification.
  final bool notificationEnabled;

  bool isDueOn(DateTime day) =>
      scheduledFor.year == day.year && scheduledFor.month == day.month && scheduledFor.day == day.day;

  Reminder copyWith({
    String? title,
    String? body,
    DateTime? scheduledFor,
    ReminderCategory? category,
    ReminderRepeat? repeat,
    bool? completed,
    String? cropId,
    bool clearCrop = false,
    bool? notificationEnabled,
  }) => Reminder(
    id: id,
    title: title ?? this.title,
    body: body ?? this.body,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    category: category ?? this.category,
    repeat: repeat ?? this.repeat,
    completed: completed ?? this.completed,
    cropId: clearCrop ? null : (cropId ?? this.cropId),
    notificationEnabled: notificationEnabled ?? this.notificationEnabled,
  );
}

/// The first occurrence of a repeating reminder strictly after [now],
/// keeping the time of day. Monthly reminders on the 29th–31st land on the
/// last day of shorter months instead of spilling into the next month.
/// Returns [from] unchanged for a non-repeating reminder.
DateTime nextOccurrence(DateTime from, ReminderRepeat repeat, DateTime now) {
  if (repeat == ReminderRepeat.none) return from;
  var next = from;
  var guard = 0;
  while (!next.isAfter(now) && guard++ < 5000) {
    next = switch (repeat) {
      ReminderRepeat.daily => DateTime(next.year, next.month, next.day + 1, from.hour, from.minute),
      ReminderRepeat.weekly => DateTime(next.year, next.month, next.day + 7, from.hour, from.minute),
      ReminderRepeat.monthly => _addMonth(next, from.day, from.hour, from.minute),
      ReminderRepeat.none => next,
    };
  }
  return next;
}

DateTime _addMonth(DateTime d, int wantedDay, int hour, int minute) {
  final month = d.month + 1;
  final year = d.year + (month > 12 ? 1 : 0);
  final m = month > 12 ? 1 : month;
  final lastDay = DateTime(year, m + 1, 0).day;
  return DateTime(year, m, wantedDay > lastDay ? lastDay : wantedDay, hour, minute);
}
