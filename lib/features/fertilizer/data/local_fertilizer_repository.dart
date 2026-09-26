import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/fertilizer_log.dart' as domain;
import '../domain/fertilizer_repository.dart';

const _table = 'fertilizer_logs';

class LocalFertilizerRepository implements FertilizerRepository {
  LocalFertilizerRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.FertilizerLogEntry>> watchLogs({required String farmId, String? seasonId}) {
    final query = _db.select(_db.fertilizerLogs)
      ..where((e) {
        var predicate = e.farmId.equals(farmId) & e.deletedAt.isNull();
        if (seasonId != null) predicate = predicate & e.seasonId.equals(seasonId);
        return predicate;
      })
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addLog(domain.FertilizerLogEntry entry) async {
    final now = DateTime.now();
    final id = entry.id.isEmpty ? newId() : entry.id;
    await _db.into(_db.fertilizerLogs).insert(
          FertilizerLogsCompanion.insert(
            id: id,
            farmId: entry.farmId,
            seasonId: Value(entry.seasonId),
            date: entry.date,
            product: entry.product,
            quantity: Value(entry.quantity),
            unit: Value(entry.unit),
            cost: Value(entry.cost),
            notes: Value(entry.notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  domain.FertilizerLogEntry _toDomain(FertilizerLog row) => domain.FertilizerLogEntry(
        id: row.id,
        farmId: row.farmId,
        seasonId: row.seasonId,
        date: row.date,
        product: row.product,
        quantity: row.quantity,
        unit: row.unit,
        cost: row.cost,
        notes: row.notes,
      );
}
