// Features switched off for the v1.0 offline-only release. Flip to `true`
// to bring them back (v1.1) — the code behind them is kept intact.

/// Phone OTP login via Firebase. Off: the app creates a local guest
/// automatically and all data stays on the phone.
const kPhoneLoginEnabled = false;

/// AI assistant tab and its entry points. Off until the Cloud Function
/// backend that actually answers questions exists.
const kAiAssistantEnabled = false;

/// Show built-in sample weather (see `WeatherSnapshot.demo`) instead of
/// calling Open-Meteo. For UI previews and demos only.
const kUseDummyWeather = false;

/// English-only release. The app starts in English, skips the language
/// picker and hides the language setting. Set to `false` once the Hindi
/// and Marathi translations are reviewed — the strings are already in
/// place (`app_hi.arb`, `app_mr.arb`).
const kEnglishOnly = true;

/// Mandi Price API host (the `/v1/...` paths are added by the repository).
/// Override per build without a code change, e.g.
/// `flutter build appbundle --dart-define=MANDI_API_BASE_URL=https://your-proxy.example.com`.
const kMandiApiBaseUrl = String.fromEnvironment(
  'MANDI_API_BASE_URL',
  defaultValue: 'https://mandi-api.onrender.com',
);
