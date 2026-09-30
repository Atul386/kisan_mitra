import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import '../firebase/firebase_bootstrap.dart';
import '../network/connectivity_provider.dart';
import '../utils/error_reporter.dart';
import '../utils/shared_preferences_provider.dart';
import 'cloud_store.dart';
import 'firestore_restore.dart';
import 'firestore_sync_handler.dart';
import 'firestore_sync_specs.dart';
import 'sync_engine.dart';
import 'sync_queue_repository.dart';
import 'sync_reconciler.dart';

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  return SyncQueueRepository(ref.watch(appDatabaseProvider));
});

/// The signed-in Firebase user's id, or null when Firebase isn't available
/// or nobody is signed in (local guest mode). Cloud sync only runs with a
/// real Firebase user, because Firestore rules are per-user.
final firebaseUidProvider = StreamProvider<String?>((ref) {
  if (!isFirebaseAvailable) return Stream.value(null);
  return FirebaseAuth.instance.authStateChanges().map((user) => user?.uid);
});

final cloudStoreProvider = Provider<CloudStore>((ref) => FirestoreCloudStore(FirebaseFirestore.instance));

/// With a Firebase user: pushes each queued change to Firestore. Without
/// one: no handlers, so changes simply stay queued — "saved on this phone,
/// not yet synced" — and are sent once the farmer signs in.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final queue = ref.watch(syncQueueRepositoryProvider);
  final uid = ref.watch(firebaseUidProvider).valueOrNull;
  if (!isFirebaseAvailable || uid == null) return SyncEngine(queue);

  final db = ref.watch(appDatabaseProvider);
  final store = ref.watch(cloudStoreProvider);
  return SyncEngine(
    queue,
    handlers: {
      for (final spec in kSyncSpecs)
        spec.queueName: FirestoreSyncHandler(spec: spec, db: db, store: store, uid: uid),
    },
  );
});

/// How many local records are still waiting to sync — shown in Settings
/// so the farmer can see their data is safely saved even offline (§8, §42).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  return ref.watch(syncQueueRepositoryProvider).watchPendingCount();
});

/// Attempts a drain whenever connectivity comes back.
final syncOnConnectivityProvider = Provider<void>((ref) {
  ref.listen(isOnlineProvider, (previous, next) {
    if (next.valueOrNull == true) {
      ref.read(syncEngineProvider).drain();
    }
  });
});

const _restoredUidKey = 'cloud_restored_uid';

/// Runs once a Firebase user exists (watched from the app root):
///  1. restore their cloud data onto this phone (once per account),
///  2. queue anything still unsynced (e.g. guest data made before sign-in),
///  3. drain the queue now, and again shortly after every later local change.
final cloudSyncStartupProvider = FutureProvider<void>((ref) async {
  final uid = ref.watch(firebaseUidProvider).valueOrNull;
  if (!isFirebaseAvailable || uid == null) return;

  final db = ref.read(appDatabaseProvider);
  final prefs = ref.read(sharedPreferencesProvider);

  // Changes made from now on are pushed after a short pause (batches bursts).
  Timer? debounce;
  ref.onDispose(() => debounce?.cancel());
  ref.listen(pendingSyncCountProvider, (previous, next) {
    if ((next.valueOrNull ?? 0) == 0) return;
    debounce?.cancel();
    debounce = Timer(const Duration(seconds: 2), () {
      if (ref.read(isOnlineProvider).valueOrNull == true) ref.read(syncEngineProvider).drain();
    });
  });

  try {
    if (prefs.getString(_restoredUidKey) != uid) {
      await FirestoreRestoreService(db: db, store: ref.read(cloudStoreProvider), uid: uid).restoreAll();
      await prefs.setString(_restoredUidKey, uid);
    }
  } catch (e, st) {
    // Offline or a transient error: try again next launch. Local data is untouched.
    reportError(e, st, context: 'cloudSyncStartup.restore');
  }

  await requeueUnsynced(db, ref.read(syncQueueRepositoryProvider));
  if (ref.read(isOnlineProvider).valueOrNull != false) {
    await ref.read(syncEngineProvider).drain();
  }
});
