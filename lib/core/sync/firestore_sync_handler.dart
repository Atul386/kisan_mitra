import '../database/app_database.dart';
import 'cloud_store.dart';
import 'firestore_sync_specs.dart';
import 'sync_handler.dart';

/// Pushes one queued change to the cloud under `users/{uid}/...`.
///
/// Every operation (create, update, delete) is the same idempotent `set` of
/// the row's current state — deletes are tombstones — so replaying a queue
/// item after a crash or timeout is always safe.
class FirestoreSyncHandler implements SyncHandler {
  FirestoreSyncHandler({required this.spec, required this.db, required this.store, required this.uid});

  final SyncTableSpec spec;
  final AppDatabase db;
  final CloudStore store;
  final String uid;

  @override
  Future<void> push({required String entityId, required String operation}) async {
    final json = await spec.load(db, entityId);
    if (json == null) return; // row was wiped (e.g. account reset) — nothing to send

    final payload = {...json}..remove('syncStatus'); // local-only bookkeeping
    await store.set(spec.docPath(uid, json), payload);

    // Only mark synced if the row wasn't edited while we were pushing; a newer
    // edit has its own queue item and will push again.
    final updatedAtSeconds = (json['updatedAt'] as int) ~/ 1000;
    await db.customStatement(
      "UPDATE ${spec.sqlTable} SET sync_status = 'synced' WHERE id = ? AND updated_at = ?",
      [entityId, updatedAtSeconds],
    );
  }
}
