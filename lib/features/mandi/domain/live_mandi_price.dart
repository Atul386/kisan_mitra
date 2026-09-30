/// One reported price row from the Mandi Price API
/// (mandi-api.onrender.com, daily data sourced from data.gov.in /
/// Agmarknet) — distinct from [MandiPriceEntry], which is a price the
/// farmer personally logged.
///
/// These are the prices markets *reported* for [arrivalDate]; they are not
/// live auction quotes, so the date must always be shown next to them.
class LiveMandiPrice {
  const LiveMandiPrice({
    required this.state,
    required this.district,
    required this.market,
    required this.commodity,
    required this.variety,
    required this.grade,
    required this.arrivalDate,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  final String state;
  final String district;
  final String market;
  final String commodity;
  final String variety;
  final String grade;
  final DateTime arrivalDate;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;

  factory LiveMandiPrice.fromJson(Map<String, dynamic> json) {
    double price(dynamic v) => (v is num) ? v.toDouble() : double.tryParse('${v ?? ''}') ?? 0;
    // The API pads some market names with trailing spaces ("APMC Nagpur ").
    String text(dynamic v) => '${v ?? ''}'.trim();
    return LiveMandiPrice(
      state: text(json['state']),
      district: text(json['district']),
      market: text(json['market']),
      commodity: text(json['commodity']),
      variety: text(json['variety']),
      grade: text(json['grade']),
      arrivalDate: DateTime.tryParse(text(json['arrival_date'])) ?? DateTime.fromMillisecondsSinceEpoch(0),
      minPrice: price(json['min_price']),
      maxPrice: price(json['max_price']),
      modalPrice: price(json['modal_price']),
    );
  }
}

/// One day on the price-history chart.
class MandiHistoryPoint {
  const MandiHistoryPoint({
    required this.date,
    required this.modalPrice,
    required this.minPrice,
    required this.maxPrice,
  });

  final DateTime date;
  final double modalPrice;
  final double minPrice;
  final double maxPrice;

  /// The history endpoint returns daily averages (`avg_modal_price`) when no
  /// market is given, and raw market rows (`modal_price`) when one is.
  factory MandiHistoryPoint.fromJson(Map<String, dynamic> json) {
    double price(dynamic a, dynamic b) {
      final v = a ?? b;
      return (v is num) ? v.toDouble() : double.tryParse('${v ?? ''}') ?? 0;
    }

    return MandiHistoryPoint(
      date: DateTime.tryParse('${json['arrival_date'] ?? ''}') ?? DateTime.fromMillisecondsSinceEpoch(0),
      modalPrice: price(json['avg_modal_price'], json['modal_price']),
      minPrice: price(json['avg_min_price'], json['min_price']),
      maxPrice: price(json['avg_max_price'], json['max_price']),
    );
  }
}

class MandiMarket {
  const MandiMarket({required this.market, required this.district});
  final String market;
  final String district;

  factory MandiMarket.fromJson(Map<String, dynamic> json) =>
      MandiMarket(market: '${json['market'] ?? ''}'.trim(), district: '${json['district'] ?? ''}'.trim());
}

/// A result plus where it came from, so screens can say "showing your last
/// saved data" instead of pretending it is fresh.
class MandiResult<T> {
  const MandiResult(this.value, {this.fromCache = false, this.cachedAt});

  final T value;

  /// True when the network failed and this is older saved data.
  final bool fromCache;
  final DateTime? cachedAt;
}
