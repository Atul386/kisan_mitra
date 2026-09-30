import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/database/app_database.dart' show AppDatabase;
import 'package:kisan_mitra/core/notifications/notification_service.dart';
import 'package:kisan_mitra/core/services/link_launcher.dart';
import 'package:kisan_mitra/core/sync/sync_queue_repository.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/advisories/data/advisory_content.dart';
import 'package:kisan_mitra/features/advisories/presentation/schemes_screen.dart';
import 'package:kisan_mitra/features/dashboard/dashboard_providers.dart';
import 'package:kisan_mitra/features/diary/data/local_crop_activity_repository.dart';
import 'package:kisan_mitra/features/diary/domain/crop_activity.dart';
import 'package:kisan_mitra/features/farm/data/local_farm_repository.dart';
import 'package:kisan_mitra/features/farm/domain/farm.dart';
import 'package:kisan_mitra/features/reminders/data/local_reminder_repository.dart';
import 'package:kisan_mitra/features/reminders/domain/reminder.dart';
import 'package:kisan_mitra/features/reminders/reminder_providers.dart';
import 'package:kisan_mitra/features/soil/presentation/soil_screen.dart';
import 'package:kisan_mitra/features/soil/soil_providers.dart';
import 'package:kisan_mitra/features/soil/domain/soil_report.dart';
import 'package:kisan_mitra/features/weather/domain/weather_snapshot.dart';
import 'package:kisan_mitra/features/weather/presentation/weather_screen.dart';
import 'package:kisan_mitra/features/weather/weather_providers.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingLauncher implements LinkLauncher {
  final opened = <String>[];
  @override
  Future<bool> openWebsite(String url) async {
    opened.add(url);
    return true;
  }

  @override
  Future<bool> dial(String phoneNumber) async => true;
}

class FakeNotifications implements NotificationService {
  final scheduled = <int>[];
  @override
  Future<void> scheduleOneOff({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    DateTimeComponents? repeat,
  }) async => scheduled.add(id);

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

Future<void> pumpApp(WidgetTester tester, Widget home, List<Override> overrides) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = const Size(720, 4000);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs), ...overrides],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('database upgrade to v5', () {
    const syncCols = 'id TEXT NOT NULL PRIMARY KEY, created_at INTEGER NOT NULL, updated_at INTEGER NOT NULL, '
        "deleted_at INTEGER, sync_status TEXT NOT NULL DEFAULT 'pendingCreate'";

    Future<Set<String>> columns(AppDatabase db, String table) async {
      final rows = await db.customSelect('PRAGMA table_info($table)').get();
      return {for (final r in rows) r.read<String>('name')};
    }

    test('an old v3 install upgrades without a duplicate-column error and keeps its data', () async {
      final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
        raw.execute('CREATE TABLE local_users ($syncCols, name TEXT NOT NULL DEFAULT \'\', phone TEXT, language TEXT NOT NULL DEFAULT \'en\', state TEXT, district TEXT, village TEXT, is_guest INTEGER NOT NULL DEFAULT 1)');
        raw.execute('CREATE TABLE farms ($syncCols, user_id TEXT NOT NULL, name TEXT NOT NULL, area REAL NOT NULL, area_unit TEXT NOT NULL, country TEXT, state TEXT, district TEXT, village TEXT, soil_type TEXT, irrigation_type TEXT, latitude REAL, longitude REAL)');
        raw.execute('CREATE TABLE seasons ($syncCols, farm_id TEXT NOT NULL, crop_id TEXT NOT NULL, crop_name TEXT NOT NULL, variety TEXT, sowing_date INTEGER NOT NULL, area REAL, area_unit TEXT, season_name TEXT, status TEXT NOT NULL DEFAULT \'active\')');
        raw.execute('CREATE TABLE local_reminders ($syncCols, title TEXT NOT NULL, body TEXT, scheduled_for INTEGER NOT NULL, related_type TEXT, related_id TEXT, fired INTEGER NOT NULL DEFAULT 0)');
        raw.execute("INSERT INTO farms (id, created_at, updated_at, user_id, name, area, area_unit) VALUES ('f1', 1, 1, 'u1', 'Old farm', 4.0, 'acre')");
        raw.execute("INSERT INTO local_reminders (id, created_at, updated_at, title, scheduled_for) VALUES ('r1', 1, 1, 'Old reminder', 100)");
        raw.execute('PRAGMA user_version = 3');
      }));
      addTearDown(db.close);

      expect((await db.select(db.farms).get()).single.name, 'Old farm', reason: 'data survives the upgrade');
      final farmCols = await columns(db, 'farms');
      expect(farmCols, containsAll(['water_source', 'taluka']));
      expect(await columns(db, 'local_users'), contains('taluka'));
      expect(await columns(db, 'seasons'), containsAll(['expected_harvest_date', 'notes']));
      expect(await columns(db, 'local_reminders'), containsAll(['category', 'repeat_rule', 'completed', 'crop_id', 'notification_enabled']));
      expect(await columns(db, 'crop_activities'), contains('cost'));

      // Old reminder gets the defaults: notifications on, no crop.
      final r = (await db.select(db.localReminders).get()).single;
      expect(r.notificationEnabled, isTrue);
      expect(r.cropId, isNull);
      expect(r.category, 'custom');
    });

    test('a v4 install (diary table without cost) upgrades by adding only the new columns', () async {
      final db = AppDatabase(NativeDatabase.memory(setup: (raw) {
        raw.execute('CREATE TABLE local_users ($syncCols, name TEXT NOT NULL DEFAULT \'\', phone TEXT, language TEXT NOT NULL DEFAULT \'en\', state TEXT, district TEXT, village TEXT, is_guest INTEGER NOT NULL DEFAULT 1)');
        raw.execute('CREATE TABLE farms ($syncCols, user_id TEXT NOT NULL, name TEXT NOT NULL, area REAL NOT NULL, area_unit TEXT NOT NULL, country TEXT, state TEXT, district TEXT, village TEXT, soil_type TEXT, irrigation_type TEXT, water_source TEXT, latitude REAL, longitude REAL)');
        raw.execute('CREATE TABLE local_reminders ($syncCols, title TEXT NOT NULL, body TEXT, scheduled_for INTEGER NOT NULL, related_type TEXT, related_id TEXT, fired INTEGER NOT NULL DEFAULT 0, category TEXT NOT NULL DEFAULT \'custom\', repeat_rule TEXT NOT NULL DEFAULT \'none\', completed INTEGER NOT NULL DEFAULT 0)');
        raw.execute('CREATE TABLE crop_activities ($syncCols, farm_id TEXT NOT NULL, season_id TEXT NOT NULL, type TEXT NOT NULL, date INTEGER NOT NULL, notes TEXT, photo_path TEXT)');
        raw.execute("INSERT INTO crop_activities (id, created_at, updated_at, farm_id, season_id, type, date) VALUES ('a1', 1, 1, 'f1', 's1', 'sowing', 100)");
        raw.execute('PRAGMA user_version = 4');
      }));
      addTearDown(db.close);

      final a = (await db.select(db.cropActivities).get()).single;
      expect(a.type, 'sowing');
      expect(a.cost, isNull);
      expect(await columns(db, 'crop_activities'), contains('cost'));
      expect(await columns(db, 'farms'), contains('taluka'));
      expect(await columns(db, 'local_reminders'), containsAll(['crop_id', 'notification_enabled']));
    });
  });

  group('taluka', () {
    test('is stored on a farm and can be edited', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = LocalFarmRepository(db, SyncQueueRepository(db));
      await repo.addFarm(const Farm(id: 'f1', userId: 'u1', name: 'Home', area: 5, areaUnit: AreaUnit.acre, taluka: 'Niphad', district: 'Nashik'));
      expect((await repo.getFarm('f1'))!.taluka, 'Niphad');

      await repo.updateFarm(const Farm(id: 'f1', userId: 'u1', name: 'Home', area: 5, areaUnit: AreaUnit.acre, taluka: 'Sinnar', district: 'Nashik'));
      expect((await repo.getFarm('f1'))!.taluka, 'Sinnar');
    });
  });

  group('diary cost', () {
    test('is saved, shown back, and can be changed or cleared', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = LocalCropActivityRepository(db, SyncQueueRepository(db));
      CropActivity a(double? cost) =>
          CropActivity(id: 'a1', farmId: 'f1', seasonId: 's1', type: ActivityType.fertilizer, date: DateTime(2026, 9, 1), cost: cost);

      await repo.addActivity(a(1250.5));
      expect((await repo.getActivity('a1'))!.cost, 1250.5);
      await repo.updateActivity(a(900));
      expect((await repo.getActivity('a1'))!.cost, 900);
      await repo.updateActivity(a(null));
      expect((await repo.getActivity('a1'))!.cost, isNull);
    });
  });

  group('reminders: crop link and notification switch', () {
    late AppDatabase db;
    late LocalReminderRepository repo;
    late FakeNotifications notifications;
    late ReminderActions actions;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = LocalReminderRepository(db, SyncQueueRepository(db));
      notifications = FakeNotifications();
      actions = ReminderActions(repo, notifications, now: () => DateTime(2026, 9, 30, 9));
    });

    tearDown(() => db.close());

    Reminder r({String? cropId, bool notify = true}) => Reminder(
          id: '',
          title: 'Spray onions',
          scheduledFor: DateTime(2026, 10, 2, 7),
          cropId: cropId,
          notificationEnabled: notify,
        );

    test('the linked crop is saved, and can be changed and removed', () async {
      await actions.add(r(cropId: 's1'));
      var saved = (await repo.watchReminders().first).single;
      expect(saved.cropId, 's1');

      await actions.update(saved.copyWith(cropId: 's2'));
      saved = (await repo.getReminder(saved.id))!;
      expect(saved.cropId, 's2');

      await actions.update(saved.copyWith(clearCrop: true));
      expect((await repo.getReminder(saved.id))!.cropId, isNull);
    });

    test('a reminder with notifications off is saved but never scheduled', () async {
      await actions.add(r(notify: false));
      expect(await repo.watchReminders().first, hasLength(1));
      expect(notifications.scheduled, isEmpty);
    });

    test('turning notifications on later schedules it; off again stops it', () async {
      await actions.add(r(notify: false));
      final saved = (await repo.watchReminders().first).single;

      await actions.update(saved.copyWith(notificationEnabled: true));
      expect(notifications.scheduled, hasLength(1));

      await actions.update((await repo.getReminder(saved.id))!.copyWith(notificationEnabled: false));
      expect(notifications.scheduled, hasLength(1), reason: 'not scheduled again');
      expect((await repo.getReminder(saved.id))!.notificationEnabled, isFalse);
    });

    test('notifications default to on', () async {
      await actions.add(r());
      expect((await repo.watchReminders().first).single.notificationEnabled, isTrue);
      expect(notifications.scheduled, hasLength(1));
    });
  });

  group('scheme search', () {
    test('matches names and text, ignores case, and needs every word', () {
      expect(searchSchemes(kSchemes, '').length, kSchemes.length);
      expect(searchSchemes(kSchemes, 'DRIP').map((s) => s.id), ['micro-irrigation']);
      expect(searchSchemes(kSchemes, 'mahadbt').map((s) => s.id), contains('mahadbt'));
      expect(searchSchemes(kSchemes, 'cold storage').map((s) => s.id), ['agri-infra']);
      expect(searchSchemes(kSchemes, 'drip warehouse'), isEmpty, reason: 'both words must match');
      expect(searchSchemes(kSchemes, '   '), hasLength(kSchemes.length));
      expect(searchSchemes(kSchemes, 'zzzz'), isEmpty);
    });

    testWidgets('typing filters the list and an unknown word shows the empty message', (tester) async {
      await pumpApp(tester, const SchemesScreen(), []);
      expect(find.textContaining('Farm mechanization'), findsWidgets);

      await tester.enterText(find.byType(TextField), 'drip');
      await tester.pumpAndSettle();
      expect(find.text('Micro irrigation (drip and sprinkler)'), findsOneWidget);
      expect(find.text('Farm mechanization'), findsNothing);

      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pumpAndSettle();
      expect(find.textContaining('No schemes match'), findsOneWidget);
    });
  });

  group('soil screen', () {
    const farm = Farm(id: 'f1', userId: 'u1', name: 'Home', area: 5, areaUnit: AreaUnit.acre, latitude: 19.99, longitude: 73.78);

    testWidgets('with no reports it still offers to find soil labs near the farm', (tester) async {
      final launcher = RecordingLauncher();
      await pumpApp(tester, const SoilScreen(), [
        linkLauncherProvider.overrideWithValue(launcher),
        primaryFarmProvider.overrideWithValue(farm),
        soilReportsProvider.overrideWith((ref) => Stream.value(const <SoilReport>[])),
      ]);
      await tester.tap(find.text('Find nearby soil testing labs'));
      await tester.pumpAndSettle();
      expect(launcher.opened.single, contains('soil+testing+laboratory+near+19.99%2C73.78'));
    });

    testWidgets('with reports the button is still there, next to the values', (tester) async {
      final launcher = RecordingLauncher();
      await pumpApp(tester, const SoilScreen(), [
        linkLauncherProvider.overrideWithValue(launcher),
        primaryFarmProvider.overrideWithValue(farm),
        soilReportsProvider.overrideWith(
          (ref) => Stream.value([SoilReport(id: 'r1', farmId: 'f1', date: DateTime(2026, 9, 1), ph: 6.8)]),
        ),
      ]);
      expect(find.text('6.8'), findsOneWidget);
      await tester.tap(find.text('Find nearby soil testing labs'));
      await tester.pumpAndSettle();
      expect(launcher.opened, hasLength(1));
    });
  });

  group('weather: rainfall and 16 days', () {
    testWidgets('shows rainfall today, 7 days first, and expands to 16', (tester) async {
      await pumpApp(tester, const WeatherScreen(), [
        currentWeatherProvider.overrideWith((ref) async => WeatherSnapshot.demo()),
        primaryFarmProvider.overrideWithValue(null),
      ]);

      expect(find.text('Rainfall today'), findsOneWidget);
      expect(find.text('7-Day Forecast'), findsOneWidget);
      expect(find.text('Show 16 days'), findsOneWidget);
      // Demo: day 3 has 12 mm expected.
      expect(find.text('12 mm'), findsOneWidget);

      await tester.ensureVisible(find.text('Show 16 days'));
      await tester.tap(find.text('Show 16 days'));
      await tester.pumpAndSettle();
      expect(find.text('16-Day Forecast'), findsOneWidget);
      expect(find.text('Show fewer days'), findsOneWidget);

      await tester.ensureVisible(find.text('Show fewer days'));
      await tester.tap(find.text('Show fewer days'));
      await tester.pumpAndSettle();
      expect(find.text('7-Day Forecast'), findsOneWidget);
    });

    test('demo data has 16 days with rainfall, and they survive the offline cache', () {
      final demo = WeatherSnapshot.demo();
      expect(demo.daily, hasLength(16));
      expect(demo.daily[4].rainMm, 26.0);
      final restored = WeatherSnapshot.fromJson(demo.toJson());
      expect(restored.daily, hasLength(16));
      expect(restored.daily[4].rainMm, 26.0);
    });
  });
}
