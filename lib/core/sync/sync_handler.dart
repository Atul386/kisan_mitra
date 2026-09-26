/// One implementation per syncable table (blueprint §49: `FarmRepository`
/// today is `LocalFarmRepository`; add a `FirebaseFarmRepository` later
/// and a matching `FarmSyncHandler` that pushes queued rows to it).
///
/// [push] is responsible for the whole round trip for one queue item:
/// send the record to the backend, and on success update that record's
/// own `syncStatus` column back to `synced` (the sync engine only owns
/// the queue, not the source tables, since those differ per handler).
abstract class SyncHandler {
  Future<void> push({required String entityId, required String operation});
}
