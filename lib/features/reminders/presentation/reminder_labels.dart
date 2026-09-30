import '../../../l10n/app_localizations.dart';
import '../domain/reminder.dart';

String reminderCategoryLabel(AppLocalizations t, ReminderCategory c) => switch (c) {
      ReminderCategory.irrigation => t.reminderCatIrrigation,
      ReminderCategory.fertilizer => t.reminderCatFertilizer,
      ReminderCategory.spray => t.reminderCatSpray,
      ReminderCategory.inspection => t.reminderCatInspection,
      ReminderCategory.harvest => t.reminderCatHarvest,
      ReminderCategory.labour => t.reminderCatLabour,
      ReminderCategory.equipment => t.reminderCatEquipment,
      ReminderCategory.governmentDeadline => t.reminderCatGovernmentDeadline,
      ReminderCategory.insuranceDeadline => t.reminderCatInsuranceDeadline,
      ReminderCategory.custom => t.reminderCatCustom,
    };

String reminderRepeatLabel(AppLocalizations t, ReminderRepeat r) => switch (r) {
      ReminderRepeat.none => t.repeatNone,
      ReminderRepeat.daily => t.repeatDaily,
      ReminderRepeat.weekly => t.repeatWeekly,
      ReminderRepeat.monthly => t.repeatMonthly,
    };
