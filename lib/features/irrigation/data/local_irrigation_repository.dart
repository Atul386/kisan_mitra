import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/irrigation_log.dart' as domain;
import '../domain/irrigation_repository.dart';

const _table = 'irrigation_logs';

class LocalIrrigationRepository implements IrrigationRepository {
  LocalIrrigationRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.IrrigationLogEntry>> watchLogs({required String farmId, String? seasonId}) {
    final query = _db.select(_db.irrigationLogs)
      ..where((e) {
        var predicate = e.farmId.equals(farmId) & e.deletedAt.isNull();
        if (seasonId != null) predicate = predicate & e.seasonId.equals(seasonId);
        return predicate;
      })
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addLog(domain.IrrigationLogEntry entry) async {
    final now = DateTime.now();
    final id = entry.id.isEmpty ? newId() : entry.id;
    await _db.into(_db.irrigationLogs).insert(
          IrrigationLogsCompanion.insert(
            id: id,
            farmId: entry.farmId,
            seasonId: Value(entry.seasonId),
            date: entry.date,
            durationMinutes: Value(entry.durationMinutes),
            method: Value(entry.method),
            notes: Value(entry.notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  domain.IrrigationLogEntry _toDomain(IrrigationLog row) => domain.IrrigationLogEntry(
        id: row.id,
        farmId: row.farmId,
        seasonId: row.seasonId,
        date: row.date,
        durationMinutes: row.durationMinutes,
        method: row.method,
        notes: row.notes,
      );
}
