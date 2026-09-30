import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import 'data/local_crop_activity_repository.dart';
import 'domain/crop_activity.dart';
import 'domain/crop_activity_repository.dart';

final cropActivityRepositoryProvider = Provider<CropActivityRepository>((ref) {
  return LocalCropActivityRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final seasonActivitiesProvider = StreamProvider.family<List<CropActivity>, String>((ref, seasonId) {
  return ref.watch(cropActivityRepositoryProvider).watchActivities(seasonId);
});
