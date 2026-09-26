# KisanMitra 360 — Build Progress

Status against `KisanMitra_360_Flutter_Firebase_Blueprint.md`, phase order from §58.
Verification baseline: `flutter analyze` clean, 24/24 automated tests passing, Android debug build succeeds (`flutter build apk`).

---

## Done

### Firebase — Android configured, phone auth live
- `google-services.json` added, Google Services Gradle plugin wired in, `lib/firebase_options.dart` filled in for Android.
- Real phone-OTP sign-in (`FirebaseAuthRepository`) — guest mode signs in anonymously first, and verifying a phone number *links* the credential to that same account so local data never has to move to a new user id.
- Auth repository auto-falls-back to the old fully-local implementation on any platform without Firebase configured (iOS/macOS, until their config is added) — see `lib/core/firebase/README.md` for exact next steps and the Gradle gotchas hit along the way.

### Phase 1 — Foundation
- Flutter project scaffolded (Riverpod, go_router, drift/SQLite, `flutter_localizations`).
- Brand palette + light/dark theme (`core/theme`).
- Localization: English/Hindi/Marathi ARB files + generated `AppLocalizations`, covering every screen built so far.
- Local database (drift): `users`, `farms`, `seasons`, `tasks`, `expenses`, `irrigation_logs`, `fertilizer_logs`, `spray_logs`, `daily_checkins`, `mandi_price_logs`, `local_reminders`, `sync_queue_items`.
- Repository pattern throughout: every feature has a domain interface + a `Local*Repository` implementation, so a `Firebase*Repository` can swap in later with no UI changes.
- Full onboarding → dashboard flow with router-driven redirects: Splash → Language → Login/Guest → Profile → Add Farm → Add Crop → Dashboard.
- Guest mode fully functional offline (no backend required).
- Bottom-nav dashboard shell (Home / Farm / Market / Assistant / Profile).

### Phase 2 — Core Farm
- Today's Tasks: deterministic rule engine (day-since-sowing → task templates, crop-specific overrides dedup'd against generic ones), idempotent generation, Done/Skip/Remind Me actions.
- Dashboard's Today's Tasks card wired to real pending-count data.

### Phase 3 — Daily Utility
- Expenses: categorized logging, season total, list screen.
- Irrigation / Fertilizer / Spray logs: add + list screens (tracking only, no AI-invented doses, per blueprint §20).
- Weather: real integration via **Open-Meteo** (free, keyless API — works without Firebase), with a rules engine translating raw weather into farmer advice (avoid spraying, check drainage, etc.), local caching for offline fallback, and farm location capture (geolocator).
- Local Notifications: real `flutter_local_notifications` wiring with correct device-timezone handling. "Remind Me" schedules an actual next-day notification; a recurring 8 AM daily-plan reminder is scheduled once a season is active.
- Android manifest + iOS/macOS Info.plist/entitlements updated for notifications, location, network (not Firebase-related, safe to do now).

### Phase 4 — Connected Features (scoped to what's buildable without Firebase)
- **Mandi prices**: manual price-tracking (no live feed available without a data.gov.in/Agmarknet API key) — commodity/market/price/date log with today-vs-previous trend, repository abstraction ready for a real feed later.
- **Daily Crop Check-in** (§65): Good/Needs Attention/Problem flow with concern picker, optional photo (saved to local app storage) and note; re-checking in same day corrects the entry instead of duplicating. Added the dashboard's previously-missing Crop Health card.
- **AI Assistant**: real chat UI shell backed by an `AiRepository` interface; since no Cloud Function exists yet, it honestly tells the farmer that instead of faking an answer.
- Explicitly **not** built (genuinely needs Firebase): crop image/disease *analysis*, FCM, Remote Config.

### Sync-queue outbox (blueprint §8)
- Every mutation (Farm, Season, Task, Expense, Irrigation, Fertilizer, Spray, Mandi, Daily Check-in, User profile) now enqueues an outbox entry after each local write.
- `SyncEngine` drains the queue via a pluggable `SyncHandler` registry keyed by table name. With zero handlers registered (today's reality), items are honestly left queued rather than faked as synced.
- Auto-drain attempt wired to connectivity changes (currently a no-op until handlers exist).
- Settings screen shows a real "Sync status" tile (pending record count); a real offline banner (reusing a string that had existed unused since Phase 1) now shows across the app when offline.

### Phase 5 — Hardening (parts not blocked on Firebase)
- **Error handling**: every save action across ~11 screens now catches failures and shows the one farmer-facing message (§42) instead of leaking exceptions — previously none of them did.
- **Crash reporting hook**: `FlutterError.onError` / `PlatformDispatcher.onError` / `runZonedGuarded` all route through one `reportError` call site, ready to forward to Crashlytics later.
- **Analytics scaffold**: local `AnalyticsService` (debug-log only) with the blueprint's §30/§82 events instrumented: `language_selected`, `farm_added`, `crop_added`, `expense_added`, `task_completed`, `daily_checkin_completed`, `ai_question_asked`, `weather_opened`, `mandi_opened`.
- Real About and Privacy screens (were empty stubs) — Privacy content is explicitly labeled as a placeholder needing legal review before store submission (§41, §60).
- Small accessibility fix: AI assistant's icon-only send button now has a screen-reader tooltip.

---

## Pending

### Blocked on Firebase project setup
Per your instruction, no Firebase project exists yet. Everything below needs it:
- **Firebase Authentication** — phone OTP (guest mode already works fully without it; UI shows a friendly "not available yet" message when tried).
- **Firestore** — real sync target. The outbox is ready; this just means writing `Firebase*Repository` implementations + `SyncHandler`s per table (see `core/firebase/README.md` for the exact steps) and registering them — no other code changes.
- **Firebase Storage** — crop/receipt photo upload (photos are already saved locally, just not uploaded anywhere).
- **Cloud Functions** — the real AI assistant backend (never put the AI provider's API key in the app directly, per §24).
- **FCM** — server-pushed alerts (weather warnings, mandi price alerts, announcements).
- **Remote Config** — feature flags (§29).
- **Crashlytics** — the local `reportError` hook is ready to forward to it.
- **App Check** — abuse protection, needed before production.
- **Firestore security rules** — must be written and tested before any real sync happens.

### Not yet built (not Firebase-blocked, just not done)
- Crop image/disease *capture-only* flow beyond the daily check-in's optional photo (no analysis without Firebase, but a dedicated crop-photo timeline isn't built).
- Weekly/monthly summary reports (§77–78).
- Voice input for check-ins/AI (§75).
- Profit/loss calculation (§22).
- Expense receipt photo capture (the DB field exists; no image_picker wired into `AddExpenseScreen` yet).
- Multi-farm UX polish (V1 assumes one primary farm; adding a second farm works but isn't a first-class flow).
- A real mandi live-feed integration (needs a registered data.gov.in/Agmarknet API key — see `features/mandi/domain/mandi_repository.dart`).
- App icons, launch screen assets, Play Store/App Store listing — nothing store-ready yet.
- Brand clearance (§60): "KisanMitra" name/logo not legally cleared — used as a placeholder throughout.

### Verification gaps
- No device/simulator has actually run the app interactively end-to-end by a human — only automated tests plus a partial manual click-through on macOS (this session's sandbox had window-focus interference from another tool, so the full onboarding flow wasn't visually confirmed past the login screen). **Recommend you do a manual pass on your machine** before trusting the flow blind.
- No real Android or iOS device build has been attempted (only macOS desktop, used for fast iteration).
- No integration/widget tests beyond the one boot-smoke test; business logic (task rules, weather rules, sync engine, repositories) has solid unit coverage, but no widget-level interaction tests exist.

---

## Suggested next step

Once you've set up the Firebase project: implement `Firebase*Repository` for each feature and a matching `SyncHandler`, following `core/firebase/README.md`. That single step unblocks Auth, Firestore sync, Storage uploads, and the real AI assistant, in that rough order of value.
