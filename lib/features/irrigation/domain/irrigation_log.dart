class IrrigationLogEntry {
  const IrrigationLogEntry({
    required this.id,
    required this.farmId,
    required this.date,
    this.seasonId,
    this.durationMinutes,
    this.method,
    this.notes,
  });

  final String id;
  final String farmId;
  final String? seasonId;
  final DateTime date;
  final int? durationMinutes;
  final String? method;
  final String? notes;
}
