import 'live_mandi_price.dart';

/// Source of reported government mandi prices. The app depends on this
/// interface, so the provider behind it can change without touching screens.
abstract class LiveMandiRepository {
  Future<MandiResult<List<LiveMandiPrice>>> fetchPrices({
    required String state,
    String? commodity,
    String? market,
    String? variety,
    DateTime? date,
  });

  Future<MandiResult<List<MandiHistoryPoint>>> fetchHistory({
    required String state,
    required String commodity,
    String? market,
    required DateTime from,
    required DateTime to,
  });

  Future<MandiResult<List<MandiMarket>>> fetchMarkets(String state);

  Future<MandiResult<List<String>>> fetchCommodities({required String state, String? market});
}

/// States the API serves (v1). Anything else would just return an error.
const kMandiSupportedStates = ['Maharashtra', 'Uttar Pradesh', 'Punjab', 'Madhya Pradesh', 'Karnataka'];

sealed class MandiException implements Exception {
  const MandiException();
}

/// No network and nothing saved to fall back to.
class MandiOfflineException extends MandiException {
  const MandiOfflineException();
}

/// The shared 100-requests-per-15-minutes limit was hit.
class MandiRateLimitedException extends MandiException {
  const MandiRateLimitedException();
}

class MandiUnsupportedStateException extends MandiException {
  const MandiUnsupportedStateException();
}

/// Server error or an unreadable response. [detail] is for logs only —
/// never shown to the farmer.
class MandiFetchException extends MandiException {
  const MandiFetchException(this.detail);
  final String detail;

  @override
  String toString() => 'MandiFetchException: $detail';
}
