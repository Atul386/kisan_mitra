import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/crop_activity.dart' as domain;
import '../domain/crop_activity_repository.dart';

const _table = 'crop_activities';

class LocalCropActivityRepository implements CropActivityRepository {
  LocalCropActivityRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.CropActivity>> watchActivities(String seasonId) {
    final query = _db.select(_db.cropActivities)
      ..where((a) => a.seasonId.equals(seasonId) & a.deletedAt.isNull())
      ..orderBy([(a) => OrderingTerm.desc(a.date), (a) => OrderingTerm.desc(a.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<domain.CropActivity?> getActivity(String id) async {
    final row = await (_db.select(_db.cropActivities)..where((a) => a.id.equals(id) & a.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> addActivity(domain.CropActivity activity) async {
    final now = DateTime.now();
    final id = activity.id.isEmpty ? newId() : activity.id;
    await _db.into(_db.cropActivities).insert(
          CropActivitiesCompanion.insert(
            id: id,
            farmId: activity.farmId,
            seasonId: activity.seasonId,
            type: activity.type.name,
            date: activity.date,
            notes: Value(activity.notes),
            photoPath: Value(activity.photoPath),
            cost: Value(activity.cost),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> updateActivity(domain.CropActivity activity) async {
    await (_db.update(_db.cropActivities)..where((a) => a.id.equals(activity.id))).write(
      CropActivitiesCompanion(
        type: Value(activity.type.name),
        date: Value(activity.date),
        notes: Value(activity.notes),
        photoPath: Value(activity.photoPath),
        cost: Value(activity.cost),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: activity.id, operation: 'update');
  }

  @override
  Future<void> deleteActivity(String id) async {
    await (_db.update(_db.cropActivities)..where((a) => a.id.equals(id))).write(
      CropActivitiesCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'delete');
  }

  domain.CropActivity _toDomain(CropActivity row) => domain.CropActivity(
        id: row.id,
        farmId: row.farmId,
        seasonId: row.seasonId,
        type: domain.ActivityType.fromName(row.type),
        date: row.date,
        notes: row.notes,
        photoPath: row.photoPath,
        cost: row.cost,
      );
}
