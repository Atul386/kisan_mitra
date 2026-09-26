import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import '../network/connectivity_provider.dart';
import 'sync_engine.dart';
import 'sync_queue_repository.dart';

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  return SyncQueueRepository(ref.watch(appDatabaseProvider));
});

/// No handlers registered yet — see [SyncEngine] and
/// core/firebase/README.md for how real `Firebase*Repository` handlers
/// plug in once that project exists.
final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(ref.watch(syncQueueRepositoryProvider));
});

/// How many local records are still waiting to sync — shown in Settings
/// so the farmer can see their data is safely saved even offline (§8, §42).
final pendingSyncCountProvider = StreamProvider<int>((ref) {
  return ref.watch(syncQueueRepositoryProvider).watchPendingCount();
});

/// Attempts a drain whenever connectivity comes back — a no-op today
/// since no handlers are registered, but wired so it starts working the
/// moment they are.
final syncOnConnectivityProvider = Provider<void>((ref) {
  ref.listen(isOnlineProvider, (previous, next) {
    if (next.value == true) {
      ref.read(syncEngineProvider).drain();
    }
  });
});
