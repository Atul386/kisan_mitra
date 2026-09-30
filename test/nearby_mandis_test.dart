import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/core/utils/shared_preferences_provider.dart';
import 'package:kisan_mitra/features/dashboard/dashboard_providers.dart';
import 'package:kisan_mitra/features/farm/domain/farm.dart';
import 'package:kisan_mitra/features/mandi/domain/live_mandi_price.dart';
import 'package:kisan_mitra/features/mandi/domain/live_mandi_repository.dart';
import 'package:kisan_mitra/features/mandi/domain/nearby_mandis.dart';
import 'package:kisan_mitra/features/mandi/mandi_providers.dart';
import 'package:kisan_mitra/features/mandi/presentation/nearby_mandis_screen.dart';
import 'package:kisan_mitra/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const nagpur1 = MandiMarket(market: 'APMC Nagpur', district: 'Nagpur');
const nagpur2 = MandiMarket(market: 'Katol APMC', district: 'Nagpur');
const nashik1 = MandiMarket(market: 'Lasalgaon APMC', district: 'Nashik');
const nashik2 = MandiMarket(market: 'APMC Umrane', district: 'Nashik');
const akola = MandiMarket(market: 'Akola APMC', district: 'Akola');

class FakeRepo implements LiveMandiRepository {
  FakeRepo(this.markets, {this.error});
  final List<MandiMarket> markets;
  final MandiException? error;

  @override
  Future<MandiResult<List<MandiMarket>>> fetchMarkets(String state) async {
    if (error != null) throw error!;
    return MandiResult(markets);
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

void main() {
  group('groupMarkets', () {
    test('puts the farmer\'s district first and the rest grouped A–Z', () {
      final g = groupMarkets([nashik1, akola, nagpur2, nashik2, nagpur1], district: 'Nashik');
      expect(g.inDistrict.map((m) => m.market), ['APMC Umrane', 'Lasalgaon APMC']);
      expect(g.otherDistricts.keys, ['Akola', 'Nagpur']);
      expect(g.otherDistricts['Nagpur']!.map((m) => m.market), ['APMC Nagpur', 'Katol APMC']);
    });

    test('district matching ignores case and stray spaces', () {
      final g = groupMarkets([nagpur1, akola], district: '  nagpur ');
      expect(g.inDistrict, [nagpur1]);
      expect(g.otherDistricts.keys, ['Akola']);
    });

    test('an unknown district leaves the local group empty but keeps every market', () {
      final g = groupMarkets([nagpur1, akola], district: 'Pune');
      expect(g.inDistrict, isEmpty);
      expect(g.otherDistricts.keys, ['Akola', 'Nagpur']);
    });

    test('with no district everything is listed by district', () {
      final g = groupMarkets([nagpur1, akola]);
      expect(g.inDistrict, isEmpty);
      expect(g.otherDistricts.keys, ['Akola', 'Nagpur']);
      expect(groupMarkets([nagpur1], district: '').otherDistricts.keys, ['Nagpur']);
    });

    test('duplicate and unnamed markets are dropped', () {
      final g = groupMarkets([nagpur1, nagpur1, const MandiMarket(market: '', district: 'Nagpur')], district: 'Nagpur');
      expect(g.inDistrict, [nagpur1]);
    });

    test('nothing in, nothing out', () {
      expect(groupMarkets(const [], district: 'Nagpur').isEmpty, isTrue);
    });
  });

  test('the maps link searches the market by name, district and state', () {
    final uri = mandiMapsUri(nagpur1, 'Maharashtra');
    expect(uri.host, 'www.google.com');
    expect(uri.queryParameters['query'], 'APMC Nagpur, Nagpur, Maharashtra');
  });

  group('screen', () {
    Farm farmIn(String? district) => Farm(
          id: 'f1',
          userId: 'u1',
          name: 'Home',
          area: 5,
          areaUnit: AreaUnit.acre,
          district: district,
        );

    Future<void> pump(WidgetTester tester, FakeRepo repo, {String? district}) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tester.view.physicalSize = const Size(720, 3000);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          liveMandiRepositoryProvider.overrideWithValue(repo),
          mandiStateProvider.overrideWithValue('Maharashtra'),
          primaryFarmProvider.overrideWithValue(farmIn(district)),
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
          home: const NearbyMandisScreen(),
        ),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('opens on the farm\'s district, with other districts below', (tester) async {
      await pump(tester, FakeRepo([nagpur1, nagpur2, nashik1, akola]), district: 'Nashik');
      expect(find.text('In Nashik'), findsOneWidget);
      expect(find.text('Lasalgaon APMC'), findsOneWidget);
      expect(find.text('Other districts'), findsOneWidget);
      expect(find.text('APMC Nagpur'), findsOneWidget);
      expect(find.textContaining("Distances aren't shown"), findsOneWidget);
      expect(find.text('Directions'), findsNWidgets(4));
      expect(find.text('Prices'), findsNWidgets(4));
    });

    testWidgets('says so when the farm\'s district has no listed mandi', (tester) async {
      await pump(tester, FakeRepo([nagpur1, akola]), district: 'Pune');
      expect(find.textContaining('No mandis listed in Pune'), findsOneWidget);
      expect(find.text('APMC Nagpur'), findsOneWidget);
    });

    testWidgets('with no known district it asks the farmer to choose one', (tester) async {
      await pump(tester, FakeRepo([nagpur1, akola]));
      expect(find.text('Choose your district'), findsOneWidget);
      expect(find.text('All markets'), findsOneWidget);
    });

    testWidgets('the farmer can pick a district by hand', (tester) async {
      await pump(tester, FakeRepo([nagpur1, nagpur2, akola]));
      await tester.tap(find.text('Choose your district'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Akola').last);
      await tester.pumpAndSettle();
      expect(find.text('In Akola'), findsOneWidget);
      expect(find.text('Akola APMC'), findsOneWidget);
    });

    testWidgets('a failure shows a friendly message with a retry, never the raw error', (tester) async {
      await pump(tester, FakeRepo(const [], error: const MandiFetchException('HTTP 500: boom')), district: 'Nashik');
      expect(find.textContaining('Unable to load prices'), findsOneWidget);
      expect(find.textContaining('boom'), findsNothing);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}
