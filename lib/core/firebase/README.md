# Firebase setup

## Current state

**Android is configured and working.** `android/app/google-services.json`
exists (project `kisanmitra-11664`), the Google Services Gradle plugin is
wired in (`android/settings.gradle.kts`, `android/app/build.gradle.kts`),
and `lib/firebase_options.dart` has the Android `FirebaseOptions` block
filled in by hand from that file's values.

**iOS and macOS are not configured yet** — no app has been added for
those platforms in the Firebase console, so there's no
`GoogleService-Info.plist` and `firebase_options.dart` intentionally
throws `UnsupportedError` for them. The app still boots and works fully
offline on those platforms (see below) — it just runs without Firebase
until you add them.

**Phone Authentication is live** on Android via `FirebaseAuthRepository`
(`features/auth/data/firebase_auth_repository.dart`):
- "Continue as Guest" signs in anonymously (`signInAnonymously`) instead
  of creating a purely local id, so the farmer already has a stable
  Firebase uid from day one.
- Entering a phone number and verifying the OTP (`features/auth/presentation/otp_screen.dart`)
  *links* the phone credential to that same anonymous account
  (`linkWithCredential`) rather than creating a new one — local data
  keyed by the user id never has to move (blueprint §5).
- If Firebase isn't available for the current platform, `auth_providers.dart`
  automatically falls back to the old `LocalAuthRepository` — guest mode
  keeps working everywhere, phone sign-in shows a friendly "not available
  yet" message until Firebase exists for that platform.

## How the fallback works

`core/firebase/firebase_bootstrap.dart`'s `initializeFirebase()` is
called once from `main()`, before `runApp`. It never throws — on
failure (or on a platform with no `FirebaseOptions`), it just sets
`isFirebaseAvailable = false` and the app continues in local-only mode
(blueprint §7). Every provider that has a Firebase-backed implementation
should follow the same pattern `auth_providers.dart` uses:

```dart
final xRepositoryProvider = Provider<XRepository>((ref) {
  if (isFirebaseAvailable) return FirebaseXRepository(...);
  return LocalXRepository(...);
});
```

## Next steps, roughly in order of value

1. **Add iOS/macOS apps in the Firebase console**, download their config
   files, and either run `flutterfire configure` (regenerates
   `firebase_options.dart` properly for every platform at once — prefer
   this over hand-editing) or add the missing `FirebaseOptions` blocks
   by hand the same way `android` is defined now.
2. **Firestore** — the sync-queue outbox (`core/sync/`) is ready and
   already enqueues every local mutation; this just means writing
   `Firebase*Repository` implementations + `SyncHandler`s per table and
   registering them in `syncEngineProvider`. No other code changes.
3. **Firebase Storage** — crop/receipt photo upload (photos are already
   saved locally, just not uploaded anywhere).
4. **Cloud Functions** — the real AI assistant backend (never put an AI
   provider's API key in the app directly, per §24).
5. **FCM, Remote Config, Crashlytics, App Check** — same swap-in pattern;
   `core/utils/error_reporter.dart`'s `reportError` is already the single
   call site to forward to Crashlytics from.
6. **Firestore security rules** — must be written and tested before any
   real sync happens.

## Gradle notes from getting Android building

Two unrelated Android toolchain issues surfaced while wiring this up —
worth knowing about if a future dependency bump reintroduces them:
- `permission_handler` 13.x's Android build script needs a much newer
  AGP/Kotlin/compileSdk than this project uses; pinned to
  `permission_handler: ^11.4.0` (resolves to `permission_handler_android`
  12.x, which uses the older stable Groovy build script) to avoid it.
- `firebase_auth`'s native Android dependency needs Kotlin Gradle Plugin
  2.2.20+ to read its metadata — see `android/settings.gradle.kts`.
- `flutter_local_notifications` needs Android core library desugaring
  enabled — see the `coreLibraryDesugaring` block in
  `android/app/build.gradle.kts`.
