import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kisan_mitra/features/mandi/data/mandi_api_cache.dart';
import 'package:kisan_mitra/features/mandi/data/mandi_api_repository.dart';
import 'package:kisan_mitra/features/mandi/domain/live_mandi_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

String envelope(List<Map<String, dynamic>> data) => jsonEncode({'success': true, 'data': data, 'meta': {'count': data.length}});

const nagpur = {
  'state': 'Maharashtra',
  'district': 'Nagpur',
  'market': 'APMC Nagpur ', // the API pads some names with a trailing space
  'commodity': 'Onion',
  'variety': 'Red',
  'grade': 'Local',
  'arrival_date': '2026-09-24',
  'min_price': 3500,
  'max_price': 4500,
  'modal_price': 4250,
};
const nashik = {
  'state': 'Maharashtra',
  'district': 'Nashik',
  'market': 'APMC Umrane',
  'commodity': 'Onion',
  'variety': 'Unhali',
  'grade': 'Local',
  'arrival_date': '2026-09-24',
  'min_price': 1500,
  'max_price': 4750,
  'modal_price': 3600,
};

Future<MandiApiRepository> makeRepo(
  Future<http.Response> Function(http.Request) handler, {
  Duration freshFor = const Duration(minutes: 30),
  DateTime Function()? now,
  SharedPreferences? prefs,
}) async {
  SharedPreferences.setMockInitialValues({});
  final p = prefs ?? await SharedPreferences.getInstance();
  return MandiApiRepository(
    cache: MandiApiCache(p, now: now),
    client: MockClient(handler),
    freshFor: freshFor,
    timeout: const Duration(milliseconds: 200),
  );
}

void main() {
  test('parses prices, trims market names and reads the reported date', () async {
    final repo = await makeRepo((_) async => http.Response(envelope([nagpur, nashik]), 200));
    final result = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');

    expect(result.fromCache, isFalse);
    expect(result.value, hasLength(2));
    final first = result.value.first;
    expect(first.market, 'APMC Nagpur');
    expect(first.district, 'Nagpur');
    expect(first.modalPrice, 4250);
    expect(first.minPrice, 3500);
    expect(first.maxPrice, 4500);
    expect(first.arrivalDate, DateTime(2026, 9, 24));
  });

  test('sends only the filters that are set', () async {
    late Uri seen;
    final repo = await makeRepo((req) async {
      seen = req.url;
      return http.Response(envelope([]), 200);
    });
    await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion', market: '  ', variety: null);

    expect(seen.path, '/v1/prices');
    expect(seen.queryParameters, {'state': 'Maharashtra', 'commodity': 'Onion'});
  });

  test('an empty result is a normal empty list, not an error', () async {
    final repo = await makeRepo((_) async => http.Response(envelope([]), 200));
    final result = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Zzzz');
    expect(result.value, isEmpty);
  });

  test('history reads daily averages (statewide) and raw rows (one market)', () async {
    final statewide = jsonEncode({
      'success': true,
      'data': [
        {'arrival_date': '2026-09-02', 'avg_modal_price': 3828, 'avg_min_price': 2063, 'avg_max_price': 4731, 'data_points': 50},
        {'arrival_date': '2026-09-01', 'avg_modal_price': 3722, 'avg_min_price': 1851, 'avg_max_price': 4614, 'data_points': 48},
      ],
    });
    var repo = await makeRepo((_) async => http.Response(statewide, 200));
    var history = await repo.fetchHistory(
      state: 'Maharashtra',
      commodity: 'Onion',
      from: DateTime(2026, 9, 1),
      to: DateTime(2026, 9, 30),
    );
    expect(history.value.map((p) => p.modalPrice), [3722, 3828], reason: 'sorted oldest first');
    expect(history.value.first.minPrice, 1851);

    repo = await makeRepo((_) async => http.Response(envelope([nagpur]), 200));
    history = await repo.fetchHistory(
      state: 'Maharashtra',
      commodity: 'Onion',
      market: 'APMC Nagpur',
      from: DateTime(2026, 9, 1),
      to: DateTime(2026, 9, 30),
    );
    expect(history.value.single.modalPrice, 4250);
    expect(history.value.single.maxPrice, 4500);
  });

  test('markets and commodities parse', () async {
    var repo = await makeRepo(
      (_) async => http.Response(
        jsonEncode({
          'success': true,
          'data': [
            {'market': 'Akola APMC', 'district': 'Akola'},
          ],
        }),
        200,
      ),
    );
    final markets = await repo.fetchMarkets('Maharashtra');
    expect(markets.value.single.market, 'Akola APMC');
    expect(markets.value.single.district, 'Akola');

    repo = await makeRepo((_) async => http.Response(jsonEncode({'success': true, 'data': ['Onion', 'Wheat ']}), 200));
    final crops = await repo.fetchCommodities(state: 'Maharashtra');
    expect(crops.value, ['Onion', 'Wheat']);
  });

  test('an unsupported state is reported as such', () async {
    final body = jsonEncode({
      'success': false,
      'error': {'code': 'INVALID_STATE', 'message': 'Unknown state "Goa".'},
    });
    final repo = await makeRepo((_) async => http.Response(body, 404));
    expect(
      () => repo.fetchPrices(state: 'Goa', commodity: 'Onion'),
      throwsA(isA<MandiUnsupportedStateException>()),
    );
  });

  test('rate limiting and server errors throw friendly exceptions when nothing is saved', () async {
    var repo = await makeRepo((_) async => http.Response('Too Many Requests', 429));
    expect(() => repo.fetchPrices(state: 'Maharashtra'), throwsA(isA<MandiRateLimitedException>()));

    repo = await makeRepo((_) async => http.Response('<html>oops</html>', 500));
    expect(() => repo.fetchPrices(state: 'Maharashtra'), throwsA(isA<MandiFetchException>()));
  });

  test('no network and nothing saved throws an offline exception', () async {
    final repo = await makeRepo((_) async => throw http.ClientException('no route'));
    expect(() => repo.fetchPrices(state: 'Maharashtra'), throwsA(isA<MandiOfflineException>()));
  });

  test('a slow server times out as offline', () async {
    final repo = await makeRepo((_) => Completer<http.Response>().future);
    expect(() => repo.fetchPrices(state: 'Maharashtra'), throwsA(isA<MandiOfflineException>()));
  });

  test('fresh cached data skips the network entirely', () async {
    var calls = 0;
    final repo = await makeRepo((_) async {
      calls++;
      return http.Response(envelope([nagpur]), 200);
    });
    await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');
    final second = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');

    expect(calls, 1);
    expect(second.fromCache, isFalse, reason: 'fresh data is not flagged as offline data');
    expect(second.value.single.modalPrice, 4250);
  });

  test('when the network fails, stale saved data is returned and flagged', () async {
    var now = DateTime(2026, 9, 30, 10);
    var online = true;
    final repo = await makeRepo(
      (_) async {
        if (!online) throw http.ClientException('offline');
        return http.Response(envelope([nagpur]), 200);
      },
      now: () => now,
    );

    await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');
    now = now.add(const Duration(hours: 3)); // cache is now stale
    online = false;

    final result = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');
    expect(result.fromCache, isTrue);
    expect(result.cachedAt, DateTime(2026, 9, 30, 10));
    expect(result.value.single.market, 'APMC Nagpur');
  });

  test('saved data also covers rate limiting', () async {
    var now = DateTime(2026, 9, 30, 10);
    var limited = false;
    final repo = await makeRepo(
      (_) async => limited ? http.Response('', 429) : http.Response(envelope([nashik]), 200),
      now: () => now,
    );
    await repo.fetchPrices(state: 'Maharashtra');
    now = now.add(const Duration(hours: 2));
    limited = true;

    final result = await repo.fetchPrices(state: 'Maharashtra');
    expect(result.fromCache, isTrue);
    expect(result.value.single.district, 'Nashik');
  });

  test('different filters are cached separately', () async {
    final repo = await makeRepo((req) async {
      final crop = req.url.queryParameters['commodity'];
      return http.Response(envelope(crop == 'Onion' ? [nagpur] : [nashik]), 200);
    });
    final onion = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Onion');
    final other = await repo.fetchPrices(state: 'Maharashtra', commodity: 'Wheat');
    expect(onion.value.single.district, 'Nagpur');
    expect(other.value.single.district, 'Nashik');
  });

  test('the cache never grows past its limit', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final cache = MandiApiCache(prefs, maxEntries: 3);
    for (var i = 0; i < 6; i++) {
      await cache.write('k$i', 'body$i');
    }
    expect(cache.read('k0'), isNull);
    expect(cache.read('k2'), isNull);
    expect(cache.read('k3')?.body, 'body3');
    expect(cache.read('k5')?.body, 'body5');
  });
}
