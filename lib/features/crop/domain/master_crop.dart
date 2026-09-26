/// Mirrors the future `master_crops/{cropId}` Firestore document
/// (blueprint §15). Kept local-only until the Firebase project exists.
class MasterCrop {
  const MasterCrop({required this.id, required this.names});

  final String id;

  /// Localized display name keyed by language code (en/hi/mr).
  final Map<String, String> names;

  String nameFor(String languageCode) => names[languageCode] ?? names['en'] ?? id;
}
