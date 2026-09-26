import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import 'data/local_farm_repository.dart';
import 'domain/farm.dart';
import 'domain/farm_repository.dart';

final farmRepositoryProvider = Provider<FarmRepository>((ref) {
  return LocalFarmRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final userFarmsProvider = StreamProvider.family<List<Farm>, String>((ref, userId) {
  return ref.watch(farmRepositoryProvider).watchFarms(userId);
});
