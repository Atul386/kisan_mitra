import '../../../l10n/app_localizations.dart';
import '../domain/crop_activity.dart';

String activityLabel(AppLocalizations t, ActivityType type) => switch (type) {
      ActivityType.sowing => t.activitySowing,
      ActivityType.irrigation => t.activityIrrigation,
      ActivityType.fertilizer => t.activityFertilizer,
      ActivityType.spray => t.activitySpray,
      ActivityType.pestObservation => t.activityPestObservation,
      ActivityType.diseaseObservation => t.activityDiseaseObservation,
      ActivityType.labour => t.activityLabour,
      ActivityType.harvest => t.activityHarvest,
      ActivityType.sale => t.activitySale,
      ActivityType.other => t.activityOther,
    };
