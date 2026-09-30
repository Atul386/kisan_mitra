import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/app/app.dart';
import 'package:kisan_mitra/core/database/app_database.dart';
import 'package:kisan_mitra/core/database/database_providers.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/weather/domain/weather_snapshot.dart';
import 'package:kisan_mitra/features/weather/weather_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    loader.addFont(Future.value(ByteData.sublistView(File(path).readAsBytesSync())));
  }
  await loader.load();
}

void main() {
  testWidgets('home preview', (tester) async {
    await loadFont('Roboto', ['/System/Library/Fonts/Supplemental/Arial.ttf', '/System/Library/Fonts/Supplemental/Arial Bold.ttf']);
    await loadFont('MaterialIcons', ['${Platform.environment['FLUTTER_ROOT'] ?? '/Users/abcom/Documents/development/flutter'}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf']);
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    final now = DateTime.now();
    SharedPreferences.setMockInitialValues({'app_language': 'en', 'current_user_id': 'u1'});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.runAsync(() async {
      await db.into(db.localUsers).insert(LocalUsersCompanion.insert(id: 'u1', createdAt: now, updatedAt: now, name: const Value('Ramesh')));
      await db.into(db.farms).insert(FarmsCompanion.insert(id: 'f1', userId: 'u1', name: 'Main Farm', area: 2.5, areaUnit: 'acre', createdAt: now, updatedAt: now, latitude: const Value(18.5), longitude: const Value(73.8)));
      await db.into(db.seasons).insert(SeasonsCompanion.insert(id: 's1', farmId: 'f1', cropId: 'soybean', cropName: 'Soybean', sowingDate: now.subtract(const Duration(days: 44)), createdAt: now, updatedAt: now));
    });
    await tester.pumpWidget(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(db),
        currentWeatherProvider.overrideWith((ref) async => WeatherSnapshot(
              temperatureCelsius: 28, humidityPercent: 68, windSpeedKmh: 12,
              rainProbabilityTodayPercent: 70, rainProbabilityTomorrowPercent: 40,
              fetchedAt: now, weatherCode: 2)),
      ],
      child: const KisanMitraApp(),
    ));
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        final ctx = tester.element(find.byType(MaterialApp));
        await precacheImage(const AssetImage('assets/images/dashbord.png'), ctx);
      });
      await tester.pump(const Duration(milliseconds: 200));
    }
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('home_preview.png'));
    await tester.pumpWidget(const SizedBox());
  });
}
