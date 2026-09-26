/// Mirrors the future `master_tasks` Firestore collection (blueprint §46).
/// A `cropId` of null applies to every crop — used as a generic fallback so
/// crops without a dedicated template set still get sensible daily tasks.
class TaskTemplate {
  const TaskTemplate({
    required this.id,
    required this.dayFrom,
    required this.dayTo,
    required this.title,
    this.cropId,
  });

  final String id;
  final String? cropId;
  final int dayFrom;
  final int dayTo;

  /// Localized task text keyed by language code (en/hi/mr).
  final Map<String, String> title;

  bool appliesTo({required String cropId, required int day}) {
    if (this.cropId != null && this.cropId != cropId) return false;
    return day >= dayFrom && day <= dayTo;
  }

  String titleFor(String languageCode) => title[languageCode] ?? title['en'] ?? '';
}
