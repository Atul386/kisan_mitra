import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Local-first SQLite store (blueprint §7).
/// This is the source of truth for the UI; Firebase sync is layered on
/// top later and must never block reads/writes here.
@DriftDatabase(
  tables: [
    LocalUsers,
    Farms,
    Seasons,
    FarmTasks,
    Expenses,
    IrrigationLogs,
    FertilizerLogs,
    SprayLogs,
    DailyCheckins,
    MandiPriceLogs,
    LocalReminders,
    CropActivities,
    SoilReports,
    FarmDocuments,
    SyncQueueItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  /// Delete Account (§41): removes every row this device holds. The local
  /// database only ever contains this farmer's own data.
  Future<void> wipeAllData() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(farms, farms.country);
      }
      if (from < 3) {
        await m.addColumn(localUsers, localUsers.village);
        await m.addColumn(seasons, seasons.areaUnit);
        await m.addColumn(seasons, seasons.seasonName);
      }
      if (from < 4) {
        await m.addColumn(farms, farms.waterSource);
        await m.addColumn(seasons, seasons.expectedHarvestDate);
        await m.addColumn(seasons, seasons.notes);
        await m.addColumn(localReminders, localReminders.category);
        await m.addColumn(localReminders, localReminders.repeatRule);
        await m.addColumn(localReminders, localReminders.completed);
        await m.createTable(cropActivities);
        await m.createTable(soilReports);
        await m.createTable(farmDocuments);
      }
      if (from < 5) {
        await m.addColumn(localUsers, localUsers.taluka);
        await m.addColumn(farms, farms.taluka);
        // From v3 or older the table is created above from the current
        // definition, which already includes `cost`; only older v4 installs lack it.
        if (from >= 4) await m.addColumn(cropActivities, cropActivities.cost);
        await m.addColumn(localReminders, localReminders.cropId);
        await m.addColumn(localReminders, localReminders.notificationEnabled);
      }
    },
  );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'kisan_mitra.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
