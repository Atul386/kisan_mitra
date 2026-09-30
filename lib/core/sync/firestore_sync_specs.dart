import 'package:drift/drift.dart';

import '../database/app_database.dart';

typedef Json = Map<String, dynamic>;

/// How one local table maps to Firestore. Everything the sync code needs to
/// know about a table lives here, so handlers, restore and reconciliation
/// stay generic.
class SyncTableSpec {
  const SyncTableSpec({
    required this.queueName,
    required this.sqlTable,
    required this.load,
    required this.upsert,
    required this.docPath,
  });

  /// Name used in `sync_queue_items.entity_table` (set by each repository).
  final String queueName;

  /// Actual SQLite table name.
  final String sqlTable;

  /// The row as JSON (dates as epoch milliseconds), or null if it is gone.
  final Future<Json?> Function(AppDatabase db, String id) load;

  /// Inserts or overwrites a row from JSON.
  final Future<void> Function(AppDatabase db, Json json) upsert;

  /// Firestore document path — alternating collection/document ids.
  final List<String> Function(String uid, Json json) docPath;
}

SyncTableSpec _spec<Tbl extends Table, Row extends Insertable<Row>>({
  required String queueName,
  required String sqlTable,
  required TableInfo<Tbl, Row> Function(AppDatabase db) table,
  required Row Function(Json json) fromJson,
  required List<String> Function(String uid, Json json) docPath,
}) {
  return SyncTableSpec(
    queueName: queueName,
    sqlTable: sqlTable,
    docPath: docPath,
    load: (db, id) async {
      final rows = await db
          .customSelect('SELECT * FROM $sqlTable WHERE id = ?', variables: [Variable<String>(id)], readsFrom: {table(db)})
          .get();
      if (rows.isEmpty) return null;
      return (table(db).map(rows.first.data) as DataClass).toJson();
    },
    upsert: (db, json) => db.into(table(db)).insertOnConflictUpdate(fromJson(json)),
  );
}

List<String> _flat(String uid, String collection, Json j) => ['users', uid, collection, '${j['id']}'];

/// Firestore layout (users/{uid}/...):
///   farms/{farmId}/crops/{cropId}/activities/{activityId}
///   expenses, reminders, documents, soilReports, ... as flat collections.
/// Deletes are synced as tombstones (`deletedAt` set), so other devices
/// learn about them and restore never resurrects a deleted record.
final List<SyncTableSpec> kSyncSpecs = [
  _spec<$LocalUsersTable, LocalUser>(
    queueName: 'users',
    sqlTable: 'local_users',
    table: (db) => db.localUsers,
    fromJson: LocalUser.fromJson,
    docPath: (uid, j) => ['users', uid],
  ),
  _spec<$FarmsTable, Farm>(
    queueName: 'farms',
    sqlTable: 'farms',
    table: (db) => db.farms,
    fromJson: Farm.fromJson,
    docPath: (uid, j) => ['users', uid, 'farms', '${j['id']}'],
  ),
  _spec<$SeasonsTable, Season>(
    queueName: 'seasons',
    sqlTable: 'seasons',
    table: (db) => db.seasons,
    fromJson: Season.fromJson,
    docPath: (uid, j) => ['users', uid, 'farms', '${j['farmId']}', 'crops', '${j['id']}'],
  ),
  _spec<$CropActivitiesTable, CropActivity>(
    queueName: 'crop_activities',
    sqlTable: 'crop_activities',
    table: (db) => db.cropActivities,
    fromJson: CropActivity.fromJson,
    docPath: (uid, j) => [
      'users', uid, 'farms', '${j['farmId']}', 'crops', '${j['seasonId']}', 'activities', '${j['id']}',
    ],
  ),
  _spec<$ExpensesTable, Expense>(
    queueName: 'expenses',
    sqlTable: 'expenses',
    table: (db) => db.expenses,
    fromJson: Expense.fromJson,
    docPath: (uid, j) => _flat(uid, 'expenses', j),
  ),
  _spec<$LocalRemindersTable, LocalReminder>(
    queueName: 'local_reminders',
    sqlTable: 'local_reminders',
    table: (db) => db.localReminders,
    fromJson: LocalReminder.fromJson,
    docPath: (uid, j) => _flat(uid, 'reminders', j),
  ),
  _spec<$FarmDocumentsTable, FarmDocument>(
    queueName: 'farm_documents',
    sqlTable: 'farm_documents',
    table: (db) => db.farmDocuments,
    fromJson: FarmDocument.fromJson,
    docPath: (uid, j) => _flat(uid, 'documents', j),
  ),
  _spec<$SoilReportsTable, SoilReport>(
    queueName: 'soil_reports',
    sqlTable: 'soil_reports',
    table: (db) => db.soilReports,
    fromJson: SoilReport.fromJson,
    docPath: (uid, j) => _flat(uid, 'soilReports', j),
  ),
  _spec<$FarmTasksTable, FarmTask>(
    queueName: 'tasks',
    sqlTable: 'farm_tasks',
    table: (db) => db.farmTasks,
    fromJson: FarmTask.fromJson,
    docPath: (uid, j) => _flat(uid, 'tasks', j),
  ),
  _spec<$IrrigationLogsTable, IrrigationLog>(
    queueName: 'irrigation_logs',
    sqlTable: 'irrigation_logs',
    table: (db) => db.irrigationLogs,
    fromJson: IrrigationLog.fromJson,
    docPath: (uid, j) => _flat(uid, 'irrigationLogs', j),
  ),
  _spec<$FertilizerLogsTable, FertilizerLog>(
    queueName: 'fertilizer_logs',
    sqlTable: 'fertilizer_logs',
    table: (db) => db.fertilizerLogs,
    fromJson: FertilizerLog.fromJson,
    docPath: (uid, j) => _flat(uid, 'fertilizerLogs', j),
  ),
  _spec<$SprayLogsTable, SprayLog>(
    queueName: 'spray_logs',
    sqlTable: 'spray_logs',
    table: (db) => db.sprayLogs,
    fromJson: SprayLog.fromJson,
    docPath: (uid, j) => _flat(uid, 'sprayLogs', j),
  ),
  _spec<$DailyCheckinsTable, DailyCheckin>(
    queueName: 'daily_checkins',
    sqlTable: 'daily_checkins',
    table: (db) => db.dailyCheckins,
    fromJson: DailyCheckin.fromJson,
    docPath: (uid, j) => _flat(uid, 'checkins', j),
  ),
  _spec<$MandiPriceLogsTable, MandiPriceLog>(
    queueName: 'mandi_price_logs',
    sqlTable: 'mandi_price_logs',
    table: (db) => db.mandiPriceLogs,
    fromJson: MandiPriceLog.fromJson,
    docPath: (uid, j) => _flat(uid, 'mandiPrices', j),
  ),
];

final Map<String, SyncTableSpec> kSyncSpecsByQueueName = {for (final s in kSyncSpecs) s.queueName: s};
