import 'dart:async';

import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

const _table = 'users';

/// Real phone-OTP auth (blueprint §5) now that Firebase is configured.
/// Guest mode signs in anonymously so the farmer already has a stable
/// Firebase uid from day one; verifying a phone number later *links* the
/// credential to that same anonymous account instead of creating a new
/// one, so local data keyed by the user id never has to move.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;
  final _auth = fb.FirebaseAuth.instance;

  String? _verificationId;
  int? _resendToken;

  @override
  Stream<AppUser?> watchCurrentUser() {
    return _auth.authStateChanges().asyncMap((fbUser) {
      if (fbUser == null) return Future.value(null);
      return _loadOrCreateProfile(fbUser);
    });
  }

  @override
  Future<AppUser?> currentUser() async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    return _loadOrCreateProfile(fbUser);
  }

  Future<AppUser> _loadOrCreateProfile(fb.User fbUser) async {
    final row =
        await (_db.select(_db.localUsers)..where((u) => u.id.equals(fbUser.uid))).getSingleOrNull();
    if (row != null) {
      return AppUser(
        id: row.id,
        name: row.name,
        isGuest: fbUser.isAnonymous,
        phone: row.phone ?? fbUser.phoneNumber,
        language: row.language,
        state: row.state,
        district: row.district,
        village: row.village,
      );
    }

    final now = DateTime.now();
    await _db.into(_db.localUsers).insert(
          LocalUsersCompanion.insert(
            id: fbUser.uid,
            createdAt: now,
            updatedAt: now,
            isGuest: Value(fbUser.isAnonymous),
            phone: Value(fbUser.phoneNumber),
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: fbUser.uid, operation: 'create');
    return AppUser(id: fbUser.uid, name: '', isGuest: fbUser.isAnonymous, phone: fbUser.phoneNumber);
  }

  @override
  Future<AppUser> continueAsGuest() async {
    final existing = _auth.currentUser;
    if (existing != null) return _loadOrCreateProfile(existing);

    final credential = await _auth.signInAnonymously();
    return _loadOrCreateProfile(credential.user!);
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
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: user.id, operation: 'update');
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> deleteAccount() async {
    await _db.wipeAllData();
    try {
      await _auth.currentUser?.delete();
    } on fb.FirebaseAuthException catch (e) {
      // Firebase only allows deleting a recently signed-in account. Local
      // data is already gone, so fall back to signing out; nothing is
      // stored server-side yet (no Firestore sync).
      if (e.code != 'requires-recent-login') rethrow;
    }
    await _auth.signOut();
  }
}
