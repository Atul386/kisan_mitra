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
    SyncQueueItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

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
