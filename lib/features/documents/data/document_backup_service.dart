import 'dart:io';

import 'package:path/path.dart' as p;

import '../domain/document_repository.dart';
import '../domain/farm_document.dart';
import 'document_cloud_storage.dart';

/// Optional cloud copy of a locker document. The phone's copy is always the
/// primary one — backup failing never affects the local document.
class DocumentBackupService {
  DocumentBackupService({
    required this.repository,
    required this.storage,
    required this.uid,
    required this.documentsDir,
  });

  final DocumentRepository repository;
  final DocumentCloudStorage storage;
  final String uid;

  /// Where restored files are written (the app's private documents folder).
  final Future<String> Function() documentsDir;

  /// Uploads [doc] and records where it went.
  Future<void> backUp(FarmDocument doc) async {
    final cloudPath = await storage.upload(
      uid: uid,
      documentId: doc.id,
      localPath: doc.localPath,
      mimeType: doc.mimeType,
    );
    await repository.setCloudPath(doc.id, cloudPath);
  }

  /// Makes sure the file exists on this phone, downloading it from the cloud
  /// when the record came from another phone. Returns the local path, or
  /// null if the file is missing and can't be fetched.
  Future<String?> ensureLocalFile(FarmDocument doc) async {
    if (await File(doc.localPath).exists()) return doc.localPath;
    final cloudPath = doc.cloudPath;
    if (cloudPath == null) return null;

    final dir = Directory(await documentsDir());
    await dir.create(recursive: true);
    final target = p.join(dir.path, '${doc.id}${p.extension(cloudPath)}');
    await storage.download(cloudPath: cloudPath, toLocalPath: target);
    await repository.setLocalPath(doc.id, target);
    return target;
  }

  /// Removes the cloud copy (if any) — used when the farmer deletes a document.
  Future<void> removeCloudCopy(FarmDocument doc) async {
    final cloudPath = doc.cloudPath;
    if (cloudPath != null) await storage.delete(cloudPath);
  }
}
