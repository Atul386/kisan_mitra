import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/firebase/firebase_bootstrap.dart';
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
  if (isFirebaseAvailable) {
    return FirebaseAuthRepository(
      ref.watch(appDatabaseProvider),
      ref.watch(syncQueueRepositoryProvider),
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
