import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/live_mandi_price.dart';
import '../domain/live_mandi_repository.dart';
import 'mandi_api_cache.dart';

/// Mandi Price API — free and keyless (https://mandi-api.onrender.com/v1,
/// docs at https://mandi-api.vercel.app/docs). Daily prices per state,
/// sourced from data.gov.in. Because there is no secret to protect it is
/// called straight from the app, like Open-Meteo.
///
/// The API allows 100 requests per 15 minutes per IP, so every response is
/// cached: fresh entries (< [freshFor]) skip the network entirely, and when
/// the network fails the last saved response is returned with
/// `fromCache: true`.
class MandiApiRepository implements LiveMandiRepository {
  MandiApiRepository({
    required MandiApiCache cache,
    http.Client? client,
    this.baseUrl = 'https://mandi-api.onrender.com',
    this.freshFor = const Duration(minutes: 30),
    this.timeout = const Duration(seconds: 25), // free hosting can cold-start slowly
  })  : _cache = cache,
        _client = client ?? http.Client();

  final MandiApiCache _cache;
  final http.Client _client;
  final String baseUrl;
  final Duration freshFor;
  final Duration timeout;

  @override
  Future<MandiResult<List<LiveMandiPrice>>> fetchPrices({
    required String state,
    String? commodity,
    String? market,
    String? variety,
    DateTime? date,
  }) {
    return _get(
      '/v1/prices',
      {'state': state, 'commodity': commodity, 'market': market, 'variety': variety, 'date': date == null ? null : _ymd(date)},
      (list) => [for (final row in list) LiveMandiPrice.fromJson(row as Map<String, dynamic>)],
    );
  }

  @override
  Future<MandiResult<List<MandiHistoryPoint>>> fetchHistory({
    required String state,
    required String commodity,
    String? market,
    required DateTime from,
    required DateTime to,
  }) {
    return _get(
      '/v1/prices/history',
      {'state': state, 'commodity': commodity, 'market': market, 'from': _ymd(from), 'to': _ymd(to)},
      (list) {
        final points = [for (final row in list) MandiHistoryPoint.fromJson(row as Map<String, dynamic>)]
          ..sort((a, b) => a.date.compareTo(b.date));
        return points;
      },
    );
  }

  @override
  Future<MandiResult<List<MandiMarket>>> fetchMarkets(String state) {
    return _get(
      '/v1/markets',
      {'state': state},
      (list) => [for (final row in list) MandiMarket.fromJson(row as Map<String, dynamic>)],
    );
  }

  @override
  Future<MandiResult<List<String>>> fetchCommodities({required String state, String? market}) {
    return _get(
      '/v1/commodities',
      {'state': state, 'market': market},
      (list) => [for (final c in list) '$c'.trim()],
    );
  }

  Future<MandiResult<T>> _get<T>(
    String path,
    Map<String, String?> query,
    T Function(List<dynamic> data) parse,
  ) async {
    final params = {
      for (final e in query.entries)
        if (e.value != null && e.value!.trim().isNotEmpty) e.key: e.value!.trim(),
    };
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    final cacheKey = '$path?${(params.keys.toList()..sort()).map((k) => '$k=${params[k]}').join('&')}';

    final cached = _cache.read(cacheKey);
    if (cached != null && _cache.isFresh(cached.savedAt, freshFor)) {
      final parsed = _tryParse(cached.body, parse);
      if (parsed != null) return MandiResult(parsed, cachedAt: cached.savedAt);
    }

    try {
      final response = await _client.get(uri).timeout(timeout);
      final body = response.body;

      if (response.statusCode == 429) throw const MandiRateLimitedException();

      Map<String, dynamic>? json;
      try {
        json = jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        throw MandiFetchException('HTTP ${response.statusCode}: unreadable body');
      }

      if (json['success'] != true) {
        final code = (json['error'] as Map?)?['code'];
        if (code == 'INVALID_STATE') throw const MandiUnsupportedStateException();
        throw MandiFetchException('HTTP ${response.statusCode}: ${code ?? 'error'}');
      }

      final parsed = _tryParse(body, parse);
      if (parsed == null) throw const MandiFetchException('unexpected response shape');
      await _cache.write(cacheKey, body);
      return MandiResult(parsed);
    } on MandiUnsupportedStateException {
      rethrow;
    } on MandiException catch (e) {
      return _fallback(cached, parse, e);
    } on TimeoutException {
      return _fallback(cached, parse, const MandiOfflineException());
    } on http.ClientException {
      return _fallback(cached, parse, const MandiOfflineException());
    } catch (e) {
      // SocketException and friends — treat any transport failure as offline.
      return _fallback(cached, parse, const MandiOfflineException());
    }
  }

  /// Older saved data beats an error screen; only throw when there is none.
  MandiResult<T> _fallback<T>(
    ({String body, DateTime savedAt})? cached,
    T Function(List<dynamic>) parse,
    MandiException error,
  ) {
    if (cached != null) {
      final parsed = _tryParse(cached.body, parse);
      if (parsed != null) return MandiResult(parsed, fromCache: true, cachedAt: cached.savedAt);
    }
    throw error;
  }

  T? _tryParse<T>(String body, T Function(List<dynamic>) parse) {
    try {
      final data = (jsonDecode(body) as Map<String, dynamic>)['data'] as List<dynamic>;
      return parse(data);
    } catch (_) {
      return null;
    }
  }

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
