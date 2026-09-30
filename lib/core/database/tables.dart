import 'package:drift/drift.dart';

/// Sync status shared by every syncable table.
/// See blueprint §8 (Sync Strategy).
class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(String fromDb) =>
      SyncStatus.values.firstWhere((e) => e.name == fromDb, orElse: () => SyncStatus.pendingCreate);

  @override
  String toSql(SyncStatus value) => value.name;
}

enum SyncStatus { synced, pendingCreate, pendingUpdate, pendingDelete, failed }

/// Mixin-like column set every syncable local table shares (§8).
mixin SyncableColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get syncStatus => text().map(const SyncStatusConverter()).withDefault(const Constant('pendingCreate'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// users/{uid} mirror (§10). For guest mode, id is a locally generated uuid.
class LocalUsers extends Table with SyncableColumns {
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get phone => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('en'))();
  TextColumn get state => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get taluka => text().nullable()();
  TextColumn get village => text().nullable()();
  BoolColumn get isGuest => boolean().withDefault(const Constant(true))();
}

/// users/{uid}/farms/{farmId} (§10, §13).
class Farms extends Table with SyncableColumns {
  TextColumn get userId => text()();
  TextColumn get name => text()();
  RealColumn get area => real()();
  TextColumn get areaUnit => text()();
  TextColumn get country => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get taluka => text().nullable()();
  TextColumn get village => text().nullable()();
  TextColumn get soilType => text().nullable()();
  TextColumn get irrigationType => text().nullable()();
  TextColumn get waterSource => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
}

/// users/{uid}/farms/{farmId}/seasons/{seasonId} (§10, §14).
class Seasons extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get cropId => text()();
  TextColumn get cropName => text()();
  TextColumn get variety => text().nullable()();
  DateTimeColumn get sowingDate => dateTime()();
  RealColumn get area => real().nullable()();
  TextColumn get areaUnit => text().nullable()();
  TextColumn get seasonName => text().nullable()(); // kharif, rabi, zaid
  TextColumn get status => text().withDefault(const Constant('active'))(); // active, harvested, completed
  DateTimeColumn get expectedHarvestDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Farmer task instances generated from crop task templates (§16, §46).
class FarmTasks extends Table with SyncableColumns {
  TextColumn get seasonId => text()();
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get state => text().withDefault(const Constant('pending'))(); // pending, done, skipped, snoozed
}

/// Expense log (§21).
class Expenses extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get receiptPhotoPath => text().nullable()();
}

/// Irrigation log (§18).
class IrrigationLogs extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get durationMinutes => integer().nullable()();
  TextColumn get method => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Fertilizer log (§19).
class FertilizerLogs extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get product => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Spray/pesticide log (§20).
class SprayLogs extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get product => text()();
  RealColumn get quantity => real().nullable()();
  TextColumn get dose => text().nullable()();
  TextColumn get reason => text().nullable()();
  RealColumn get cost => real().nullable()();
  TextColumn get notes => text().nullable()();
}

/// Daily check-in / farm diary source (§65, §74, §80).
class DailyCheckins extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get healthStatus => text()(); // good, needsAttention, problem
  TextColumn get concern => text().nullable()(); // pest, leafChange, waterStress, disease, other
  TextColumn get note => text().nullable()();
  TextColumn get photoPath => text().nullable()();
}

/// Local reminders scheduled via flutter_local_notifications (§28).
class LocalReminders extends Table with SyncableColumns {
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  DateTimeColumn get scheduledFor => dateTime()();
  TextColumn get relatedType => text().nullable()(); // task, irrigation, fertilizer, expense
  TextColumn get relatedId => text().nullable()();
  BoolColumn get fired => boolean().withDefault(const Constant(false))();

  /// [ReminderCategory] name.
  TextColumn get category => text().withDefault(const Constant('custom'))();

  /// [ReminderRepeat] name: none, daily, weekly, monthly.
  TextColumn get repeatRule => text().withDefault(const Constant('none'))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  /// Crop (season id) this reminder is about, if any.
  TextColumn get cropId => text().nullable()();

  /// When false the reminder is only listed, never sent as a notification.
  BoolColumn get notificationEnabled => boolean().withDefault(const Constant(true))();
}

/// Crop diary entries — one row per activity on a crop (sowing, irrigation,
/// spray, pest sighting, sale, ...), shown as a timeline.
class CropActivities extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get seasonId => text()();
  TextColumn get type => text()(); // ActivityType name
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  /// What this activity cost (₹), if the farmer wants to note it.
  RealColumn get cost => real().nullable()();
}

/// Soil test values the farmer typed in from a lab report or Soil Health Card.
class SoilReports extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get ph => real().nullable()();
  RealColumn get nitrogen => real().nullable()();
  RealColumn get phosphorus => real().nullable()();
  RealColumn get potassium => real().nullable()();
  RealColumn get organicCarbon => real().nullable()();
  TextColumn get otherNutrients => text().nullable()();
  TextColumn get documentId => text().nullable()(); // optional scanned card
}

/// Document locker: files kept on the phone, optionally backed up to
/// Firebase Storage (cloudPath is set once uploaded).
class FarmDocuments extends Table with SyncableColumns {
  TextColumn get farmId => text().nullable()();
  TextColumn get category => text()(); // DocumentCategory name
  TextColumn get title => text()();
  TextColumn get localPath => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get cloudPath => text().nullable()();
}

/// Farmer-entered mandi price observations (§23). No live feed exists
/// without an Agmarknet/data.gov.in API key, so V1 lets the farmer track
/// prices they've seen — the repository abstraction means a real feed can
/// replace this later without changing the UI.
class MandiPriceLogs extends Table with SyncableColumns {
  TextColumn get farmId => text()();
  TextColumn get commodity => text()();
  TextColumn get market => text().nullable()();
  RealColumn get price => real()();
  TextColumn get unit => text().withDefault(const Constant('quintal'))();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
}

/// Outbox of pending Firestore writes when offline (§8).
class SyncQueueItems extends Table {
  IntColumn get queueId => integer().autoIncrement()();
  TextColumn get entityTable => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // create, update, delete
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}
