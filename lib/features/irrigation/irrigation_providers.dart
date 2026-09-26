import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_irrigation_repository.dart';
import 'domain/irrigation_log.dart';
import 'domain/irrigation_repository.dart';

final irrigationRepositoryProvider = Provider<IrrigationRepository>((ref) {
  return LocalIrrigationRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final seasonIrrigationLogsProvider = StreamProvider<List<IrrigationLogEntry>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  final season = ref.watch(primaryActiveSeasonProvider).value;
  if (farm == null) return const Stream.empty();
  return ref
      .watch(irrigationRepositoryProvider)
      .watchLogs(farmId: farm.id, seasonId: season?.id);
});

/// Days since the most recent irrigation, for the dashboard summary card
/// (blueprint §18). Null when nothing has been logged yet.
final daysSinceLastIrrigationProvider = Provider<int?>((ref) {
  final logs = ref.watch(seasonIrrigationLogsProvider).value ?? const [];
  if (logs.isEmpty) return null;
  final last = logs.first.date;
  return DateTime.now().difference(DateTime(last.year, last.month, last.day)).inDays;
});

/// A next-irrigation date projected from the farmer's own logged interval
/// (average gap between their last few irrigations) — not an agronomic
/// recommendation, since we have no soil-moisture or crop-stage data to
/// base one on. Null until at least 2 irrigations are logged.
final suggestedNextIrrigationProvider = Provider<DateTime?>((ref) {
  final logs = ref.watch(seasonIrrigationLogsProvider).value ?? const [];
  if (logs.length < 2) return null;

  final sorted = [...logs]..sort((a, b) => b.date.compareTo(a.date));
  final intervals = <int>[];
  for (var i = 0; i < sorted.length - 1 && i < 5; i++) {
    final gap = sorted[i].date.difference(sorted[i + 1].date).inDays;
    if (gap > 0) intervals.add(gap);
  }
  if (intervals.isEmpty) return null;

  final avgDays = (intervals.reduce((a, b) => a + b) / intervals.length).round();
  final last = sorted.first.date;
  return DateTime(last.year, last.month, last.day).add(Duration(days: avgDays));
});
