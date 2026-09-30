import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/document_repository.dart';
import '../domain/farm_document.dart' as domain;

const _table = 'farm_documents';

class LocalDocumentRepository implements DocumentRepository {
  LocalDocumentRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.FarmDocument>> watchDocuments() {
    final query = _db.select(_db.farmDocuments)
      ..where((d) => d.deletedAt.isNull())
      ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<domain.FarmDocument?> getDocument(String id) async {
    final row = await (_db.select(_db.farmDocuments)..where((d) => d.id.equals(id) & d.deletedAt.isNull()))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> addDocument(domain.FarmDocument document) async {
    final now = DateTime.now();
    final id = document.id.isEmpty ? newId() : document.id;
    await _db.into(_db.farmDocuments).insert(
          FarmDocumentsCompanion.insert(
            id: id,
            farmId: Value(document.farmId),
            category: document.category.name,
            title: document.title,
            localPath: document.localPath,
            mimeType: document.mimeType,
            sizeBytes: Value(document.sizeBytes),
            cloudPath: Value(document.cloudPath),
            createdAt: document.createdAt,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> setCloudPath(String id, String? cloudPath) async {
    await (_db.update(_db.farmDocuments)..where((d) => d.id.equals(id))).write(
      FarmDocumentsCompanion(
        cloudPath: Value(cloudPath),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'update');
  }

  @override
  Future<void> setLocalPath(String id, String localPath) async {
    await (_db.update(_db.farmDocuments)..where((d) => d.id.equals(id))).write(
      FarmDocumentsCompanion(localPath: Value(localPath), updatedAt: Value(DateTime.now())),
    );
    // Local-only change: the path is this phone's and is never meaningful elsewhere.
  }

  @override
  Future<void> deleteDocument(String id) async {
    await (_db.update(_db.farmDocuments)..where((d) => d.id.equals(id))).write(
      FarmDocumentsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'delete');
  }

  domain.FarmDocument _toDomain(FarmDocument row) => domain.FarmDocument(
        id: row.id,
        farmId: row.farmId,
        category: domain.DocumentCategory.fromName(row.category),
        title: row.title,
        localPath: row.localPath,
        mimeType: row.mimeType,
        sizeBytes: row.sizeBytes,
        createdAt: row.createdAt,
        cloudPath: row.cloudPath,
      );
}
