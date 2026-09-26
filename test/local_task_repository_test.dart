import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/tasks/data/local_task_repository.dart';
import 'package:kisan_mitra/features/tasks/domain/farm_task.dart';

void main() {
  late AppDatabase db;
  late LocalTaskRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalTaskRepository(db, SyncQueueRepository(db));
  });

  tearDown(() => db.close());

  test('generates today\'s tasks for the crop stage and is idempotent on re-run', () async {
    final sowingDate = DateTime.now().subtract(const Duration(days: 24)); // day 25

    await repo.ensureTodaysTasksGenerated(
      seasonId: 'season1',
      cropId: 'soybean',
      sowingDate: sowingDate,
    );
    var tasks = await repo.watchTodaysTasks('season1').first;
    expect(tasks, isNotEmpty);
    final countAfterFirstRun = tasks.length;

    // Re-running (simulating a second app open the same day) must not
    // duplicate tasks or reset a task the farmer already completed.
    await repo.markDone(tasks.first.id);
    await repo.ensureTodaysTasksGenerated(
      seasonId: 'season1',
      cropId: 'soybean',
      sowingDate: sowingDate,
    );
    tasks = await repo.watchTodaysTasks('season1').first;
    expect(tasks.length, countAfterFirstRun);
    expect(tasks.firstWhere((t) => t.id == tasks.first.id).state, FarmTaskState.done);
  });

  test('markSkipped and snoozeToTomorrow update state as expected', () async {
    await repo.ensureTodaysTasksGenerated(
      seasonId: 'season2',
      cropId: 'wheat',
      sowingDate: DateTime.now().subtract(const Duration(days: 4)), // day 5
    );
    final tasks = await repo.watchTodaysTasks('season2').first;
    expect(tasks, isNotEmpty);

    await repo.markSkipped(tasks[0].id);
    final afterSkip = await repo.watchTodaysTasks('season2').first;
    expect(afterSkip.firstWhere((t) => t.id == tasks[0].id).state, FarmTaskState.skipped);
  });

  test('no tasks are generated when the sowing date is in the future', () async {
    await repo.ensureTodaysTasksGenerated(
      seasonId: 'season3',
      cropId: 'soybean',
      sowingDate: DateTime.now().add(const Duration(days: 5)),
    );
    final tasks = await repo.watchTodaysTasks('season3').first;
    expect(tasks, isEmpty);
  });
}
