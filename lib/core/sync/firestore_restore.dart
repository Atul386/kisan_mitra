import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../database/tables.dart';
import 'cloud_store.dart';
import 'firestore_sync_specs.dart';

/// Pulls a signed-in farmer's data from Firestore into the local database,
/// so a new phone (or a reinstall) gets their farms, crops, diary, expenses
/// and so on back after login.
///
/// Conflict rule (last writer wins, never lose unsent work):
///  * no local copy            -> insert
///  * local copy has unsent edits (not `synced`) -> keep local
///  * otherwise                -> take the remote copy only if it is newer
class FirestoreRestoreService {
  FirestoreRestoreService({required this.db, required this.store, required this.uid});

  final AppDatabase db;
  final CloudStore store;
  final String uid;

  /// Restores everything. Returns the number of records written locally.
  Future<int> restoreAll() async {
    var written = 0;
    final byName = kSyncSpecsByQueueName;

    // Profile document (users/{uid}).
    final profile = await store.get(['users', uid]);
    if (profile != null) written += await _apply(byName['users']!, profile);

    // Farms, and the crops / activities nested under them.
    for (final farm in await store.list(['users', uid, 'farms'])) {
      written += await _apply(byName['farms']!, farm);
      final farmPath = ['users', uid, 'farms', '${farm['id']}'];
      for (final crop in await store.list([...farmPath, 'crops'])) {
        written += await _apply(byName['seasons']!, crop);
        for (final activity in await store.list([...farmPath, 'crops', '${crop['id']}', 'activities'])) {
          written += await _apply(byName['crop_activities']!, activity);
        }
      }
    }

    // Flat collections.
    const flat = {
      'expenses': 'expenses',
      'reminders': 'local_reminders',
      'documents': 'farm_documents',
      'soilReports': 'soil_reports',
      'tasks': 'tasks',
      'irrigationLogs': 'irrigation_logs',
      'fertilizerLogs': 'fertilizer_logs',
      'sprayLogs': 'spray_logs',
      'checkins': 'daily_checkins',
      'mandiPrices': 'mandi_price_logs',
    };
    for (final entry in flat.entries) {
      for (final doc in await store.list(['users', uid, entry.key])) {
        written += await _apply(byName[entry.value]!, doc);
      }
    }
    return written;
  }

  /// Applies one remote record; returns 1 if it changed the local database.
  Future<int> _apply(SyncTableSpec spec, Json remote) async {
    final id = remote['id'];
    if (id is! String) return 0;

    final local = await db
        .customSelect(
          'SELECT updated_at, sync_status FROM ${spec.sqlTable} WHERE id = ?',
          variables: [Variable<String>(id)],
        )
        .getSingleOrNull();

    if (local != null) {
      if (local.read<String>('sync_status') != 'synced') return 0; // unsent local edits win
      final localMs = local.read<int>('updated_at') * 1000; // drift stores seconds
      final remoteMs = (remote['updatedAt'] as num?)?.toInt() ?? 0;
      if (remoteMs <= localMs) return 0;
    }

    // drift's fromJson expects the enum itself for the converted column.
    final json = {...remote, 'syncStatus': SyncStatus.synced};
    await spec.upsert(db, json);
    return 1;
  }
}
