import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'firestore_sync_specs.dart';
import 'sync_queue_repository.dart';

/// Makes sure every unsynced row has a queue entry. Needed because:
///  * the engine drops a queue item after repeated failures, and
///  * a guest's data created before any account existed must still upload
///    once they sign in.
/// Run once after sign-in / at startup; it never touches already-synced rows.
/// Returns how many queue entries were added.
Future<int> requeueUnsynced(AppDatabase db, SyncQueueRepository queue) async {
  var added = 0;
  for (final spec in kSyncSpecs) {
    final unsynced = await db
        .customSelect(
          "SELECT id FROM ${spec.sqlTable} WHERE sync_status != 'synced' "
          'AND id NOT IN (SELECT entity_id FROM sync_queue_items WHERE entity_table = ?)',
          variables: [Variable<String>(spec.queueName)],
        )
        .get();
    for (final row in unsynced) {
      await queue.enqueue(table: spec.queueName, entityId: row.read<String>('id'), operation: 'update');
      added++;
    }
  }
  return added;
}
