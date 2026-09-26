import 'app_user.dart';

/// Contract the UI depends on. V1 is backed by [LocalAuthRepository]
/// (local-only, no server). Swapping in a `FirebaseAuthRepository` later
/// for phone-OTP sign-in requires no UI changes (blueprint §35, §49).
abstract class AuthRepository {
  Stream<AppUser?> watchCurrentUser();

  Future<AppUser?> currentUser();

  /// Creates (or returns) a local guest account. Works fully offline.
  Future<AppUser> continueAsGuest();

  /// Requires Firebase Authentication — not available until the Firebase
  /// project is configured. Implementations should throw
  /// [AuthNotConfiguredException] until then.
  Future<void> sendOtp(String phone);

  Future<AppUser> verifyOtp({required String phone, required String otp});

  Future<void> updateProfile(AppUser user);

  Future<void> signOut();

  /// Permanently removes the farmer's account and all their local data.
  Future<void> deleteAccount();
}

class AuthNotConfiguredException implements Exception {
  const AuthNotConfiguredException([
    this.message = 'Phone sign-in is not available yet. Please continue as guest for now.',
  ]);

  final String message;

  @override
  String toString() => message;
}
