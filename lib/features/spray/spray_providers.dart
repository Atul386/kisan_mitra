import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_spray_repository.dart';
import 'domain/spray_log.dart';
import 'domain/spray_repository.dart';

final sprayRepositoryProvider = Provider<SprayRepository>((ref) {
  return LocalSprayRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final seasonSprayLogsProvider = StreamProvider<List<SprayLogEntry>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  final season = ref.watch(primaryActiveSeasonProvider).value;
  if (farm == null) return const Stream.empty();
  return ref.watch(sprayRepositoryProvider).watchLogs(farmId: farm.id, seasonId: season?.id);
});
