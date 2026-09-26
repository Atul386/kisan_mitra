# Mandi prices

Two independent sources feed this screen:

1. **Manual entries** (`LocalMandiRepository`) — the farmer logs prices
   they've personally observed at the mandi. Always available, works
   fully offline, and is what drives the trend list ("Today vs
   Yesterday").
2. **Live government feed** (`DataGovMandiRepository`) — the Agmarknet
   daily mandi price dataset published on data.gov.in
   (resource `9ef84268-d588-465a-a308-a864a43d0070`), filtered to the
   farmer's farm state and, when set, their active crop. Shown as a
   "Live Mandi Prices" card above the manual list when configured and
   the API call succeeds; the screen falls back to the manual-tracking
   note otherwise, exactly as before.

## Enabling the live feed

The feed needs a free API key:

1. Register at https://data.gov.in/user/register (or sign in) and copy
   your API key from your profile page.
2. Run/build the app with the key passed as a dart-define, e.g.:
   ```
   flutter run --dart-define=MANDI_API_KEY=your-key-here
   flutter build apk --dart-define=MANDI_API_KEY=your-key-here
   ```
   For a persistent local setup, add it to an untracked
   `--dart-define-from-file` JSON (e.g. `dart_defines.json`, already
   gitignored via the usual `*.json` secrets pattern — double-check
   before committing) instead of typing it every time.

The key is a free, self-registered, rate-limited-for-fairness key (like
Open-Meteo's key-less access, not a paid/abusable secret like the AI
assistant's LLM key), so it's read directly in the app via
`String.fromEnvironment` rather than proxied through a Cloud Function —
see the same reasoning documented in
`OpenMeteoWeatherRepository`. Without a key, `DataGovMandiRepository.isConfigured`
is `false` and `liveMandiPricesProvider` simply returns an empty list —
no error shown to the farmer.
