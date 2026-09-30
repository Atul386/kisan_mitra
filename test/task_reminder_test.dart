import 'package:drift/drift.dart' hide isNull;
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

  DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  test('a reminded task is actionable again once due, without a duplicate copy', () async {
    final sowingDate = DateTime.now().subtract(const Duration(days: 24)); // day 25
    await repo.ensureTodaysTasksGenerated(seasonId: 's1', cropId: 'soybean', sowingDate: sowingDate);
    final original = await repo.watchTodaysTasks('s1').first;
    final task = original.first;

    await repo.snoozeToTomorrow(task.id);

    // Snoozed for tomorrow: not actionable today, and gone from today's list.
    final afterSnooze = await repo.watchTodaysTasks('s1').first;
    expect(afterSnooze.where((t) => t.id == task.id), isEmpty);

    // Simulate the next day arriving: its due date is now "today".
    await (db.update(db.farmTasks)..where((t) => t.id.equals(task.id)))
        .write(FarmTasksCompanion(dueDate: Value(today())));
    await repo.ensureTodaysTasksGenerated(seasonId: 's1', cropId: 'soybean', sowingDate: sowingDate);

    final nextDay = await repo.watchTodaysTasks('s1').first;
    final reminded = nextDay.where((t) => t.id == task.id).single;
    expect(reminded.state, FarmTaskState.snoozed);
    expect(reminded.isActionableOn(today()), isTrue);
    expect(nextDay.length, original.length, reason: 'no second copy of the reminded task');

    await repo.markDone(task.id);
    final done = (await repo.watchTodaysTasks('s1').first).singleWhere((t) => t.id == task.id);
    expect(done.state, FarmTaskState.done);
    expect(done.isActionableOn(today()), isFalse);
  });

  test('isActionableOn', () {
    final day = DateTime(2026, 6, 10);
    FarmTaskEntity task(FarmTaskState state, DateTime due) =>
        FarmTaskEntity(id: 'x', seasonId: 's', title: 't', dueDate: due, state: state);

    expect(task(FarmTaskState.pending, day).isActionableOn(day), isTrue);
    expect(task(FarmTaskState.snoozed, day).isActionableOn(day), isTrue);
    expect(task(FarmTaskState.snoozed, day.subtract(const Duration(days: 2))).isActionableOn(day), isTrue);
    expect(task(FarmTaskState.snoozed, day.add(const Duration(days: 1))).isActionableOn(day), isFalse);
    expect(task(FarmTaskState.done, day).isActionableOn(day), isFalse);
    expect(task(FarmTaskState.skipped, day).isActionableOn(day), isFalse);
  });
}
