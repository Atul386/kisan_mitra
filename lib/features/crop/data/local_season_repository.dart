import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/season.dart' as domain;
import '../domain/season_repository.dart';

const _table = 'seasons';

class LocalSeasonRepository implements SeasonRepository {
  LocalSeasonRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<domain.Season?> watchActiveSeason(String farmId) {
    final query = _db.select(_db.seasons)
      ..where((s) => s.farmId.equals(farmId) & s.status.equals('active') & s.deletedAt.isNull())
      ..orderBy([(s) => OrderingTerm.desc(s.sowingDate)])
      ..limit(1);
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Stream<List<domain.Season>> watchSeasons(String farmId) {
    final query = _db.select(_db.seasons)
      ..where((s) => s.farmId.equals(farmId) & s.deletedAt.isNull())
      ..orderBy([(s) => OrderingTerm.desc(s.sowingDate)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<domain.Season?> watchSeason(String seasonId) {
    final query = _db.select(_db.seasons)..where((s) => s.id.equals(seasonId) & s.deletedAt.isNull());
    return query.watchSingleOrNull().map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Future<void> addSeason(domain.Season season) async {
    final now = DateTime.now();
    final id = season.id.isEmpty ? newId() : season.id;
    await _db.into(_db.seasons).insert(
          SeasonsCompanion.insert(
            id: id,
            farmId: season.farmId,
            cropId: season.cropId,
            cropName: season.cropName,
            sowingDate: season.sowingDate,
            variety: Value(season.variety),
            area: Value(season.area),
            areaUnit: Value(season.areaUnit),
            seasonName: Value(season.seasonName),
            status: Value(season.status),
            expectedHarvestDate: Value(season.expectedHarvestDate),
            notes: Value(season.notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> updateStatus(String seasonId, String status) async {
    await (_db.update(_db.seasons)..where((s) => s.id.equals(seasonId))).write(
      SeasonsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: seasonId, operation: 'update');
  }

  @override
  Future<void> updateDetails(
    String seasonId, {
    String? variety,
    double? area,
    DateTime? expectedHarvestDate,
    String? notes,
  }) async {
    await (_db.update(_db.seasons)..where((s) => s.id.equals(seasonId))).write(
      SeasonsCompanion(
        variety: Value(variety),
        area: Value(area),
        expectedHarvestDate: Value(expectedHarvestDate),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: seasonId, operation: 'update');
  }

  @override
  Future<void> deleteSeason(String seasonId) async {
    await (_db.update(_db.seasons)..where((s) => s.id.equals(seasonId))).write(
      SeasonsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: seasonId, operation: 'delete');
  }

  domain.Season _toDomain(Season row) => domain.Season(
        id: row.id,
        farmId: row.farmId,
        cropId: row.cropId,
        cropName: row.cropName,
        sowingDate: row.sowingDate,
        variety: row.variety,
        area: row.area,
        areaUnit: row.areaUnit,
        seasonName: row.seasonName,
        status: row.status,
        expectedHarvestDate: row.expectedHarvestDate,
        notes: row.notes,
      );
}
