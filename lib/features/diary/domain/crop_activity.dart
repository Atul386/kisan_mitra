/// What the farmer did or saw. Stored by [name], so never rename a value.
enum ActivityType {
  sowing('🌱'),
  irrigation('💧'),
  fertilizer('🧪'),
  spray('🧴'),
  pestObservation('🐛'),
  diseaseObservation('🍂'),
  labour('👷'),
  harvest('🌾'),
  sale('💰'),
  other('📝');

  const ActivityType(this.emoji);
  final String emoji;

  static ActivityType fromName(String name) =>
      ActivityType.values.firstWhere((t) => t.name == name, orElse: () => ActivityType.other);
}

class CropActivity {
  const CropActivity({
    required this.id,
    required this.farmId,
    required this.seasonId,
    required this.type,
    required this.date,
    this.notes,
    this.photoPath,
    this.cost,
  });

  final String id;
  final String farmId;
  final String seasonId;
  final ActivityType type;
  final DateTime date;
  final String? notes;
  final String? photoPath;

  /// What this activity cost (₹), if the farmer noted it. Informational:
  /// it is not added to the expense list automatically.
  final double? cost;

  CropActivity copyWith({ActivityType? type, DateTime? date, String? notes, String? photoPath, double? cost}) => CropActivity(
        id: id,
        farmId: farmId,
        seasonId: seasonId,
        type: type ?? this.type,
        date: date ?? this.date,
        notes: notes ?? this.notes,
        photoPath: photoPath ?? this.photoPath,
        cost: cost ?? this.cost,
      );
}
