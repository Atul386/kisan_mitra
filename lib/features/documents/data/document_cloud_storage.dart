import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

/// Where backed-up document files live. The app uses Firebase Storage;
/// tests use an in-memory stand-in.
abstract class DocumentCloudStorage {
  /// Uploads the file and returns its cloud path.
  Future<String> upload({required String uid, required String documentId, required String localPath, required String mimeType});

  Future<void> download({required String cloudPath, required String toLocalPath});

  Future<void> delete(String cloudPath);
}

/// Files go to `users/{uid}/documents/{documentId}.{ext}` — the only place
/// `storage.rules` lets that user read and write.
class FirebaseDocumentCloudStorage implements DocumentCloudStorage {
  FirebaseDocumentCloudStorage(this._storage);

  final FirebaseStorage _storage;

  static String extensionFor(String mimeType) => switch (mimeType) {
        'application/pdf' => 'pdf',
        'image/png' => 'png',
        _ => 'jpg',
      };

  @override
  Future<String> upload({
    required String uid,
    required String documentId,
    required String localPath,
    required String mimeType,
  }) async {
    final path = 'users/$uid/documents/$documentId.${extensionFor(mimeType)}';
    await _storage.ref(path).putFile(File(localPath), SettableMetadata(contentType: mimeType));
    return path;
  }

  @override
  Future<void> download({required String cloudPath, required String toLocalPath}) async {
    await _storage.ref(cloudPath).writeToFile(File(toLocalPath));
  }

  @override
  Future<void> delete(String cloudPath) async {
    try {
      await _storage.ref(cloudPath).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow; // already gone is fine
    }
  }
}
