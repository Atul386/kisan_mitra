import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_fertilizer_repository.dart';
import 'domain/fertilizer_log.dart';
import 'domain/fertilizer_repository.dart';

final fertilizerRepositoryProvider = Provider<FertilizerRepository>((ref) {
  return LocalFertilizerRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final seasonFertilizerLogsProvider = StreamProvider<List<FertilizerLogEntry>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
  if (farm == null) return const Stream.empty();
  return ref
      .watch(fertilizerRepositoryProvider)
      .watchLogs(farmId: farm.id, seasonId: season?.id);
});
