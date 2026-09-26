import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/farm.dart' as domain;
import '../domain/farm_repository.dart';

const _table = 'farms';

class LocalFarmRepository implements FarmRepository {
  LocalFarmRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.Farm>> watchFarms(String userId) {
    final query = _db.select(_db.farms)
      ..where((f) => f.userId.equals(userId) & f.deletedAt.isNull());
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<domain.Farm?> getFarm(String farmId) async {
    final row =
        await (_db.select(_db.farms)..where((f) => f.id.equals(farmId))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> addFarm(domain.Farm farm) async {
    final now = DateTime.now();
    final id = farm.id.isEmpty ? newId() : farm.id;
    await _db.into(_db.farms).insert(
          FarmsCompanion.insert(
            id: id,
            userId: farm.userId,
            name: farm.name,
            area: farm.area,
            areaUnit: farm.areaUnit.name,
            country: Value(farm.country),
            state: Value(farm.state),
            district: Value(farm.district),
            village: Value(farm.village),
            soilType: Value(farm.soilType),
            irrigationType: Value(farm.irrigationType),
            latitude: Value(farm.latitude),
            longitude: Value(farm.longitude),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> updateFarm(domain.Farm farm) async {
    await (_db.update(_db.farms)..where((f) => f.id.equals(farm.id))).write(
      FarmsCompanion(
        name: Value(farm.name),
        area: Value(farm.area),
        areaUnit: Value(farm.areaUnit.name),
        country: Value(farm.country),
        state: Value(farm.state),
        district: Value(farm.district),
        village: Value(farm.village),
        soilType: Value(farm.soilType),
        irrigationType: Value(farm.irrigationType),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: farm.id, operation: 'update');
  }

  @override
  Future<void> setLocation({
    required String farmId,
    required double latitude,
    required double longitude,
  }) async {
    await (_db.update(_db.farms)..where((f) => f.id.equals(farmId))).write(
      FarmsCompanion(
        latitude: Value(latitude),
        longitude: Value(longitude),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: farmId, operation: 'update');
  }

  @override
  Future<void> deleteFarm(String farmId) async {
    await (_db.update(_db.farms)..where((f) => f.id.equals(farmId))).write(
      FarmsCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: farmId, operation: 'delete');
  }

  domain.Farm _toDomain(Farm row) => domain.Farm(
        id: row.id,
        userId: row.userId,
        name: row.name,
        area: row.area,
        areaUnit: domain.AreaUnit.values.firstWhere(
          (u) => u.name == row.areaUnit,
          orElse: () => domain.AreaUnit.acre,
        ),
        country: row.country,
        state: row.state,
        district: row.district,
        village: row.village,
        soilType: row.soilType,
        irrigationType: row.irrigationType,
        latitude: row.latitude,
        longitude: row.longitude,
      );
}
