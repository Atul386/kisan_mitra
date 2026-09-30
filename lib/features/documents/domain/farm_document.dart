/// Folders in the document locker. Stored by [name].
enum DocumentCategory {
  extract712('📜'),
  extract8a('📄'),
  soilHealthCard('🧪'),
  cropInsurance('🛡️'),
  bankDocuments('🏦'),
  pmKisan('💳'),
  mahadbt('🏛️'),
  other('📁');

  const DocumentCategory(this.emoji);
  final String emoji;

  static DocumentCategory fromName(String name) =>
      DocumentCategory.values.firstWhere((c) => c.name == name, orElse: () => DocumentCategory.other);
}

class FarmDocument {
  const FarmDocument({
    required this.id,
    required this.category,
    required this.title,
    required this.localPath,
    required this.mimeType,
    required this.sizeBytes,
    required this.createdAt,
    this.farmId,
    this.cloudPath,
  });

  final String id;
  final String? farmId;
  final DocumentCategory category;
  final String title;
  final String localPath;
  final String mimeType;
  final int sizeBytes;
  final DateTime createdAt;

  /// Firebase Storage path once backed up; null while only on this phone.
  final String? cloudPath;

  bool get isBackedUp => cloudPath != null;
  bool get isImage => mimeType.startsWith('image/');
  bool get isPdf => mimeType == 'application/pdf';
}

/// Rules for what can go in the locker. Kept in one place and mirrored by
/// `storage.rules`, so the phone never accepts a file the server would refuse.
class DocumentRules {
  static const maxBytes = 10 * 1024 * 1024;
  static const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  /// MIME type for an allowed file name, or null when the type isn't allowed.
  static String? mimeTypeFor(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot < 0) return null;
    return switch (fileName.substring(dot + 1).toLowerCase()) {
      'pdf' => 'application/pdf',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      _ => null,
    };
  }

  /// null when fine, otherwise why the file was rejected.
  static DocumentRejection? check(String fileName, int sizeBytes) {
    if (mimeTypeFor(fileName) == null) return DocumentRejection.unsupportedType;
    if (sizeBytes <= 0) return DocumentRejection.empty;
    if (sizeBytes > maxBytes) return DocumentRejection.tooLarge;
    return null;
  }
}

enum DocumentRejection { unsupportedType, tooLarge, empty }
