/// Rough per-season estimate. Pure arithmetic so it is easy to test;
/// always presented to the farmer as "ESTIMATE ONLY".
class ProfitEstimate {
  const ProfitEstimate({required this.revenue, required this.cost});

  final double revenue;
  final double cost;

  double get margin => revenue - cost;
  bool get isLoss => margin < 0;

  factory ProfitEstimate.calculate({
    required double areaAcres,
    required double yieldPerAcreQuintal,
    required double pricePerQuintal,
    Iterable<double> costs = const [],
  }) {
    final revenue = areaAcres * yieldPerAcreQuintal * pricePerQuintal;
    final cost = costs.fold<double>(0, (sum, c) => sum + c);
    return ProfitEstimate(revenue: revenue, cost: cost);
  }
}
