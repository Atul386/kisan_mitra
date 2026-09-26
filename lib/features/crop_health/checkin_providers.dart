import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_checkin_repository.dart';
import 'domain/checkin_repository.dart';
import 'domain/daily_checkin.dart';

final checkinRepositoryProvider = Provider<CheckinRepository>((ref) {
  return LocalCheckinRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final todayCheckinProvider = StreamProvider<DailyCheckin?>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  if (farm == null) return const Stream.empty();
  return ref.watch(checkinRepositoryProvider).watchTodayCheckin(farm.id);
});
