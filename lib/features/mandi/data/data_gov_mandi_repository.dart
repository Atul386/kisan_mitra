import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/live_mandi_price.dart';

/// Government of India's open Agmarknet daily mandi price dataset
/// (data.gov.in resource `9ef84268-d588-465a-a308-a864a43d0070`) — a free
/// feed of prices markets actually reported, filtered by state/commodity.
///
/// The API key is a free self-serve registration key from
/// data.gov.in/user/register, not a paid or rate-limited-for-cost secret
/// like the AI assistant's key, so — same reasoning as
/// [OpenMeteoWeatherRepository] — it's called directly from the app
/// rather than proxied through a Cloud Function. It's read from a
/// build-time define (`--dart-define=MANDI_API_KEY=...`) so no key is
/// ever committed to the repo; see lib/features/mandi/README.md.
class DataGovMandiRepository {
  DataGovMandiRepository({required String apiKey, http.Client? client})
      : _apiKey = apiKey,
        _client = client ?? http.Client();

  static const _resourceId = '9ef84268-d588-465a-a308-a864a43d0070';

  final String _apiKey;
  final http.Client _client;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<List<LiveMandiPrice>> fetchPrices({
    required String state,
    String? commodity,
    int limit = 20,
  }) async {
    if (!isConfigured) throw MandiFeedNotConfiguredException();

    final uri = Uri.https('api.data.gov.in', '/resource/$_resourceId', {
      'api-key': _apiKey,
      'format': 'json',
      'limit': '$limit',
      'filters[state.keyword]': state,
      if (commodity != null && commodity.trim().isNotEmpty) 'filters[commodity]': commodity.trim(),
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw MandiFetchException('Mandi API returned ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final records = (body['records'] as List?) ?? const [];
    return records.map((r) => _fromRecord(r as Map<String, dynamic>)).toList();
  }

  LiveMandiPrice _fromRecord(Map<String, dynamic> r) {
    double parsePrice(dynamic v) => double.tryParse(v?.toString() ?? '') ?? 0;
    return LiveMandiPrice(
      state: r['state'] as String? ?? '',
      district: r['district'] as String? ?? '',
      market: r['market'] as String? ?? '',
      commodity: r['commodity'] as String? ?? '',
      variety: r['variety'] as String? ?? '',
      arrivalDate: r['arrival_date'] as String? ?? '',
      minPrice: parsePrice(r['min_price']),
      maxPrice: parsePrice(r['max_price']),
      modalPrice: parsePrice(r['modal_price']),
    );
  }
}

class MandiFeedNotConfiguredException implements Exception {}

class MandiFetchException implements Exception {
  MandiFetchException(this.message);
  final String message;

  @override
  String toString() => message;
}
