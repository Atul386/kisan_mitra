import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_soil_repository.dart';
import 'domain/soil_report.dart';
import 'domain/soil_repository.dart';

final soilRepositoryProvider = Provider<SoilRepository>((ref) {
  return LocalSoilRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

/// Soil tests for the farm the farmer is working on.
final soilReportsProvider = StreamProvider<List<SoilReport>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  if (farm == null) return const Stream.empty();
  return ref.watch(soilRepositoryProvider).watchReports(farm.id);
});
