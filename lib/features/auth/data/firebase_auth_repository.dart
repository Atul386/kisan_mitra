import 'dart:async';

import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../../../core/utils/stream_extensions.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

const _table = 'users';
const _offlineGuestIdKey = 'offline_guest_id';

/// Anonymous sign-in failures that mean "Firebase can't give us a guest
/// account right now" rather than a real bug: no connection, or Anonymous
/// sign-in disabled in the Firebase console.
const _offlineFallbackCodes = {'network-request-failed', 'operation-not-allowed', 'admin-restricted-operation'};

/// Real phone-OTP auth (blueprint §5) now that Firebase is configured.
/// Guest mode signs in anonymously so the farmer already has a stable
/// Firebase uid from day one; verifying a phone number later *links* the
/// credential to that same anonymous account instead of creating a new
/// one, so local data keyed by the user id never has to move.
///
/// Guest mode must also work with no connection (§7). If anonymous sign-in
/// can't reach Firebase, the farmer gets an *offline guest* — a local-only
/// profile like [LocalAuthRepository]'s. As soon as a Firebase user exists
/// (connection back → [upgradeOfflineGuest], or phone OTP sign-in), the
/// offline guest's profile and farms are moved onto that uid.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._db, this._syncQueue, this._prefs);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final SharedPreferences _prefs;
  final _auth = fb.FirebaseAuth.instance;
  final _offlineGuestChanges = StreamController<void>.broadcast();

  String? get _offlineGuestId => _prefs.getString(_offlineGuestIdKey);

  Future<void> _setOfflineGuestId(String? id) async {
    if (id == null) {
      await _prefs.remove(_offlineGuestIdKey);
    } else {
      await _prefs.setString(_offlineGuestIdKey, id);
    }
    _offlineGuestChanges.add(null);
  }

  String? _verificationId;
  int? _resendToken;

  @override
  Stream<AppUser?> watchCurrentUser() {
    // Follows the profile row too, not just sign-in state, so a saved name
    // or farm details reach the router without a restart.
    final signInStates = Stream<fb.User?>.multi((controller) {
      final authSub = _auth.authStateChanges().listen(controller.add, onError: controller.addError);
      final guestSub = _offlineGuestChanges.stream.listen((_) => controller.add(_auth.currentUser));
      controller.onCancel = () async {
        await authSub.cancel();
        await guestSub.cancel();
      };
    });
    return signInStates.switchMap((fbUser) {
      if (fbUser == null) {
        final guestId = _offlineGuestId;
        if (guestId == null) return Stream.value(null);
        return (_db.select(_db.localUsers)..where((u) => u.id.equals(guestId)))
            .watchSingleOrNull()
            .map((row) => row == null ? null : _toOfflineGuest(row));
      }
      return Stream.fromFuture(_loadOrCreateProfile(fbUser)).asyncExpand(
        (_) => (_db.select(_db.localUsers)..where((u) => u.id.equals(fbUser.uid)))
            .watchSingleOrNull()
            .map((row) => row == null ? null : _toAppUser(row, fbUser)),
      );
    });
  }

  @override
  Future<AppUser?> currentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser != null) return _loadOrCreateProfile(fbUser);
    final guestId = _offlineGuestId;
    if (guestId == null) return null;
    final row = await (_db.select(_db.localUsers)..where((u) => u.id.equals(guestId))).getSingleOrNull();
    return row == null ? null : _toOfflineGuest(row);
  }

  AppUser _toOfflineGuest(LocalUser row) => AppUser(
        id: row.id,
        name: row.name,
        isGuest: true,
        phone: row.phone,
        language: row.language,
        state: row.state,
        district: row.district,
        village: row.village,
        taluka: row.taluka,
      );

  AppUser _toAppUser(LocalUser row, fb.User fbUser) => AppUser(
        id: row.id,
        name: row.name,
        isGuest: fbUser.isAnonymous,
        phone: row.phone ?? fbUser.phoneNumber,
        language: row.language,
        state: row.state,
        district: row.district,
        village: row.village,
        taluka: row.taluka,
      );

  Future<AppUser> _loadOrCreateProfile(fb.User fbUser) async {
    await _adoptOfflineGuest(fbUser);
    final row =
        await (_db.select(_db.localUsers)..where((u) => u.id.equals(fbUser.uid))).getSingleOrNull();
    if (row != null) return _toAppUser(row, fbUser);

    final now = DateTime.now();
    // insertOrIgnore: the auth stream and sign-in call can both get here
    // for the same new uid.
    final inserted = await _db.into(_db.localUsers).insertReturningOrNull(
          LocalUsersCompanion.insert(
            id: fbUser.uid,
            createdAt: now,
            updatedAt: now,
            isGuest: Value(fbUser.isAnonymous),
            phone: Value(fbUser.phoneNumber),
          ),
          mode: InsertMode.insertOrIgnore,
        );
    if (inserted != null) {
      await _syncQueue.enqueue(table: _table, entityId: fbUser.uid, operation: 'create');
    }
    return AppUser(id: fbUser.uid, name: '', isGuest: fbUser.isAnonymous, phone: fbUser.phoneNumber);
  }

  /// Moves an offline guest's profile and farms onto [fbUser]'s uid. Farms
  /// are the only rows keyed by user id — everything else hangs off farm
  /// or season ids, so it follows automatically.
  Future<void> _adoptOfflineGuest(fb.User fbUser) async {
    final guestId = _offlineGuestId;
    if (guestId == null || guestId == fbUser.uid) return;

    final movedFarmIds = await _db.transaction(() async {
      final guest = await (_db.select(_db.localUsers)..where((u) => u.id.equals(guestId))).getSingleOrNull();
      final existing =
          await (_db.select(_db.localUsers)..where((u) => u.id.equals(fbUser.uid))).getSingleOrNull();
      if (guest != null && existing == null) {
        final now = DateTime.now();
        await _db.into(_db.localUsers).insert(
              LocalUsersCompanion.insert(
                id: fbUser.uid,
                createdAt: guest.createdAt,
                updatedAt: now,
                name: Value(guest.name),
                phone: Value(fbUser.phoneNumber ?? guest.phone),
                language: Value(guest.language),
                state: Value(guest.state),
                district: Value(guest.district),
                village: Value(guest.village),
                taluka: Value(guest.taluka),
                isGuest: Value(fbUser.isAnonymous),
              ),
            );
      }
      final farms = await (_db.select(_db.farms)..where((f) => f.userId.equals(guestId))).get();
      await (_db.update(_db.farms)..where((f) => f.userId.equals(guestId))).write(
        FarmsCompanion(
          userId: Value(fbUser.uid),
          updatedAt: Value(DateTime.now()),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
      await (_db.delete(_db.localUsers)..where((u) => u.id.equals(guestId))).go();
      return farms.map((f) => f.id).toList();
    });

    await _prefs.remove(_offlineGuestIdKey);
    await _syncQueue.enqueue(table: _table, entityId: fbUser.uid, operation: 'create');
    for (final farmId in movedFarmIds) {
      await _syncQueue.enqueue(table: 'farms', entityId: farmId, operation: 'update');
    }
  }

  @override
  Future<AppUser> continueAsGuest() async {
    final existing = _auth.currentUser;
    if (existing != null) return _loadOrCreateProfile(existing);
    final offline = await currentUser();
    if (offline != null) return offline;

    try {
      final credential = await _auth.signInAnonymously();
      return _loadOrCreateProfile(credential.user!);
    } on fb.FirebaseAuthException catch (e) {
      if (!_offlineFallbackCodes.contains(e.code)) rethrow;
      return _createOfflineGuest();
    }
  }

  Future<AppUser> _createOfflineGuest() async {
    final id = newId();
    final now = DateTime.now();
    await _db.into(_db.localUsers).insert(
          LocalUsersCompanion.insert(id: id, createdAt: now, updatedAt: now, isGuest: const Value(true)),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
    await _setOfflineGuestId(id);
    return AppUser(id: id, name: '', isGuest: true);
  }

  /// Called when the connection comes back: gives an offline guest a real
  /// (anonymous) Firebase account, which [_adoptOfflineGuest] then moves
  /// their data onto. Silent on failure — they simply stay offline for now.
  Future<void> upgradeOfflineGuest() async {
    if (_auth.currentUser != null || _offlineGuestId == null) return;
    try {
      await _auth.signInAnonymously();
    } catch (_) {}
  }

  @override
  Future<void> sendOtp(String phone) async {
    final e164Phone = phone.startsWith('+') ? phone : '+91$phone';
    final completer = Completer<void>();

    await _auth.verifyPhoneNumber(
      phoneNumber: e164Phone,
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        // Android-only instant auto-verification — complete the sign-in
        // the same way manual OTP entry would.
        try {
          await _signInOrLink(credential);
        } catch (_) {
          // The OTP screen's manual flow remains available either way.
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.completeError(Exception(e.message ?? 'Could not send OTP'));
        }
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<AppUser> verifyOtp({required String phone, required String otp}) async {
    final verificationId = _verificationId;
    if (verificationId == null) {
      throw Exception('Request an OTP before verifying.');
    }
    final credential = fb.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    return _signInOrLink(credential);
  }

  Future<AppUser> _signInOrLink(fb.PhoneAuthCredential credential) async {
    final current = _auth.currentUser;
    final fb.UserCredential result;
    if (current != null && current.isAnonymous) {
      result = await current.linkWithCredential(credential);
    } else {
      result = await _auth.signInWithCredential(credential);
    }

    final fbUser = result.user!;
    // Creates the profile row first (moving an offline guest's data over
    // if there is one) so the phone number below has a row to land on.
    await _loadOrCreateProfile(fbUser);
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(fbUser.uid))).write(
      LocalUsersCompanion(
        phone: Value(fbUser.phoneNumber),
        isGuest: const Value(false),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: fbUser.uid, operation: 'update');
    return _loadOrCreateProfile(fbUser);
  }

  @override
  Future<void> updateProfile(AppUser user) async {
    await (_db.update(_db.localUsers)..where((u) => u.id.equals(user.id))).write(
      LocalUsersCompanion(
        name: Value(user.name),
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
  Future<void> signOut() async {
    await _auth.signOut();
    if (_offlineGuestId != null) await _setOfflineGuestId(null);
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on fb.FirebaseAuthException catch (e) {
      // Firebase only deletes a recently signed-in account, and needs a
      // connection. Nothing is stored server-side yet (no Firestore sync),
      // so removing local data and signing out still honours the request.
      if (e.code != 'requires-recent-login' && e.code != 'network-request-failed') rethrow;
    } finally {
      await _auth.signOut();
    }
    await _db.wipeAllData();
    if (_offlineGuestId != null) await _setOfflineGuestId(null);
  }
}
