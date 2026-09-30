import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/features/crop/data/local_season_repository.dart';
import 'package:kisan_mitra/features/crop/domain/season.dart';
import 'package:kisan_mitra/features/diary/data/local_crop_activity_repository.dart';
import 'package:kisan_mitra/features/diary/domain/crop_activity.dart';

void main() {
  late AppDatabase db;
  late SyncQueueRepository queue;
  late LocalSeasonRepository seasons;
  late LocalCropActivityRepository diary;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = SyncQueueRepository(db);
    seasons = LocalSeasonRepository(db, queue);
    diary = LocalCropActivityRepository(db, queue);
  });

  tearDown(() => db.close());

  Season crop(String id, String name, DateTime sown, {String status = SeasonStatus.active}) =>
      Season(id: id, farmId: 'f1', cropId: name.toLowerCase(), cropName: name, sowingDate: sown, status: status);

  group('crops', () {
    test('a farm can hold several crops, newest sowing first, and each queues a sync', () async {
      await seasons.addSeason(crop('s1', 'Wheat', DateTime(2026, 1, 10)));
      await seasons.addSeason(crop('s2', 'Onion', DateTime(2026, 8, 1)));

      final all = await seasons.watchSeasons('f1').first;
      expect(all.map((s) => s.cropName), ['Onion', 'Wheat']);
      expect((await queue.nextBatch()).where((q) => q.entityTable == 'seasons'), hasLength(2));
    });

    test('new fields (expected harvest, notes) are saved and can be edited', () async {
      await seasons.addSeason(
        Season(
          id: 's1',
          farmId: 'f1',
          cropId: 'onion',
          cropName: 'Onion',
          sowingDate: DateTime(2026, 8, 1),
          expectedHarvestDate: DateTime(2026, 12, 1),
          notes: 'Nursery raised first',
        ),
      );
      var s = (await seasons.watchSeason('s1').first)!;
      expect(s.expectedHarvestDate, DateTime(2026, 12, 1));
      expect(s.notes, 'Nursery raised first');

      await seasons.updateDetails(
        's1',
        variety: 'Red',
        area: 2.5,
        expectedHarvestDate: DateTime(2026, 12, 15),
        notes: 'Updated',
      );
      s = (await seasons.watchSeason('s1').first)!;
      expect(s.variety, 'Red');
      expect(s.area, 2.5);
      expect(s.expectedHarvestDate, DateTime(2026, 12, 15));
      expect(s.notes, 'Updated');
    });

    test('harvested / completed crops stop being the active crop', () async {
      await seasons.addSeason(crop('s1', 'Onion', DateTime(2026, 8, 1)));
      expect((await seasons.watchActiveSeason('f1').first)?.id, 's1');

      await seasons.updateStatus('s1', SeasonStatus.harvested);
      expect(await seasons.watchActiveSeason('f1').first, isNull);
      expect((await seasons.watchSeason('s1').first)?.status, SeasonStatus.harvested);

      await seasons.updateStatus('s1', SeasonStatus.active);
      expect((await seasons.watchActiveSeason('f1').first)?.id, 's1');
    });

    test('deleting a crop hides it everywhere', () async {
      await seasons.addSeason(crop('s1', 'Onion', DateTime(2026, 8, 1)));
      await seasons.deleteSeason('s1');
      expect(await seasons.watchSeasons('f1').first, isEmpty);
      expect(await seasons.watchSeason('s1').first, isNull);
      expect(await seasons.watchActiveSeason('f1').first, isNull);
    });
  });

  group('crop diary', () {
    CropActivity act(String id, ActivityType type, DateTime date, {String season = 's1', String? notes}) =>
        CropActivity(id: id, farmId: 'f1', seasonId: season, type: type, date: date, notes: notes);

    test('entries are a timeline, newest first, and only for their own crop', () async {
      await diary.addActivity(act('a1', ActivityType.sowing, DateTime(2026, 8, 12)));
      await diary.addActivity(act('a2', ActivityType.irrigation, DateTime(2026, 8, 20)));
      await diary.addActivity(act('a3', ActivityType.fertilizer, DateTime(2026, 8, 27)));
      await diary.addActivity(act('x1', ActivityType.harvest, DateTime(2026, 9, 1), season: 'other'));

      final list = await diary.watchActivities('s1').first;
      expect(list.map((a) => a.type), [ActivityType.fertilizer, ActivityType.irrigation, ActivityType.sowing]);
    });

    test('an entry can be edited', () async {
      await diary.addActivity(act('a1', ActivityType.spray, DateTime(2026, 8, 12), notes: 'first'));
      await diary.updateActivity(
        act('a1', ActivityType.pestObservation, DateTime(2026, 8, 13), notes: 'aphids on leaves'),
      );

      final a = (await diary.getActivity('a1'))!;
      expect(a.type, ActivityType.pestObservation);
      expect(a.date, DateTime(2026, 8, 13));
      expect(a.notes, 'aphids on leaves');
      expect(await diary.watchActivities('s1').first, hasLength(1));
    });

    test('an entry can be deleted', () async {
      await diary.addActivity(act('a1', ActivityType.labour, DateTime(2026, 8, 12)));
      await diary.deleteActivity('a1');
      expect(await diary.watchActivities('s1').first, isEmpty);
      expect(await diary.getActivity('a1'), isNull);
    });

    test('every change is queued for sync in order', () async {
      await diary.addActivity(act('a1', ActivityType.sale, DateTime(2026, 9, 1)));
      await diary.updateActivity(act('a1', ActivityType.sale, DateTime(2026, 9, 2)));
      await diary.deleteActivity('a1');
      final ops = (await queue.nextBatch()).where((q) => q.entityTable == 'crop_activities').map((q) => q.operation);
      expect(ops, ['create', 'update', 'delete']);
    });

    test('an unknown stored type falls back to "other" instead of crashing', () {
      expect(ActivityType.fromName('from-a-future-version'), ActivityType.other);
    });
  });
}
