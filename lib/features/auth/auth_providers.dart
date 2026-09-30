import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/feature_flags.dart';
import '../../core/database/database_providers.dart';
import '../../core/firebase/firebase_bootstrap.dart';
import '../../core/network/connectivity_provider.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/utils/shared_preferences_provider.dart';
import 'data/firebase_auth_repository.dart';
import 'data/local_auth_repository.dart';
import 'domain/app_user.dart';
import 'domain/auth_repository.dart';

/// Firebase-backed once the current platform has it configured
/// (`isFirebaseAvailable`, set in `main()`); otherwise the fully-offline
/// local implementation — guest mode and everything downstream of it
/// keeps working either way (blueprint §7, §35).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (kPhoneLoginEnabled && isFirebaseAvailable) {
    return FirebaseAuthRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(syncQueueRepositoryProvider),
      ref.watch(sharedPreferencesProvider),
    );
  }
  return LocalAuthRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(sharedPreferencesProvider),
    ref.watch(syncQueueRepositoryProvider),
  );
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUser();
});

/// A guest who started offline gets a real Firebase account (and keeps
/// their data) as soon as the phone is back online. Watched from the app root.
final upgradeOfflineGuestProvider = Provider<void>((ref) {
  ref.listen(isOnlineProvider, (_, next) {
    final repo = ref.read(authRepositoryProvider);
    if (next.valueOrNull == true && repo is FirebaseAuthRepository) repo.upgradeOfflineGuest();
  }, fireImmediately: true);
});

/// With login switched off (v1.0), every install simply gets a local guest
/// account — created on first launch and again after "Reset app data".
/// Watched from the app root.
final autoGuestProvider = Provider<void>((ref) {
  if (kPhoneLoginEnabled) return;
  var creating = false;
  ref.listen(currentUserProvider, (_, next) async {
    if (!next.hasValue || next.value != null || creating) return;
    creating = true;
    try {
      await ref.read(authRepositoryProvider).continueAsGuest();
    } finally {
      creating = false;
    }
  }, fireImmediately: true);
});
