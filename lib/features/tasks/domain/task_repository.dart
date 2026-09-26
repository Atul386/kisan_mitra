import 'farm_task.dart';

abstract class TaskRepository {
  /// Runs the rule engine for [seasonId] and persists any tasks that don't
  /// already exist for today (idempotent — safe to call on every app open).
  Future<void> ensureTodaysTasksGenerated({
    required String seasonId,
    required String cropId,
    required DateTime sowingDate,
  });

  /// Tasks due today, plus any snoozed tasks whose due date has arrived.
  Stream<List<FarmTaskEntity>> watchTodaysTasks(String seasonId);

  Future<void> markDone(String taskId);
  Future<void> markSkipped(String taskId);

  /// "Remind Me" (§16): pushes the task to tomorrow and marks it snoozed.
  Future<void> snoozeToTomorrow(String taskId);
}
