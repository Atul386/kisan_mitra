import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/feature_flags.dart';
import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../../core/utils/shared_preferences_provider.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/mandi_api_cache.dart';
import 'data/mandi_api_repository.dart';
import 'data/local_mandi_repository.dart';
import 'domain/live_mandi_price.dart';
import 'domain/live_mandi_repository.dart';
import 'domain/mandi_price.dart';
import 'domain/mandi_repository.dart';

final mandiRepositoryProvider = Provider<MandiRepository>((ref) {
  return LocalMandiRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final mandiApiCacheProvider = Provider<MandiApiCache>((ref) => MandiApiCache(ref.watch(sharedPreferencesProvider)));

/// Mandi Price API (keyless) — see [MandiApiRepository].
final liveMandiRepositoryProvider = Provider<LiveMandiRepository>(
  (ref) => MandiApiRepository(cache: ref.watch(mandiApiCacheProvider), baseUrl: kMandiApiBaseUrl),
);

/// State to look prices up for: the farm's own state when the API serves
/// it, Maharashtra while the farm has none set, and null for a state the
/// API doesn't cover (the screen then explains that).
final mandiStateProvider = Provider<String?>((ref) {
  final raw = ref.watch(primaryFarmProvider)?.state?.trim();
  if (raw == null || raw.isEmpty) return 'Maharashtra';
  for (final s in kMandiSupportedStates) {
    if (s.toLowerCase() == raw.toLowerCase()) return s;
  }
  return null;
});

/// What the farmer has narrowed the live prices to. For [commodity], null
/// means "use my active crop" and an empty string means "all crops".
class MandiFilter {
  const MandiFilter({this.commodity, this.district, this.market, this.variety});

  final String? commodity;
  final String? district;
  final String? market;
  final String? variety;

  MandiFilter copyWith({
    String? Function()? commodity,
    String? Function()? district,
    String? Function()? market,
    String? Function()? variety,
  }) => MandiFilter(
    commodity: commodity != null ? commodity() : this.commodity,
    district: district != null ? district() : this.district,
    market: market != null ? market() : this.market,
    variety: variety != null ? variety() : this.variety,
  );

  bool get hasNarrowing => district != null || market != null || variety != null;
}

final mandiFilterProvider = StateProvider<MandiFilter>((ref) => const MandiFilter());

/// Crop being looked up: the explicit pick, else the active crop, else none.
final mandiEffectiveCommodityProvider = Provider<String?>((ref) {
  final picked = ref.watch(mandiFilterProvider.select((f) => f.commodity));
  if (picked != null) return picked.isEmpty ? null : picked;
  return ref.watch(primaryActiveSeasonProvider).valueOrNull?.cropName;
});

/// Reported prices for the current state/crop/market/variety. Throws a
/// [MandiException] (offline, rate-limited, unsupported state, ...) for the
/// screen to turn into a friendly message; results carry `fromCache` when
/// they are older saved data.
final liveMandiResultProvider = FutureProvider<MandiResult<List<LiveMandiPrice>>>((ref) async {
  final state = ref.watch(mandiStateProvider);
  if (state == null) throw const MandiUnsupportedStateException();
  final filter = ref.watch(mandiFilterProvider);
  final commodity = ref.watch(mandiEffectiveCommodityProvider);

  final result = await ref
      .watch(liveMandiRepositoryProvider)
      .fetchPrices(state: state, commodity: commodity, market: filter.market, variety: filter.variety);

  // The API has no district parameter, so district is applied here.
  final district = filter.district;
  if (district == null) return result;
  return MandiResult(
    result.value.where((p) => p.district == district).toList(),
    fromCache: result.fromCache,
    cachedAt: result.cachedAt,
  );
});

/// Plain list for callers that only want prices (dashboard ticker, alert
/// checker); empty whenever the feed is unavailable.
final liveMandiPricesProvider = Provider<AsyncValue<List<LiveMandiPrice>>>((ref) {
  return ref.watch(liveMandiResultProvider).whenData((r) => r.value);
});

final mandiMarketsProvider = FutureProvider<MandiResult<List<MandiMarket>>>((ref) async {
  final state = ref.watch(mandiStateProvider);
  if (state == null) throw const MandiUnsupportedStateException();
  return ref.watch(liveMandiRepositoryProvider).fetchMarkets(state);
});

final mandiCommoditiesProvider = FutureProvider<MandiResult<List<String>>>((ref) async {
  final state = ref.watch(mandiStateProvider);
  if (state == null) throw const MandiUnsupportedStateException();
  return ref.watch(liveMandiRepositoryProvider).fetchCommodities(state: state);
});

/// Price history is requested for one crop (and optionally one market).
class MandiHistoryRequest {
  const MandiHistoryRequest({required this.commodity, this.market, required this.days});

  final String commodity;
  final String? market;
  final int days;

  @override
  bool operator ==(Object other) =>
      other is MandiHistoryRequest && other.commodity == commodity && other.market == market && other.days == days;

  @override
  int get hashCode => Object.hash(commodity, market, days);
}

final mandiHistoryProvider = FutureProvider.family<MandiResult<List<MandiHistoryPoint>>, MandiHistoryRequest>((
  ref,
  request,
) async {
  final state = ref.watch(mandiStateProvider);
  if (state == null) throw const MandiUnsupportedStateException();
  final today = DateTime.now();
  return ref
      .watch(liveMandiRepositoryProvider)
      .fetchHistory(
        state: state,
        commodity: request.commodity,
        market: request.market,
        from: DateTime(today.year, today.month, today.day).subtract(Duration(days: request.days)),
        to: today,
      );
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
  final entries = ref.watch(mandiPricesProvider).valueOrNull ?? const [];
  final byCommodity = <String, List<MandiPriceEntry>>{};
  for (final e in entries) {
    byCommodity.putIfAbsent(e.commodity, () => []).add(e);
  }
  return byCommodity.values
      .map((list) => MandiTrend(latest: list.first, previous: list.length > 1 ? list[1] : null))
      .toList();
});
