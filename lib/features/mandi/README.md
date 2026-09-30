# Mandi prices

Two independent sources feed the Mandi screen:

1. **Reported government prices** (`MandiApiRepository`) — daily prices per
   market from the free, keyless **Mandi Price API**
   (`https://mandi-api.onrender.com/v1`, docs: https://mandi-api.vercel.app/docs),
   which republishes data.gov.in / Agmarknet. No API key needed. To point a
   build at a different host (e.g. your own proxy), pass
   `--dart-define=MANDI_API_BASE_URL=https://...` (see `kMandiApiBaseUrl`).
2. **Your own entries** (`LocalMandiRepository`) — prices the farmer logged
   themselves. Always available, works fully offline, and drives the
   "today vs previous" trend cards.

## Reading the data correctly

These are prices markets *reported* for an `arrival_date` — not live auction
quotes, and they can be a few days old. Every price card therefore shows
"Reported <date>", and the screens say so. Don't remove that.

## What the API gives us

| Endpoint | Used for |
| --- | --- |
| `GET /v1/prices` | Price list (filters: `state`, `commodity`, `market`, `variety`, `date`). Returns at most 200 rows. |
| `GET /v1/prices/history` | 7/30-day chart. Statewide it returns daily averages (`avg_modal_price`); with `market` it returns raw rows (`modal_price`). Both are handled. |
| `GET /v1/markets?state=` | District and market pickers |
| `GET /v1/commodities` | Crop picker |

Supported states (v1): Maharashtra, Uttar Pradesh, Punjab, Madhya Pradesh,
Karnataka. A farm in any other state gets a clear "not available for your
state yet" message. A farm with no state set is looked up as Maharashtra.

## Rate limit and offline behaviour

The API allows **100 requests per 15 minutes per IP**, so the app is frugal:

- Every successful response is cached (`MandiApiCache`, SharedPreferences,
  newest 40 requests kept).
- A cached response younger than 30 minutes is used without any request, so
  switching tabs or reopening a screen costs nothing.
- Searching is done locally on the loaded list (debounced), and the
  district filter is applied locally too (the API has no district filter).
- If the network fails — or the limit is hit — the last saved response is
  shown with an "You're offline. Showing your last saved data." banner.
  Only when nothing is saved does the screen show an error.
- The app never polls. Price alerts are checked only against prices that
  are already loaded.

Free hosting can be slow on the first request after idle, so requests wait
up to 25 seconds before being treated as offline.

## Code map

- `data/mandi_api_repository.dart` — HTTP client, parsing, caching, error mapping.
- `data/mandi_api_cache.dart` — the on-device cache.
- `domain/live_mandi_repository.dart` — the interface screens depend on, plus
  `MandiException` types (offline, rate limited, unsupported state, fetch).
- `mandi_providers.dart` — filter state, prices, markets, commodities, history.
- `presentation/live_mandi_screen.dart` — all prices with filters and search.
- `presentation/mandi_history_screen.dart` — Today / 7 days / 30 days.
