/// Soil test values the farmer typed in. Every value is optional because
/// reports differ; at least one must be present.
class SoilReport {
  const SoilReport({
    required this.id,
    required this.farmId,
    required this.date,
    this.ph,
    this.nitrogen,
    this.phosphorus,
    this.potassium,
    this.organicCarbon,
    this.otherNutrients,
    this.documentId,
  });

  final String id;
  final String farmId;
  final DateTime date;
  final double? ph;
  final double? nitrogen; // kg/ha
  final double? phosphorus; // kg/ha
  final double? potassium; // kg/ha
  final double? organicCarbon; // %
  final String? otherNutrients;

  /// Scanned Soil Health Card kept in the document locker.
  final String? documentId;

  bool get hasValues =>
      ph != null || nitrogen != null || phosphorus != null || potassium != null || organicCarbon != null;
}

/// Plausible ranges used to catch typing mistakes (e.g. pH 65 instead of 6.5).
/// They are sanity limits, not agronomic advice.
class SoilLimits {
  const SoilLimits(this.min, this.max);

  final double min;
  final double max;

  static const ph = SoilLimits(0, 14);
  static const nutrientKgPerHa = SoilLimits(0, 5000);
  static const organicCarbonPercent = SoilLimits(0, 20);

  bool contains(double v) => v.isFinite && v >= min && v <= max;

  /// Parses typed text (comma or dot decimals). Blank is fine (no value),
  /// a number inside the range gives a value, anything else is invalid.
  SoilParse parse(String text) {
    final trimmed = text.trim().replaceAll(',', '.');
    if (trimmed.isEmpty) return const SoilParse.blank();
    final v = double.tryParse(trimmed);
    if (v == null || !contains(v)) return const SoilParse.invalid();
    return SoilParse.value(v);
  }
}

class SoilParse {
  const SoilParse.blank() : value = null, isInvalid = false;
  const SoilParse.invalid() : value = null, isInvalid = true;
  const SoilParse.value(double this.value) : isInvalid = false;

  final double? value;
  final bool isInvalid;
}
