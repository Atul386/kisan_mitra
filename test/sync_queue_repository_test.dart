import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';

void main() {
  late AppDatabase db;
  late SyncQueueRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SyncQueueRepository(db);
  });

  tearDown(() => db.close());

  test('enqueue increases the pending count and nextBatch returns it in order', () async {
    expect(await repo.watchPendingCount().first, 0);

    await repo.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    await repo.enqueue(table: 'expenses', entityId: 'e1', operation: 'create');

    expect(await repo.watchPendingCount().first, 2);
    final batch = await repo.nextBatch();
    expect(batch.map((e) => e.entityTable), ['farms', 'expenses']);
  });

  test('remove drops a specific item and decreases the count', () async {
    await repo.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    final [item] = await repo.nextBatch();

    await repo.remove(item.queueId);

    expect(await repo.watchPendingCount().first, 0);
  });

  test('recordFailure increments retryCount and records the error message', () async {
    await repo.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    final [item] = await repo.nextBatch();

    await repo.recordFailure(item.queueId, 'network unreachable');
    final [updated] = await repo.nextBatch();

    expect(updated.retryCount, 1);
    expect(updated.lastError, 'network unreachable');
  });
}
