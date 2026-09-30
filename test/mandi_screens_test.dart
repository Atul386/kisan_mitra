import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/mandi/domain/live_mandi_price.dart';
import 'package:kisan_mitra/features/mandi/domain/live_mandi_repository.dart';
import 'package:kisan_mitra/features/mandi/mandi_providers.dart';
import 'package:kisan_mitra/features/mandi/presentation/live_mandi_screen.dart';
import 'package:kisan_mitra/features/mandi/presentation/mandi_history_screen.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeMandiRepo implements LiveMandiRepository {
  FakeMandiRepo({this.prices = const [], this.history = const [], this.fromCache = false, this.error});

  final List<LiveMandiPrice> prices;
  final List<MandiHistoryPoint> history;
  final bool fromCache;
  final MandiException? error;
  final calls = <Map<String, String?>>[];

  MandiResult<T> _r<T>(T v) => MandiResult(v, fromCache: fromCache, cachedAt: fromCache ? DateTime(2026, 9, 29, 18, 30) : null);

  @override
  Future<MandiResult<List<LiveMandiPrice>>> fetchPrices({
    required String state,
    String? commodity,
    String? market,
    String? variety,
    DateTime? date,
  }) async {
    calls.add({'state': state, 'commodity': commodity, 'market': market, 'variety': variety});
    if (error != null) throw error!;
    return _r(prices);
  }

  @override
  Future<MandiResult<List<MandiHistoryPoint>>> fetchHistory({
    required String state,
    required String commodity,
    String? market,
    required DateTime from,
    required DateTime to,
  }) async {
    if (error != null) throw error!;
    return _r(history);
  }

  @override
  Future<MandiResult<List<MandiMarket>>> fetchMarkets(String state) async => _r([
    const MandiMarket(market: 'APMC Nagpur', district: 'Nagpur'),
    const MandiMarket(market: 'APMC Umrane', district: 'Nashik'),
  ]);

  @override
  Future<MandiResult<List<String>>> fetchCommodities({required String state, String? market}) async =>
      _r(['Onion', 'Wheat']);
}

final nagpur = LiveMandiPrice(
  state: 'Maharashtra',
  district: 'Nagpur',
  market: 'APMC Nagpur',
  commodity: 'Onion',
  variety: 'Red',
  grade: 'Local',
  arrivalDate: DateTime(2026, 9, 24),
  minPrice: 3500,
  maxPrice: 4500,
  modalPrice: 4250,
);
final nashik = LiveMandiPrice(
  state: 'Maharashtra',
  district: 'Nashik',
  market: 'APMC Umrane',
  commodity: 'Onion',
  variety: 'Unhali',
  grade: 'Local',
  arrivalDate: DateTime(2026, 9, 24),
  minPrice: 1500,
  maxPrice: 4750,
  modalPrice: 3600,
);

Future<void> pumpScreen(WidgetTester tester, Widget screen, FakeMandiRepo repo) async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  tester.view.physicalSize = const Size(720, 2400);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      liveMandiRepositoryProvider.overrideWithValue(repo),
      mandiStateProvider.overrideWithValue('Maharashtra'),
      mandiEffectiveCommodityProvider.overrideWithValue('Onion'),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: screen,
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('prices show min/modal/max and always the reported date', (tester) async {
    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo(prices: [nagpur, nashik]));

    expect(find.text('ONION'), findsNWidgets(2));
    expect(find.text('APMC Nagpur, Nagpur'), findsOneWidget);
    expect(find.text('₹3,500'), findsOneWidget);
    expect(find.text('₹4,250'), findsOneWidget);
    expect(find.text('₹4,500'), findsOneWidget);
    expect(find.textContaining('Reported 24 Sep 2026'), findsNWidgets(2));
    expect(find.textContaining('not real-time auction prices'), findsOneWidget);
    expect(find.textContaining("You're offline"), findsNothing);
  });

  testWidgets('offline with saved data shows the banner and still lists prices', (tester) async {
    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo(prices: [nagpur], fromCache: true));

    expect(find.textContaining("You're offline"), findsOneWidget);
    expect(find.textContaining('Showing your last saved data'), findsOneWidget);
    expect(find.text('₹4,250'), findsOneWidget);
  });

  testWidgets('no matching prices shows the empty message', (tester) async {
    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo());
    expect(find.textContaining('No mandi prices found'), findsOneWidget);
    expect(find.textContaining('Try another market or crop'), findsOneWidget);
  });

  testWidgets('failures show a friendly message, never the raw exception', (tester) async {
    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo(error: const MandiFetchException('HTTP 500: boom')));
    expect(find.textContaining('Unable to load prices'), findsOneWidget);
    expect(find.textContaining('Check your internet connection'), findsOneWidget);
    expect(find.textContaining('boom'), findsNothing);
    expect(find.textContaining('HTTP 500'), findsNothing);
    expect(find.text('Try again'), findsOneWidget);

    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo(error: const MandiRateLimitedException()));
    expect(find.textContaining('Too many requests'), findsOneWidget);

    await pumpScreen(tester, const LiveMandiScreen(), FakeMandiRepo(error: const MandiUnsupportedStateException()));
    expect(find.textContaining("aren't available for your state"), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('searching narrows the list (debounced, done locally)', (tester) async {
    final repo = FakeMandiRepo(prices: [nagpur, nashik]);
    await pumpScreen(tester, const LiveMandiScreen(), repo);
    final callsBefore = repo.calls.length;

    await tester.enterText(find.byType(TextField), 'umrane');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('APMC Umrane, Nashik'), findsOneWidget);
    expect(find.text('APMC Nagpur, Nagpur'), findsNothing);
    expect(repo.calls.length, callsBefore, reason: 'search must not spend API requests');
  });

  testWidgets('history: 7-day view lists each day, today view shows the latest reported day', (tester) async {
    final history = [
      MandiHistoryPoint(date: DateTime(2026, 9, 23), modalPrice: 4100, minPrice: 3400, maxPrice: 4400),
      MandiHistoryPoint(date: DateTime(2026, 9, 24), modalPrice: 4250, minPrice: 3500, maxPrice: 4500),
    ];
    await pumpScreen(
      tester,
      const MandiHistoryScreen(commodity: 'Onion', market: 'APMC Nagpur'),
      FakeMandiRepo(history: history),
    );

    expect(find.text('Onion'), findsOneWidget);
    expect(find.text('APMC Nagpur'), findsOneWidget);
    expect(find.text('23 Sep 2026'), findsOneWidget);
    expect(find.text('24 Sep 2026'), findsOneWidget);
    expect(find.text('₹4,100'), findsNothing); // list shows plain rupees
    expect(find.text('₹4100'), findsOneWidget);

    await tester.tap(find.text('Today'));
    await tester.pumpAndSettle();
    expect(find.text('Latest reported price'), findsOneWidget);
    expect(find.text('Reported 24 Sep 2026'), findsOneWidget);
    expect(find.text('₹4,250'), findsOneWidget);
  });

  testWidgets('history: unavailable data says so', (tester) async {
    await pumpScreen(tester, const MandiHistoryScreen(commodity: 'Onion'), FakeMandiRepo());
    expect(find.textContaining("Price history isn't available"), findsOneWidget);
    expect(find.textContaining('Average across Maharashtra'), findsOneWidget);
  });
}
