/// Area units farmers actually use across India (§13). Internal
/// calculations should convert to hectares; display uses the farmer's
/// chosen unit.
enum AreaUnit { acre, hectare, bigha, guntha }

class Farm {
  const Farm({
    required this.id,
    required this.userId,
    required this.name,
    required this.area,
    required this.areaUnit,
    this.country,
    this.state,
    this.district,
    this.village,
    this.soilType,
    this.irrigationType,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String userId;
  final String name;
  final double area;
  final AreaUnit areaUnit;
  final String? country;
  final String? state;
  final String? district;
  final String? village;
  final String? soilType;
  final String? irrigationType;
  final double? latitude;
  final double? longitude;

  bool get hasLocation => latitude != null && longitude != null;
}
