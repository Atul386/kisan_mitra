import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/reminder.dart' as domain;
import '../domain/reminder_repository.dart';

const _table = 'local_reminders';

class LocalReminderRepository implements ReminderRepository {
  LocalReminderRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.Reminder>> watchReminders() {
    final query = _db.select(_db.localReminders)
      ..where((r) => r.deletedAt.isNull())
      ..orderBy([(r) => OrderingTerm.asc(r.scheduledFor)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<domain.Reminder?> getReminder(String id) async {
    final row = await (_db.select(_db.localReminders)..where((r) => r.id.equals(id) & r.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> addReminder(domain.Reminder reminder) async {
    final now = DateTime.now();
    final id = reminder.id.isEmpty ? newId() : reminder.id;
    await _db.into(_db.localReminders).insert(
          LocalRemindersCompanion.insert(
            id: id,
            title: reminder.title,
            body: Value(reminder.body),
            scheduledFor: reminder.scheduledFor,
            category: Value(reminder.category.name),
            repeatRule: Value(reminder.repeat.name),
            completed: Value(reminder.completed),
            cropId: Value(reminder.cropId),
            notificationEnabled: Value(reminder.notificationEnabled),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> updateReminder(domain.Reminder reminder) async {
    await (_db.update(_db.localReminders)..where((r) => r.id.equals(reminder.id))).write(
      LocalRemindersCompanion(
        title: Value(reminder.title),
        body: Value(reminder.body),
        scheduledFor: Value(reminder.scheduledFor),
        category: Value(reminder.category.name),
        repeatRule: Value(reminder.repeat.name),
        completed: Value(reminder.completed),
        cropId: Value(reminder.cropId),
        notificationEnabled: Value(reminder.notificationEnabled),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: reminder.id, operation: 'update');
  }

  @override
  Future<void> deleteReminder(String id) async {
    await (_db.update(_db.localReminders)..where((r) => r.id.equals(id))).write(
      LocalRemindersCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'delete');
  }

  domain.Reminder _toDomain(LocalReminder row) => domain.Reminder(
        id: row.id,
        title: row.title,
        body: row.body,
        scheduledFor: row.scheduledFor,
        category: domain.ReminderCategory.fromName(row.category),
        repeat: domain.ReminderRepeat.fromName(row.repeatRule),
        completed: row.completed,
        cropId: row.cropId,
        notificationEnabled: row.notificationEnabled,
      );
}
