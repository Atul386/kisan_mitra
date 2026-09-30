import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/notifications/notification_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/utils/today_provider.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_task_repository.dart';
import 'domain/farm_task.dart';
import 'domain/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return LocalTaskRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncQueueRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
});

/// Runs task generation once per (re)watch of the active season — cheap
/// and idempotent (insertOrIgnore), so it's safe to watch from any screen
/// that needs today's tasks to already exist.
final ensureTodaysTasksProvider = FutureProvider<void>((ref) async {
  ref.watch(todayProvider);
  final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
  if (season == null) return;
  await ref.watch(taskRepositoryProvider).ensureTodaysTasksGenerated(
        seasonId: season.id,
        cropId: season.cropId,
        sowingDate: season.sowingDate,
      );
});

final todaysTasksProvider = StreamProvider<List<FarmTaskEntity>>((ref) {
  ref.watch(ensureTodaysTasksProvider);
  ref.watch(todayProvider);
  final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
  if (season == null) return const Stream.empty();
  return ref.watch(taskRepositoryProvider).watchTodaysTasks(season.id);
});

final pendingTaskCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(todaysTasksProvider).valueOrNull ?? const [];
  final today = ref.watch(todayProvider);
  return tasks.where((t) => t.isActionableOn(today)).length;
});
