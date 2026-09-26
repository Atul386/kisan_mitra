import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/sync/sync_engine.dart';
import 'package:kisan_mitra/core/sync/sync_handler.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';

class _RecordingHandler implements SyncHandler {
  final pushed = <String>[];
  Object? throwOn;

  @override
  Future<void> push({required String entityId, required String operation}) async {
    if (throwOn == entityId) throw Exception('simulated failure');
    pushed.add('$operation:$entityId');
  }
}

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = SyncQueueRepository(db);
  });

  tearDown(() => db.close());

  test('with no handlers registered, queued items are left untouched', () async {
    await queue.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    final engine = SyncEngine(queue);

    await engine.drain();

    final remaining = await queue.nextBatch();
    expect(remaining, hasLength(1));
  });

  test('a registered handler drains and removes matching queue items', () async {
    final handler = _RecordingHandler();
    await queue.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    await queue.enqueue(table: 'farms', entityId: 'f1', operation: 'update');
    final engine = SyncEngine(queue, handlers: {'farms': handler});

    await engine.drain();

    expect(handler.pushed, ['create:f1', 'update:f1']);
    expect(await queue.nextBatch(), isEmpty);
  });

  test('items for unregistered tables stay queued while registered ones drain', () async {
    final handler = _RecordingHandler();
    await queue.enqueue(table: 'farms', entityId: 'f1', operation: 'create');
    await queue.enqueue(table: 'expenses', entityId: 'e1', operation: 'create');
    final engine = SyncEngine(queue, handlers: {'farms': handler});

    await engine.drain();

    expect(handler.pushed, ['create:f1']);
    final remaining = await queue.nextBatch();
    expect(remaining.map((r) => r.entityTable), ['expenses']);
  });

  test('a failing push increments retryCount and is eventually dropped', () async {
    final handler = _RecordingHandler()..throwOn = 'bad-item';
    await queue.enqueue(table: 'farms', entityId: 'bad-item', operation: 'create');
    final engine = SyncEngine(queue, handlers: {'farms': handler});

    for (var i = 0; i < 5; i++) {
      await engine.drain();
    }

    expect(await queue.nextBatch(), isEmpty, reason: 'gives up after max retries instead of retrying forever');
  });
}
