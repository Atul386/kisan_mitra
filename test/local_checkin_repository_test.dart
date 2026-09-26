import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/crop_health/data/local_checkin_repository.dart';
import 'package:kisan_mitra/features/crop_health/domain/daily_checkin.dart';

void main() {
  late AppDatabase db;
  late LocalCheckinRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalCheckinRepository(db, SyncQueueRepository(db));
  });

  tearDown(() => db.close());

  test('checking in twice the same day corrects the entry instead of duplicating it', () async {
    await repo.saveCheckin(
      DailyCheckin(id: '', farmId: 'farm1', date: DateTime.now(), healthStatus: CheckinHealth.good),
    );
    var checkin = await repo.watchTodayCheckin('farm1').first;
    expect(checkin?.healthStatus, CheckinHealth.good);

    await repo.saveCheckin(
      DailyCheckin(
        id: '',
        farmId: 'farm1',
        date: DateTime.now(),
        healthStatus: CheckinHealth.problem,
        concern: CheckinConcern.pest,
        note: 'Spotted aphids',
      ),
    );
    checkin = await repo.watchTodayCheckin('farm1').first;
    expect(checkin?.healthStatus, CheckinHealth.problem);
    expect(checkin?.concern, CheckinConcern.pest);
    expect(checkin?.note, 'Spotted aphids');
  });

  test('no check-in returns null', () async {
    final checkin = await repo.watchTodayCheckin('farm-with-no-checkin').first;
    expect(checkin, isNull);
  });
}
