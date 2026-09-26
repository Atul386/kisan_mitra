class MandiPriceEntry {
  const MandiPriceEntry({
    required this.id,
    required this.farmId,
    required this.commodity,
    required this.price,
    required this.date,
    this.market,
    this.unit = 'quintal',
    this.notes,
  });

  final String id;
  final String farmId;
  final String commodity;
  final String? market;
  final double price;
  final String unit;
  final DateTime date;
  final String? notes;
}
