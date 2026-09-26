enum CheckinHealth { good, needsAttention, problem }

enum CheckinConcern { pest, leafChange, waterStress, disease, other }

class DailyCheckin {
  const DailyCheckin({
    required this.id,
    required this.farmId,
    required this.date,
    required this.healthStatus,
    this.seasonId,
    this.concern,
    this.note,
    this.photoPath,
  });

  final String id;
  final String farmId;
  final String? seasonId;
  final DateTime date;
  final CheckinHealth healthStatus;
  final CheckinConcern? concern;
  final String? note;
  final String? photoPath;
}
