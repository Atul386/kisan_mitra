import 'live_mandi_price.dart';

/// Markets split into the farmer's own district and everywhere else.
///
/// The Mandi Price API lists each market with its district but without
/// coordinates, so "nearby" here means *same district first*, not a
/// measured distance.
class MandiGrouping {
  const MandiGrouping({required this.inDistrict, required this.otherDistricts});

  /// Markets in the chosen district, A–Z.
  final List<MandiMarket> inDistrict;

  /// Every other district (A–Z), each with its markets A–Z.
  final Map<String, List<MandiMarket>> otherDistricts;

  bool get isEmpty => inDistrict.isEmpty && otherDistricts.isEmpty;
}

String _norm(String s) => s.trim().toLowerCase();

/// Splits [markets] around [district] (matched ignoring case and spacing).
/// With no district, everything lands in [MandiGrouping.otherDistricts].
MandiGrouping groupMarkets(List<MandiMarket> markets, {String? district}) {
  final wanted = district == null || district.trim().isEmpty ? null : _norm(district);
  final mine = <MandiMarket>[];
  final byDistrict = <String, List<MandiMarket>>{};
  final seen = <String>{};

  for (final m in markets) {
    if (m.market.isEmpty) continue;
    if (!seen.add('${_norm(m.district)}|${_norm(m.market)}')) continue; // drop duplicates
    if (wanted != null && _norm(m.district) == wanted) {
      mine.add(m);
    } else {
      byDistrict.putIfAbsent(m.district.isEmpty ? '—' : m.district, () => []).add(m);
    }
  }

  int byName(MandiMarket a, MandiMarket b) => a.market.toLowerCase().compareTo(b.market.toLowerCase());
  mine.sort(byName);
  final keys = byDistrict.keys.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return MandiGrouping(
    inDistrict: mine,
    otherDistricts: {for (final k in keys) k: byDistrict[k]!..sort(byName)},
  );
}

/// Google Maps search for a market, e.g. "APMC Nagpur, Nagpur, Maharashtra".
Uri mandiMapsUri(MandiMarket market, String state) {
  final place = [market.market, market.district, state].where((s) => s.trim().isNotEmpty).join(', ');
  return Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': place});
}
