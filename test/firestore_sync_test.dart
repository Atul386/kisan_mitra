import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/database/tables.dart';
import 'package:kisan_mitra/core/sync/cloud_store.dart';
import 'package:kisan_mitra/core/sync/firestore_restore.dart';
import 'package:kisan_mitra/core/sync/firestore_sync_handler.dart';
import 'package:kisan_mitra/core/sync/firestore_sync_specs.dart';
import 'package:kisan_mitra/core/sync/sync_engine.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/core/sync/sync_reconciler.dart';
import 'package:kisan_mitra/features/crop/data/local_season_repository.dart';
import 'package:kisan_mitra/features/crop/domain/season.dart' as crop;
import 'package:kisan_mitra/features/diary/data/local_crop_activity_repository.dart';
import 'package:kisan_mitra/features/diary/domain/crop_activity.dart' as diary;
import 'package:kisan_mitra/features/expenses/data/local_expense_repository.dart';
import 'package:kisan_mitra/features/expenses/domain/expense.dart' as expense;
import 'package:kisan_mitra/features/farm/data/local_farm_repository.dart';
import 'package:kisan_mitra/features/farm/domain/farm.dart' as farm;
import 'package:kisan_mitra/features/reminders/data/local_reminder_repository.dart';
import 'package:kisan_mitra/features/reminders/domain/reminder.dart' as reminder;

const uid = 'uid-1';

/// Behaves like the cloud for sync purposes: documents keyed by path.
class InMemoryCloudStore implements CloudStore {
  final docs = <String, Json>{};

  @override
  Future<void> set(List<String> docPath, Json data) async => docs[docPath.join('/')] = Map.of(data);

  @override
  Future<Json?> get(List<String> docPath) async => docs[docPath.join('/')];

  @override
  Future<List<Json>> list(List<String> collectionPath) async {
    final prefix = '${collectionPath.join('/')}/';
    return [
      for (final e in docs.entries)
        if (e.key.startsWith(prefix) && !e.key.substring(prefix.length).contains('/')) e.value,
    ];
  }
}

void main() {
  // Some tests open a second in-memory database to play the "new phone".
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late SyncQueueRepository queue;
  late InMemoryCloudStore store;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = SyncQueueRepository(db);
    store = InMemoryCloudStore();
  });

  tearDown(() => db.close());

  SyncEngine engine() => SyncEngine(queue, handlers: {
        for (final s in kSyncSpecs) s.queueName: FirestoreSyncHandler(spec: s, db: db, store: store, uid: uid),
      });

  Future<void> seed() async {
    await LocalFarmRepository(db, queue).addFarm(const farm.Farm(
      id: 'f1',
      userId: uid,
      name: 'Home field',
      area: 5,
      areaUnit: farm.AreaUnit.acre,
      state: 'Maharashtra',
      waterSource: 'well',
      latitude: 19.99,
      longitude: 73.78,
    ));
    await LocalSeasonRepository(db, queue).addSeason(crop.Season(
      id: 's1',
      farmId: 'f1',
      cropId: 'onion',
      cropName: 'Onion',
      sowingDate: DateTime(2026, 8, 1),
      expectedHarvestDate: DateTime(2026, 12, 1),
      notes: 'nursery first',
    ));
    await LocalCropActivityRepository(db, queue).addActivity(diary.CropActivity(
      id: 'a1',
      farmId: 'f1',
      seasonId: 's1',
      type: diary.ActivityType.irrigation,
      date: DateTime(2026, 8, 20),
      notes: 'drip 2h',
    ));
    await LocalExpenseRepository(db, queue).addExpense(expense.Expense(
      id: 'e1',
      farmId: 'f1',
      seasonId: 's1',
      amount: 1500,
      category: expense.ExpenseCategory.seeds,
      date: DateTime(2026, 8, 2),
    ));
    await LocalReminderRepository(db, queue).addReminder(reminder.Reminder(
      id: 'r1',
      title: 'Water',
      scheduledFor: DateTime(2026, 10, 2, 7),
      repeat: reminder.ReminderRepeat.weekly,
    ));
  }

  test('pushing writes each record at the documented Firestore path', () async {
    await seed();
    await engine().drain();

    bool exists(String path) => store.docs.containsKey(path);
    expect(exists('users/$uid/farms/f1'), isTrue);
    expect(exists('users/$uid/farms/f1/crops/s1'), isTrue);
    expect(exists('users/$uid/farms/f1/crops/s1/activities/a1'), isTrue);
    expect(exists('users/$uid/expenses/e1'), isTrue);
    expect(exists('users/$uid/reminders/r1'), isTrue);

    final farmDoc = store.docs['users/$uid/farms/f1']!;
    expect(farmDoc['name'], 'Home field');
    expect(farmDoc['waterSource'], 'well');
    expect(farmDoc.containsKey('syncStatus'), isFalse, reason: 'local bookkeeping must not be uploaded');
  });

  test('a successful push empties the queue and marks rows synced', () async {
    await seed();
    await engine().drain();

    expect(await queue.nextBatch(limit: 100), isEmpty);
    final rows = await db.select(db.farms).get();
    expect(rows.single.syncStatus, SyncStatus.synced);
    expect((await db.select(db.cropActivities).get()).single.syncStatus, SyncStatus.synced);
  });

  test('offline: items stay queued and nothing is lost when there is no handler', () async {
    await seed();
    await SyncEngine(queue).drain(); // no Firebase user => no handlers
    expect(await queue.nextBatch(limit: 100), isNotEmpty);
    expect((await db.select(db.farms).get()).single.syncStatus, SyncStatus.pendingCreate);
  });

  test('a deleted record syncs as a tombstone, so other phones learn about it', () async {
    await seed();
    await engine().drain();
    await LocalCropActivityRepository(db, queue).deleteActivity('a1');
    await engine().drain();

    final doc = store.docs['users/$uid/farms/f1/crops/s1/activities/a1']!;
    expect(doc['deletedAt'], isNotNull);
  });

  test('editing after a sync pushes the new version', () async {
    await seed();
    await engine().drain();
    await LocalSeasonRepository(db, queue).updateDetails('s1', notes: 'changed', variety: 'Red');
    await engine().drain();

    final doc = store.docs['users/$uid/farms/f1/crops/s1']!;
    expect(doc['notes'], 'changed');
    expect(doc['variety'], 'Red');
  });

  test('a row edited during the push is not wrongly marked synced', () async {
    await seed();
    final spec = kSyncSpecsByQueueName['expenses']!;
    final handler = FirestoreSyncHandler(spec: spec, db: db, store: store, uid: uid);

    final before = (await spec.load(db, 'e1'))!;
    await handler.push(entityId: 'e1', operation: 'create');
    expect((await db.select(db.expenses).get()).single.syncStatus, SyncStatus.synced);

    // Simulate an edit that lands with a newer updated_at, then a stale push
    // that only knew the old version.
    await (db.update(db.expenses)..where((e) => e.id.equals('e1'))).write(ExpensesCompanion(
      amount: const Value(2000),
      updatedAt: Value(DateTime.fromMillisecondsSinceEpoch((before['updatedAt'] as int) + 5000)),
      syncStatus: const Value(SyncStatus.pendingUpdate),
    ));
    await db.customStatement(
      "UPDATE expenses SET sync_status = 'synced' WHERE id = ? AND updated_at = ?",
      ['e1', (before['updatedAt'] as int) ~/ 1000],
    );
    expect((await db.select(db.expenses).get()).single.syncStatus, SyncStatus.pendingUpdate);
  });

  group('restore (login on a new phone)', () {
    test('everything pushed from one phone comes back on another, identical', () async {
      await seed();
      await engine().drain();

      final fresh = AppDatabase(NativeDatabase.memory());
      addTearDown(fresh.close);
      final written = await FirestoreRestoreService(db: fresh, store: store, uid: uid).restoreAll();
      expect(written, greaterThanOrEqualTo(5));

      final f = (await fresh.select(fresh.farms).get()).single;
      expect(f.name, 'Home field');
      expect(f.waterSource, 'well');
      expect(f.latitude, 19.99);
      expect(f.syncStatus, SyncStatus.synced, reason: 'restored rows must not be re-uploaded');

      final s = (await fresh.select(fresh.seasons).get()).single;
      expect(s.cropName, 'Onion');
      expect(s.expectedHarvestDate, DateTime(2026, 12, 1));
      expect(s.notes, 'nursery first');

      final a = (await fresh.select(fresh.cropActivities).get()).single;
      expect(a.type, 'irrigation');
      expect(a.notes, 'drip 2h');
      expect(a.date, DateTime(2026, 8, 20));

      expect((await fresh.select(fresh.expenses).get()).single.amount, 1500);
      final r = (await fresh.select(fresh.localReminders).get()).single;
      expect(r.repeatRule, 'weekly');
      expect(r.scheduledFor, DateTime(2026, 10, 2, 7));
    });

    test('restoring twice does not duplicate or rewrite anything', () async {
      await seed();
      await engine().drain();
      final fresh = AppDatabase(NativeDatabase.memory());
      addTearDown(fresh.close);
      final service = FirestoreRestoreService(db: fresh, store: store, uid: uid);
      await service.restoreAll();
      expect(await service.restoreAll(), 0);
      expect(await fresh.select(fresh.farms).get(), hasLength(1));
    });

    test('unsent local edits are never overwritten by older cloud data', () async {
      await seed();
      await engine().drain();
      // Local edit that has not been pushed yet.
      await LocalSeasonRepository(db, queue).updateDetails('s1', notes: 'local only');

      await FirestoreRestoreService(db: db, store: store, uid: uid).restoreAll();
      expect((await db.select(db.seasons).get()).single.notes, 'local only');
    });

    test('a newer cloud copy replaces an older synced local copy', () async {
      await seed();
      await engine().drain();
      final cloud = store.docs['users/$uid/expenses/e1']!;
      store.docs['users/$uid/expenses/e1'] = {...cloud, 'amount': 9999.0, 'updatedAt': (cloud['updatedAt'] as int) + 60000};

      await FirestoreRestoreService(db: db, store: store, uid: uid).restoreAll();
      expect((await db.select(db.expenses).get()).single.amount, 9999);
    });

    test('a deleted record stays deleted after restore', () async {
      await seed();
      await LocalCropActivityRepository(db, queue).deleteActivity('a1');
      await engine().drain();

      final fresh = AppDatabase(NativeDatabase.memory());
      addTearDown(fresh.close);
      await FirestoreRestoreService(db: fresh, store: store, uid: uid).restoreAll();
      final visible = await LocalCropActivityRepository(fresh, SyncQueueRepository(fresh)).watchActivities('s1').first;
      expect(visible, isEmpty);
    });

    test('one farmer never sees another farmer\'s data', () async {
      await seed();
      await engine().drain();
      final fresh = AppDatabase(NativeDatabase.memory());
      addTearDown(fresh.close);
      final written = await FirestoreRestoreService(db: fresh, store: store, uid: 'someone-else').restoreAll();
      expect(written, 0);
      expect(await fresh.select(fresh.farms).get(), isEmpty);
    });
  });

  group('requeueUnsynced', () {
    test('queues rows that lost their queue entry, and nothing else', () async {
      await seed();
      await engine().drain(); // everything synced, queue empty
      expect(await requeueUnsynced(db, queue), 0);

      // A row that is pending but whose queue item was dropped after failures.
      await (db.update(db.expenses)..where((e) => e.id.equals('e1')))
          .write(const ExpensesCompanion(syncStatus: Value(SyncStatus.pendingUpdate)));
      expect(await requeueUnsynced(db, queue), 1);
      final items = await queue.nextBatch();
      expect(items.single.entityTable, 'expenses');
      expect(items.single.entityId, 'e1');

      // Already queued: not queued twice.
      expect(await requeueUnsynced(db, queue), 0);
    });

    test('guest data created before sign-in is uploaded after sign-in', () async {
      await seed();
      await db.delete(db.syncQueueItems).go(); // simulate an old install / dropped queue
      expect(await requeueUnsynced(db, queue), greaterThanOrEqualTo(5));
      await engine().drain();
      expect(store.docs.containsKey('users/$uid/farms/f1'), isTrue);
    });
  });

  test('every queue table name used by the repositories has a sync spec', () {
    const used = [
      'users', 'farms', 'seasons', 'crop_activities', 'expenses', 'local_reminders', 'farm_documents',
      'soil_reports', 'tasks', 'irrigation_logs', 'fertilizer_logs', 'spray_logs', 'daily_checkins',
      'mandi_price_logs',
    ];
    for (final name in used) {
      expect(kSyncSpecsByQueueName.containsKey(name), isTrue, reason: name);
    }
  });
}
