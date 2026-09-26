import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/data_gov_mandi_repository.dart';
import 'data/local_mandi_repository.dart';
import 'domain/live_mandi_price.dart';
import 'domain/mandi_price.dart';
import 'domain/mandi_repository.dart';

final mandiRepositoryProvider = Provider<MandiRepository>((ref) {
  return LocalMandiRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

/// Set at build time with `--dart-define=MANDI_API_KEY=your-free-key`
/// (see lib/features/mandi/README.md) — never hardcoded in source.
const _mandiApiKey = String.fromEnvironment('MANDI_API_KEY');

final dataGovMandiRepositoryProvider = Provider((ref) => DataGovMandiRepository(apiKey: _mandiApiKey));

/// Government Agmarknet prices for the farmer's state, filtered to their
/// active crop when they have one. Empty (never an error) when the feed
/// isn't configured, the farm has no state set, or the request fails —
/// the manual-entry trend list above is always available as a fallback.
final liveMandiPricesProvider = FutureProvider<List<LiveMandiPrice>>((ref) async {
  final farm = ref.watch(primaryFarmProvider);
  final repo = ref.watch(dataGovMandiRepositoryProvider);
  final state = farm?.state;
  if (state == null || state.trim().isEmpty || !repo.isConfigured) return const [];

  final season = ref.watch(primaryActiveSeasonProvider).value;
  try {
    return await repo.fetchPrices(state: state, commodity: season?.cropName);
  } catch (_) {
    return const [];
  }
});

final mandiPricesProvider = StreamProvider<List<MandiPriceEntry>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  if (farm == null) return const Stream.empty();
  return ref.watch(mandiRepositoryProvider).watchPrices(farmId: farm.id);
});

/// Latest entry per commodity plus the change vs. the previous entry for
/// that same commodity — the "Today ₹X, Yesterday ₹Y, Change +₹Z" view
/// from §69.
class MandiTrend {
  const MandiTrend({required this.latest, required this.previous});
  final MandiPriceEntry latest;
  final MandiPriceEntry? previous;

  double? get change => previous == null ? null : latest.price - previous!.price;
}

final mandiTrendsProvider = Provider<List<MandiTrend>>((ref) {
  final entries = ref.watch(mandiPricesProvider).value ?? const [];
  final byCommodity = <String, List<MandiPriceEntry>>{};
  for (final e in entries) {
    byCommodity.putIfAbsent(e.commodity, () => []).add(e);
  }
  return byCommodity.values
      .map((list) => MandiTrend(latest: list.first, previous: list.length > 1 ? list[1] : null))
      .toList();
});
