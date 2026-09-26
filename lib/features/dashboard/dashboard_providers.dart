import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_providers.dart';
import '../auth/auth_providers.dart';
import '../crop/crop_providers.dart';
import '../crop/domain/season.dart';
import '../farm/domain/farm.dart';
import '../farm/farm_providers.dart';

const _dailyPlanReminderId = 900001;

/// V1 supports a single primary farm per farmer, so most of the app
/// (dashboard, tasks, logs) can key off "the farmer's farm" directly.
final primaryFarmProvider = Provider<Farm?>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;
  final farms = ref.watch(userFarmsProvider(user.id)).value ?? const [];
  return farms.isEmpty ? null : farms.first;
});

final primaryActiveSeasonProvider = StreamProvider<Season?>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  if (farm == null) return const Stream.empty();
  return ref.watch(seasonRepositoryProvider).watchActiveSeason(farm.id);
});

/// Schedules the recurring 8 AM "check today's farm plan" reminder
/// (§72) once an active season exists. Re-scheduling with the same id is
/// idempotent — the plugin replaces the prior schedule.
final ensureDailyPlanReminderProvider = FutureProvider<void>((ref) async {
  final season = ref.watch(primaryActiveSeasonProvider).value;
  if (season == null) return;
  final notifications = ref.watch(notificationServiceProvider);
  if (!ref.watch(dailyReminderEnabledProvider)) {
    await notifications.cancel(_dailyPlanReminderId);
    return;
  }
  await notifications.requestPermission();
  await notifications.scheduleDaily(
    id: _dailyPlanReminderId,
    title: 'KisanMitra 360',
    body: "Check today's farm plan",
    hour: 8,
    minute: 0,
  );
});
