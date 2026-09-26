# KisanMitra 360

Flutter app for small farmers — daily farm tasks, expenses, irrigation /
fertilizer / spray logs, weather advice, mandi prices, crop check-ins and an
AI assistant. Works fully offline in guest mode. English, Hindi and Marathi.

See [PROGRESS.md](PROGRESS.md) for what's built and what's pending.

## Setup

1. Install Flutter (3.35+), then:
   ```sh
   flutter pub get
   ```

2. **Firebase config (not in the repo).** The real config files hold the
   Firebase project's keys, so they're git-ignored. Either get them from the
   project owner, or copy the templates and fill in your own project's values:
   ```sh
   cp android/app/google-services.json.example android/app/google-services.json
   cp lib/firebase_options.dart.example lib/firebase_options.dart
   ```
   (Or run `flutterfire configure` to generate them.) Details:
   `lib/core/firebase/README.md`.

3. Optional — live mandi prices need a free data.gov.in key:
   ```sh
   flutter run --dart-define=MANDI_API_KEY=your-key
   ```
   See `lib/features/mandi/README.md`.

4. Run:
   ```sh
   flutter run
   ```
   For iOS, run `cd ios && pod install` first (minimum iOS 15).

## Tests

```sh
flutter analyze
flutter test
```
