import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import 'data/local_master_crops.dart';
import 'data/local_season_repository.dart';
import 'domain/master_crop.dart';
import 'domain/season.dart';
import 'domain/season_repository.dart';

final seasonRepositoryProvider = Provider<SeasonRepository>((ref) {
  return LocalSeasonRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final activeSeasonProvider = StreamProvider.family<Season?, String>((ref, farmId) {
  return ref.watch(seasonRepositoryProvider).watchActiveSeason(farmId);
});

final masterCropsProvider = Provider<List<MasterCrop>>((ref) => kLocalMasterCrops);
