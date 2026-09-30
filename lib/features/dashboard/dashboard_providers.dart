import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_providers.dart';
import '../../core/utils/shared_preferences_provider.dart';
import '../auth/auth_providers.dart';
import '../crop/crop_providers.dart';
import '../crop/domain/season.dart';
import '../farm/domain/farm.dart';
import '../farm/farm_providers.dart';

const _dailyPlanReminderId = 900001;

const _selectedFarmKey = 'selected_farm_id';

/// Which farm the farmer is currently working on (per device). Null until
/// they pick one; [primaryFarmProvider] then falls back to the first farm.
class SelectedFarmId extends Notifier<String?> {
  @override
  String? build() => ref.read(sharedPreferencesProvider).getString(_selectedFarmKey);

  Future<void> select(String farmId) async {
    state = farmId;
    await ref.read(sharedPreferencesProvider).setString(_selectedFarmKey, farmId);
  }
}

final selectedFarmIdProvider = NotifierProvider<SelectedFarmId, String?>(SelectedFarmId.new);

/// The farm the whole app (dashboard, tasks, logs, weather) works on: the
/// one the farmer selected on the Farm tab, or the first farm. A farmer
/// can own several farms; everything else keys off this one.
final primaryFarmProvider = Provider<Farm?>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return null;
  final farms = ref.watch(userFarmsProvider(user.id)).valueOrNull ?? const [];
  if (farms.isEmpty) return null;
  final selected = ref.watch(selectedFarmIdProvider);
  for (final farm in farms) {
    if (farm.id == selected) return farm;
  }
  return farms.first;
});

/// True while the signed-in farmer's farm list hasn't loaded yet, so the
/// router can wait rather than mistake it for "no farm".
final primaryFarmLoadingProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return false;
  return ref.watch(userFarmsProvider(user.id)).isLoading;
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
  final notifications = ref.watch(notificationServiceProvider);
  final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
  if (!ref.watch(dailyReminderEnabledProvider)) {
    await notifications.cancel(_dailyPlanReminderId);
    return;
  }
  if (season == null) return;
  await notifications.requestPermission();
  await notifications.scheduleDaily(
    id: _dailyPlanReminderId,
    title: 'KisanMitra 360',
    body: "Check today's farm plan",
    hour: 8,
    minute: 0,
  );
});
