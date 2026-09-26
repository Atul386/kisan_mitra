import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../domain/farm_task.dart';
import '../domain/task_repository.dart';
import 'task_rule_engine.dart';

const _table = 'tasks';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class LocalTaskRepository implements TaskRepository {
  LocalTaskRepository(
    this._db,
    this._syncQueue, {
    TaskRuleEngine ruleEngine = const TaskRuleEngine(),
    NotificationService? notificationService,
  })  : _ruleEngine = ruleEngine,
        _notifications = notificationService;

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final TaskRuleEngine _ruleEngine;
  final NotificationService? _notifications;

  @override
  Future<void> ensureTodaysTasksGenerated({
    required String seasonId,
    required String cropId,
    required DateTime sowingDate,
  }) async {
    final today = _dateOnly(DateTime.now());
    final day = today.difference(_dateOnly(sowingDate)).inDays + 1;
    if (day < 1) return; // sowing date is in the future

    final templates = _ruleEngine.templatesForDay(cropId: cropId, day: day);
    if (templates.isEmpty) return;

    final now = DateTime.now();
    for (final template in templates) {
      final id = '$seasonId::${template.id}::${today.toIso8601String().split('T').first}';
      final inserted = await _db.into(_db.farmTasks).insertReturningOrNull(
            FarmTasksCompanion.insert(
              id: id,
              seasonId: seasonId,
              title: template.titleFor('en'),
              dueDate: today,
              createdAt: now,
              updatedAt: now,
            ),
            mode: InsertMode.insertOrIgnore,
          );
      if (inserted != null) {
        await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
      }
    }
  }

  @override
  Stream<List<FarmTaskEntity>> watchTodaysTasks(String seasonId) {
    final today = _dateOnly(DateTime.now());
    final query = _db.select(_db.farmTasks)
      ..where((t) =>
          t.seasonId.equals(seasonId) &
          t.deletedAt.isNull() &
          (t.dueDate.equals(today) | (t.state.equals('snoozed') & t.dueDate.isSmallerOrEqualValue(today))))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> markDone(String taskId) => _setState(taskId, FarmTaskState.done);

  @override
  Future<void> markSkipped(String taskId) => _setState(taskId, FarmTaskState.skipped);

  @override
  Future<void> snoozeToTomorrow(String taskId) async {
    final tomorrow = _dateOnly(DateTime.now()).add(const Duration(days: 1));
    final row = await (_db.select(_db.farmTasks)..where((t) => t.id.equals(taskId))).getSingleOrNull();

    await (_db.update(_db.farmTasks)..where((t) => t.id.equals(taskId))).write(
      FarmTasksCompanion(
        state: const Value('snoozed'),
        dueDate: Value(tomorrow),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );

    final notifications = _notifications;
    if (notifications != null && row != null) {
      await notifications.requestPermission();
      await notifications.scheduleOneOff(
        id: notificationIdFor(taskId),
        title: 'KisanMitra 360',
        body: row.title,
        at: tomorrow.add(const Duration(hours: 8)),
      );
    }
    await _syncQueue.enqueue(table: _table, entityId: taskId, operation: 'update');
  }

  Future<void> _setState(String taskId, FarmTaskState state) async {
    await (_db.update(_db.farmTasks)..where((t) => t.id.equals(taskId))).write(
      FarmTasksCompanion(
        state: Value(state.name),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: taskId, operation: 'update');
  }

  FarmTaskEntity _toDomain(FarmTask row) => FarmTaskEntity(
        id: row.id,
        seasonId: row.seasonId,
        title: row.title,
        dueDate: row.dueDate,
        state: FarmTaskState.values.firstWhere(
          (s) => s.name == row.state,
          orElse: () => FarmTaskState.pending,
        ),
      );
}
