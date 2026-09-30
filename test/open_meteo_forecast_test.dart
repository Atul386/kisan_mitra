import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kisan_mitra/features/weather/data/open_meteo_weather_repository.dart';
import 'package:kisan_mitra/features/weather/domain/weather_snapshot.dart';

void main() {
  final body = {
    'current': {
      'temperature_2m': 28.4,
      'relative_humidity_2m': 68,
      'wind_speed_10m': 12.0,
      'weather_code': 2,
      'precipitation': 0.6,
    },
    'daily': {
      'time': ['2026-06-25', '2026-06-26', '2026-06-27'],
      'weather_code': [61, 3, null],
      'temperature_2m_max': [32.1, 30.0, null], // last day unforecastable
      'temperature_2m_min': [22.4, 21.0, 20.0],
      'precipitation_probability_max': [70, null, 10],
      'precipitation_sum': [12.5, null, 0.0],
    },
  };

  test('parses the daily forecast and skips days with missing temperatures', () async {
    late Uri requested;
    final repo = OpenMeteoWeatherRepository(
      client: MockClient((request) async {
        requested = request.url;
        return http.Response(jsonEncode(body), 200);
      }),
    );

    final snapshot = await repo.fetchWeather(latitude: 18.52, longitude: 73.85);

    expect(requested.queryParameters['forecast_days'], '16');
    expect(snapshot.rainProbabilityTodayPercent, 70);
    expect(snapshot.rainProbabilityTomorrowPercent, 0);
    expect(snapshot.daily, hasLength(2));
    expect(snapshot.daily[0].date, DateTime(2026, 6, 25));
    expect(snapshot.daily[0].maxCelsius, 32.1);
    expect(snapshot.daily[0].condition, WeatherCondition.rain);
    expect(snapshot.daily[1].rainProbabilityPercent, 0);
    expect(snapshot.rainfallMm, 0.6);
    expect(snapshot.daily[0].rainMm, 12.5);
    expect(snapshot.daily[1].rainMm, isNull, reason: 'a missing value stays unknown, not zero');
  });

  test('forecast survives the offline cache round-trip; old cached data has none', () async {
    final repo = OpenMeteoWeatherRepository(client: MockClient((_) async => http.Response(jsonEncode(body), 200)));
    final snapshot = await repo.fetchWeather(latitude: 18.52, longitude: 73.85);

    final restored = WeatherSnapshot.fromJson(jsonDecode(jsonEncode(snapshot.toJson())) as Map<String, dynamic>);
    expect(restored.daily.map((d) => d.maxCelsius), [32.1, 30.0]);
    expect(restored.daily.first.rainMm, 12.5);
    expect(restored.rainfallMm, 0.6);

    final legacy = snapshot.toJson()..remove('daily');
    expect(WeatherSnapshot.fromJson(legacy).daily, isEmpty);
  });
}
