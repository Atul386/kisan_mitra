/// Values stored in [Season.status].
abstract class SeasonStatus {
  static const active = 'active';
  static const harvested = 'harvested';
  static const completed = 'completed';
  static const all = [active, harvested, completed];
}

class Season {
  const Season({
    required this.id,
    required this.farmId,
    required this.cropId,
    required this.cropName,
    required this.sowingDate,
    this.variety,
    this.area,
    this.areaUnit,
    this.seasonName,
    this.status = SeasonStatus.active,
    this.expectedHarvestDate,
    this.notes,
  });

  final String id;
  final String farmId;
  final String cropId;
  final String cropName;
  final DateTime sowingDate;
  final String? variety;
  final double? area;

  /// [AreaUnit] name (acre, hectare, …); null for crops added before v3.
  final String? areaUnit;

  /// kharif, rabi or zaid.
  final String? seasonName;
  final String status;
  final DateTime? expectedHarvestDate;
  final String? notes;

  int get dayNumber => DateTime.now().difference(sowingDate).inDays + 1;

  bool get isActive => status == SeasonStatus.active;
}
