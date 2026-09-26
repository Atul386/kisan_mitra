import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../domain/checkin_repository.dart';
import '../domain/daily_checkin.dart' as domain;

const _table = 'daily_checkins';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String _idFor(String farmId, DateTime date) {
  final d = _dateOnly(date);
  return '$farmId::${d.toIso8601String().split('T').first}';
}

class LocalCheckinRepository implements CheckinRepository {
  LocalCheckinRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<domain.DailyCheckin?> watchTodayCheckin(String farmId) {
    final id = _idFor(farmId, DateTime.now());
    return (_db.select(_db.dailyCheckins)..where((c) => c.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toDomain(row));
  }

  @override
  Future<void> saveCheckin(domain.DailyCheckin checkin) async {
    final now = DateTime.now();
    final id = _idFor(checkin.farmId, checkin.date);
    await _db.into(_db.dailyCheckins).insertOnConflictUpdate(
          DailyCheckinsCompanion.insert(
            id: id,
            farmId: checkin.farmId,
            seasonId: Value(checkin.seasonId),
            date: _dateOnly(checkin.date),
            healthStatus: checkin.healthStatus.name,
            concern: Value(checkin.concern?.name),
            note: Value(checkin.note),
            photoPath: Value(checkin.photoPath),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'update');
  }

  domain.DailyCheckin _toDomain(DailyCheckin row) => domain.DailyCheckin(
        id: row.id,
        farmId: row.farmId,
        seasonId: row.seasonId,
        date: row.date,
        healthStatus: domain.CheckinHealth.values.firstWhere(
          (h) => h.name == row.healthStatus,
          orElse: () => domain.CheckinHealth.good,
        ),
        concern: row.concern == null
            ? null
            : domain.CheckinConcern.values.firstWhere(
                (c) => c.name == row.concern,
                orElse: () => domain.CheckinConcern.other,
              ),
        note: row.note,
        photoPath: row.photoPath,
      );
}
