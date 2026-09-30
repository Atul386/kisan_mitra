import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/documents/data/document_backup_service.dart';
import 'package:kisan_mitra/features/documents/data/document_cloud_storage.dart';
import 'package:kisan_mitra/features/documents/data/local_document_repository.dart';
import 'package:kisan_mitra/features/documents/domain/farm_document.dart';

class InMemoryStorage implements DocumentCloudStorage {
  final files = <String, List<int>>{};
  bool failUploads = false;

  @override
  Future<String> upload({
    required String uid,
    required String documentId,
    required String localPath,
    required String mimeType,
  }) async {
    if (failUploads) throw const SocketException('offline');
    final path = 'users/$uid/documents/$documentId.${FirebaseDocumentCloudStorage.extensionFor(mimeType)}';
    files[path] = await File(localPath).readAsBytes();
    return path;
  }

  @override
  Future<void> download({required String cloudPath, required String toLocalPath}) async {
    final bytes = files[cloudPath];
    if (bytes == null) throw StateError('not in cloud');
    await File(toLocalPath).writeAsBytes(bytes);
  }

  @override
  Future<void> delete(String cloudPath) async => files.remove(cloudPath);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late LocalDocumentRepository repo;
  late InMemoryStorage storage;
  late Directory tmp;
  late DocumentBackupService service;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalDocumentRepository(db, SyncQueueRepository(db));
    storage = InMemoryStorage();
    tmp = await Directory.systemTemp.createTemp('locker_test');
    service = DocumentBackupService(
      repository: repo,
      storage: storage,
      uid: 'uid-1',
      documentsDir: () async => '${tmp.path}/restored',
    );
  });

  tearDown(() async {
    await db.close();
    await tmp.delete(recursive: true);
  });

  Future<FarmDocument> addDoc(String id, {String mime = 'application/pdf', List<int> bytes = const [1, 2, 3]}) async {
    final file = File('${tmp.path}/$id.src')..writeAsBytesSync(bytes);
    final doc = FarmDocument(
      id: id,
      category: DocumentCategory.extract712,
      title: 'Doc $id',
      localPath: file.path,
      mimeType: mime,
      sizeBytes: bytes.length,
      createdAt: DateTime(2026, 9, 1),
    );
    await repo.addDocument(doc);
    return doc;
  }

  test('backing up uploads to the user\'s own folder and records the cloud path', () async {
    final doc = await addDoc('d1');
    await service.backUp(doc);

    expect(storage.files.keys, ['users/uid-1/documents/d1.pdf']);
    final saved = (await repo.getDocument('d1'))!;
    expect(saved.cloudPath, 'users/uid-1/documents/d1.pdf');
    expect(saved.isBackedUp, isTrue);
  });

  test('image types keep the right extension in the cloud', () async {
    final png = await addDoc('p1', mime: 'image/png');
    final jpg = await addDoc('j1', mime: 'image/jpeg');
    await service.backUp(png);
    await service.backUp(jpg);
    expect(storage.files.keys, containsAll(['users/uid-1/documents/p1.png', 'users/uid-1/documents/j1.jpg']));
  });

  test('a failed upload leaves the local document untouched and not marked backed up', () async {
    final doc = await addDoc('d1');
    storage.failUploads = true;
    await expectLater(service.backUp(doc), throwsA(isA<SocketException>()));

    final saved = (await repo.getDocument('d1'))!;
    expect(saved.isBackedUp, isFalse);
    expect(File(saved.localPath).existsSync(), isTrue);
  });

  test('a file that is already on the phone is used as-is', () async {
    final doc = await addDoc('d1');
    expect(await service.ensureLocalFile(doc), doc.localPath);
    expect(storage.files, isEmpty);
  });

  test('a document restored from another phone is downloaded on first use', () async {
    final original = await addDoc('d1', bytes: [9, 8, 7, 6]);
    await service.backUp(original);
    final backedUp = (await repo.getDocument('d1'))!;

    // Simulate the record arriving on a new phone: same row, but the file
    // path points at a place that does not exist here.
    await repo.setLocalPath('d1', '/old-phone/doc.pdf');
    final restored = (await repo.getDocument('d1'))!;
    expect(File(restored.localPath).existsSync(), isFalse);
    expect(restored.cloudPath, backedUp.cloudPath);

    final path = await service.ensureLocalFile(restored);
    expect(path, isNotNull);
    expect(File(path!).readAsBytesSync(), [9, 8, 7, 6]);
    expect(path.endsWith('.pdf'), isTrue);
    expect((await repo.getDocument('d1'))!.localPath, path, reason: 'the row now points at the downloaded file');
  });

  test('a missing file with no cloud copy cannot be recovered', () async {
    await addDoc('d1');
    await repo.setLocalPath('d1', '/gone/doc.pdf');
    expect(await service.ensureLocalFile((await repo.getDocument('d1'))!), isNull);
  });

  test('deleting removes the cloud copy too, and works for never-backed-up documents', () async {
    final a = await addDoc('a');
    await addDoc('b');
    await service.backUp(a);
    expect(storage.files, hasLength(1));

    await service.removeCloudCopy((await repo.getDocument('a'))!);
    expect(storage.files, isEmpty);
    await service.removeCloudCopy((await repo.getDocument('b'))!); // nothing to remove; must not throw
  });
}
