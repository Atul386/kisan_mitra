import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/mandi_price.dart' as domain;
import '../domain/mandi_repository.dart';

const _table = 'mandi_price_logs';

class LocalMandiRepository implements MandiRepository {
  LocalMandiRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.MandiPriceEntry>> watchPrices({required String farmId, String? commodity}) {
    final query = _db.select(_db.mandiPriceLogs)
      ..where((e) {
        var predicate = e.farmId.equals(farmId) & e.deletedAt.isNull();
        if (commodity != null) predicate = predicate & e.commodity.equals(commodity);
        return predicate;
      })
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addPrice(domain.MandiPriceEntry entry) async {
    final now = DateTime.now();
    final id = entry.id.isEmpty ? newId() : entry.id;
    await _db.into(_db.mandiPriceLogs).insert(
          MandiPriceLogsCompanion.insert(
            id: id,
            farmId: entry.farmId,
            commodity: entry.commodity,
            market: Value(entry.market),
            price: entry.price,
            unit: Value(entry.unit),
            date: entry.date,
            notes: Value(entry.notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  domain.MandiPriceEntry _toDomain(MandiPriceLog row) => domain.MandiPriceEntry(
        id: row.id,
        farmId: row.farmId,
        commodity: row.commodity,
        market: row.market,
        price: row.price,
        unit: row.unit,
        date: row.date,
        notes: row.notes,
      );
}
