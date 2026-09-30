import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import 'data/document_backup_service.dart';
import 'data/document_cloud_storage.dart';
import 'data/document_file_service.dart';
import 'data/local_document_repository.dart';
import 'domain/document_repository.dart';
import 'domain/farm_document.dart';

final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return LocalDocumentRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

final documentFileServiceProvider = Provider<DocumentFileService>((ref) => const DocumentFileService());

final documentsProvider = StreamProvider<List<FarmDocument>>((ref) => ref.watch(documentRepositoryProvider).watchDocuments());

final documentCloudStorageProvider = Provider<DocumentCloudStorage>(
  (ref) => FirebaseDocumentCloudStorage(FirebaseStorage.instance),
);

/// Null when nobody is signed in to Firebase (guest mode): backup isn't
/// offered then, and documents simply stay on the phone.
final documentBackupServiceProvider = Provider<DocumentBackupService?>((ref) {
  final uid = ref.watch(firebaseUidProvider).valueOrNull;
  if (uid == null) return null;
  return DocumentBackupService(
    repository: ref.watch(documentRepositoryProvider),
    storage: ref.watch(documentCloudStorageProvider),
    uid: uid,
    documentsDir: () async => p.join((await getApplicationDocumentsDirectory()).path, 'documents'),
  );
});
