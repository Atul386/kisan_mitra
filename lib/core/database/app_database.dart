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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(farms, farms.country);
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
