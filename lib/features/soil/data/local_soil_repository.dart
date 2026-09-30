import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/soil_report.dart' as domain;
import '../domain/soil_repository.dart';

const _table = 'soil_reports';

class LocalSoilRepository implements SoilRepository {
  LocalSoilRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.SoilReport>> watchReports(String farmId) {
    final query = _db.select(_db.soilReports)
      ..where((r) => r.farmId.equals(farmId) & r.deletedAt.isNull())
      ..orderBy([(r) => OrderingTerm.desc(r.date), (r) => OrderingTerm.desc(r.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addReport(domain.SoilReport report) async {
    final now = DateTime.now();
    final id = report.id.isEmpty ? newId() : report.id;
    await _db.into(_db.soilReports).insert(
          SoilReportsCompanion.insert(
            id: id,
            farmId: report.farmId,
            date: report.date,
            ph: Value(report.ph),
            nitrogen: Value(report.nitrogen),
            phosphorus: Value(report.phosphorus),
            potassium: Value(report.potassium),
            organicCarbon: Value(report.organicCarbon),
            otherNutrients: Value(report.otherNutrients),
            documentId: Value(report.documentId),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> deleteReport(String id) async {
    await (_db.update(_db.soilReports)..where((r) => r.id.equals(id))).write(
      SoilReportsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'delete');
  }

  domain.SoilReport _toDomain(SoilReport row) => domain.SoilReport(
        id: row.id,
        farmId: row.farmId,
        date: row.date,
        ph: row.ph,
        nitrogen: row.nitrogen,
        phosphorus: row.phosphorus,
        potassium: row.potassium,
        organicCarbon: row.organicCarbon,
        otherNutrients: row.otherNutrients,
        documentId: row.documentId,
      );
}
