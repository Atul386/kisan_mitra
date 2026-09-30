/// Kinds of agriculture service the farmer can look for on the map.
enum NearbyCategory {
  apmc('APMC mandi market'),
  soilLab('soil testing laboratory'),
  agriOffice('agriculture office'),
  seedDealer('seed dealer'),
  fertilizerDealer('fertilizer dealer'),
  equipmentRental('agricultural equipment rental'),
  tractorRental('tractor rental'),
  vet('veterinary hospital'),
  csc('CSC common service centre'),
  bank('bank'),
  govOffice('government office');

  const NearbyCategory(this.searchTerm);

  /// Query sent to the maps app (search terms are not translated).
  final String searchTerm;
}

/// Google Maps search link for [category] around a point, or around the
/// phone's own location when the farm has no coordinates saved.
Uri nearbySearchUri(NearbyCategory category, {double? latitude, double? longitude}) {
  final hasPoint = latitude != null && longitude != null;
  return Uri.https('www.google.com', '/maps/search/', {
    'api': '1',
    'query': hasPoint ? '${category.searchTerm} near $latitude,$longitude' : '${category.searchTerm} near me',
  });
}
