class FertilizerLogEntry {
  const FertilizerLogEntry({
    required this.id,
    required this.farmId,
    required this.date,
    required this.product,
    this.seasonId,
    this.quantity,
    this.unit,
    this.cost,
    this.notes,
  });

  final String id;
  final String farmId;
  final String? seasonId;
  final DateTime date;
  final String product;
  final double? quantity;
  final String? unit;
  final double? cost;
  final String? notes;
}
