import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// The outbox from blueprint §8: every local mutation enqueues one row
/// here. Draining it is [SyncEngine]'s job — this class only owns the
/// queue itself (enqueue, batch read, remove, mark failed).
class SyncQueueRepository {
  SyncQueueRepository(this._db);

  final AppDatabase _db;

  Future<void> enqueue({required String table, required String entityId, required String operation}) async {
    await _db
        .into(_db.syncQueueItems)
        .insert(SyncQueueItemsCompanion.insert(entityTable: table, entityId: entityId, operation: operation));
  }

  Future<List<SyncQueueItem>> nextBatch({int limit = 20}) {
    return (_db.select(_db.syncQueueItems)
          ..orderBy([(t) => OrderingTerm.asc(t.queuedAt)])
          ..limit(limit))
        .get();
  }

  Future<void> remove(int queueId) {
    return (_db.delete(_db.syncQueueItems)..where((t) => t.queueId.equals(queueId))).go();
  }

  Future<void> recordFailure(int queueId, String error) {
    // A raw statement so retry_count can reference its own current value —
    // drift's typed update companion can't express `retry_count + 1`.
    return _db.customStatement(
      'UPDATE sync_queue_items SET retry_count = retry_count + 1, last_error = ? WHERE queue_id = ?',
      [error, queueId],
    );
  }

  Stream<int> watchPendingCount() {
    final countExp = _db.syncQueueItems.queueId.count();
    final query = _db.selectOnly(_db.syncQueueItems)..addColumns([countExp]);
    return query.watchSingle().map((row) => row.read(countExp) ?? 0);
  }
}
