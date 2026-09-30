import 'dart:async';

import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/stream_extensions.dart';
import '../../../core/utils/ids.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

const _currentUserIdKey = 'current_user_id';
const _table = 'users';

/// No-server V1 implementation (blueprint §48). Guest mode is fully
/// functional offline; phone OTP is not available until Firebase
/// Authentication is configured.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._db, this._prefs, this._syncQueue);

  final AppDatabase _db;
  final SharedPreferences _prefs;
  final SyncQueueRepository _syncQueue;

  /// Fires on guest sign-in, sign-out and account deletion so
  /// [watchCurrentUser] follows the signed-in user instead of the one that
  /// was signed in when it was first listened to.
  final _userIdChanges = StreamController<String?>.broadcast();

  String? get _currentUserId => _prefs.getString(_currentUserIdKey);

  Future<void> _setCurrentUserId(String? id) async {
    if (id == null) {
      await _prefs.remove(_currentUserIdKey);
    } else {
      await _prefs.setString(_currentUserIdKey, id);
    }
    _userIdChanges.add(id);
  }

  @override
  Stream<AppUser?> watchCurrentUser() {
    final ids = Stream<String?>.multi((controller) {
      controller.add(_currentUserId);
      controller.addStream(_userIdChanges.stream);
    });
    return ids.switchMap((id) {
      if (id == null) return Stream.value(null);
      return (_db.select(_db.localUsers)..where((u) => u.id.equals(id)))
          .watchSingleOrNull()
          .map((row) => row == null ? null : _toAppUser(row));
    });
  }

  @override
  Future<AppUser?> currentUser() async {
    final id = _currentUserId;
    if (id == null) return null;
    final row = await (_db.select(_db.localUsers)..where((u) => u.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toAppUser(row);
  }

  @override
  Future<AppUser> continueAsGuest() async {
    final existing = await currentUser();
    if (existing != null) return existing;

    final id = newId();
    final now = DateTime.now();
    await _db.into(_db.localUsers).insert(
          LocalUsersCompanion.insert(
            id: id,
            createdAt: now,
            updatedAt: now,
            isGuest: const Value(true),
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
    await _setCurrentUserId(id);
    return AppUser(id: id, name: '', isGuest: true);
  }

  @override
  Future<void> sendOtp(String phone) async {
    throw const AuthNotConfiguredException();
  }

  @override
  Future<AppUser> verifyOtp({required String phone, required String otp}) async {
    throw const AuthNotConfiguredException();
  }

  @override
  Future<void> updateProfile(AppUser user) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(user.id))).write(
      LocalUsersCompanion(
        name: Value(user.name),
        phone: Value(user.phone),
        language: Value(user.language ?? 'en'),
        state: Value(user.state),
        district: Value(user.district),
        village: Value(user.village),
        taluka: Value(user.taluka),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: user.id, operation: 'update');
  }

  @override
  Future<void> signOut() => _setCurrentUserId(null);

  @override
  Future<void> deleteAccount() async {
    await _db.wipeAllData();
    await _setCurrentUserId(null);
  }

  AppUser _toAppUser(LocalUser row) => AppUser(
        id: row.id,
        name: row.name,
        isGuest: row.isGuest,
        phone: row.phone,
        language: row.language,
        state: row.state,
        district: row.district,
        village: row.village,
        taluka: row.taluka,
      );
}
