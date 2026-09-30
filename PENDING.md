# KisanMitra 360 — What's Pending

Status as of 30 Sep 2026. `dart analyze` is clean, the Android debug APK builds, and
132 of 133 tests pass. Nothing has been run on a physical device yet.

The one failing test is `test/tmp_preview/home_preview_test.dart`, a screenshot
comparison of the old home screen. Refresh it with:
`flutter test --update-goldens test/tmp_preview`

---

## 1. Needs a decision or setup from you

| # | Item | What to do |
|---|------|-----------|
| 1 | **Turn on phone login** | Set `kPhoneLoginEnabled = true` in `lib/core/config/feature_flags.dart`. Until then the app is guest-only and cloud sync, restore, document backup and push notifications do nothing. |
| 2 | **Firebase console for phone login** | Enable Phone sign-in, add your debug SHA-1/SHA-256 keys, add test phone numbers for development. |
| 3 | **Deploy security rules** | `firebase deploy --only firestore:rules,storage` (files: `firestore.rules`, `storage.rules`). |
| 4 | **Review scheme content** | Check `lib/features/advisories/data/advisory_content.dart` against the official sites (list below). The sites could not be reached during development, so nothing was verified. |
| 5 | **Send push notifications** | The app registers devices and subscribes to topics `weather_alerts`, `mandi_alerts`, `govt_updates`. Something server-side (e.g. a Cloud Function) must publish to them. |
| 6 | **Hindi and Marathi** | Set `kEnglishOnly = false` when ready. Existing strings are translated, but all newer screens fall back to English, and the translations I wrote need a native speaker's review. |

### Scheme content to verify
- All seven links still work: `mahadbt.maharashtra.gov.in`, `pmkisan.gov.in`,
  `pmfby.gov.in`, `agrimachinery.nic.in`, `pmksy.gov.in`, `midh.gov.in`,
  `agriinfra.dac.gov.in`.
- PMFBY: premium percentages (2% kharif, 1.5% rabi) and the crop-loss reporting time limit.
- Helplines: PM-KISAN `155261`, crop insurance `14447`.
- Benefit and eligibility wording for each scheme.

---

## 2. Not built yet

- **iOS Firebase setup** (no `GoogleService-Info.plist`; iOS runs offline-only).
- **Tests for login and OTP** (success, failure, expiry, resend timer, logout, session persistence).
- **Nearby services as an in-app map.** Today it opens the maps app.
- **Nearby mandis by distance.** Mandis are grouped by district (yours first) because the price API has no coordinates. Sorting by distance would need market locations from another source.
- **Price alerts run only on loaded prices.** There is no server-side scheduled check (by design: the app never polls).
- **Crop disease detection from photos** (planned for Phase 3; needs expert-reviewed guidance first).
- **Weather dummy data is still on**: `kUseDummyWeather = true`. Set it to `false` to use live Open-Meteo data.
- **Dashboard and Weather screens have no widget tests.**
- **Delete a single document's cloud copy when offline** is skipped silently and may leave an orphaned file.

---

## 3. Known limitations

- Mandi prices are *reported* daily prices and can be several days old. The app always shows the reported date.
- The mandi API allows 100 requests per 15 minutes per IP. The app caches for 30 minutes and never polls.
- The mandi API supports five states (Maharashtra, Uttar Pradesh, Punjab, Madhya Pradesh, Karnataka).
- The crop-progress bar on the dashboard uses rough typical growing days per crop, not real data.
- Crop library content is general guidance only (no pesticide or dose advice).
- Dark theme is off (`ThemeMode.light`) because some older screens hard-code light colours.

---

## 4. Done (for reference)

Weather redesign, dashboard sections, Advisories hub, schemes / PM-KISAN / PMFBY pages,
crop library, profit calculator, nearby services, nearby mandis (by district, with prices and directions), farm hub with multiple farms, crop list and
detail, crop diary, reminders, soil health, document locker, live mandi API with filters and
history, Firestore sync and restore, Storage backup, push notifications, Firebase Analytics,
security rules, English-only mode.

## 5. Commands

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
flutter test
flutter build apk --debug
```
