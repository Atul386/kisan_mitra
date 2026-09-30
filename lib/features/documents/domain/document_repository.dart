import 'farm_document.dart';

abstract class DocumentRepository {
  /// Newest first.
  Stream<List<FarmDocument>> watchDocuments();
  Future<FarmDocument?> getDocument(String id);
  Future<void> addDocument(FarmDocument document);
  Future<void> setCloudPath(String id, String? cloudPath);

  /// Points a restored document at its file on this phone.
  Future<void> setLocalPath(String id, String localPath);
  Future<void> deleteDocument(String id);
}
