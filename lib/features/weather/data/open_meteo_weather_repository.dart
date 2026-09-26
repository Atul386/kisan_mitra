import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/weather_repository.dart';
import '../domain/weather_snapshot.dart';

/// Open-Meteo (https://open-meteo.com) needs no API key, which is why it's
/// used directly from the Flutter app rather than through a Cloud
/// Function — unlike the AI assistant, there's no secret to protect
/// (blueprint §24 only requires that treatment for keyed providers).
class OpenMeteoWeatherRepository implements WeatherRepository {
  OpenMeteoWeatherRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<WeatherSnapshot> fetchWeather({required double latitude, required double longitude}) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toStringAsFixed(4),
      'longitude': longitude.toStringAsFixed(4),
      'current': 'temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code',
      'daily': 'precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '2',
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw WeatherFetchException('Weather API returned ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final current = body['current'] as Map<String, dynamic>;
    final daily = body['daily'] as Map<String, dynamic>;
    final rainProbabilities = (daily['precipitation_probability_max'] as List).cast<num>();

    return WeatherSnapshot(
      temperatureCelsius: (current['temperature_2m'] as num).toDouble(),
      humidityPercent: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeedKmh: (current['wind_speed_10m'] as num).toDouble(),
      rainProbabilityTodayPercent: rainProbabilities.isNotEmpty ? rainProbabilities[0].toInt() : 0,
      rainProbabilityTomorrowPercent: rainProbabilities.length > 1 ? rainProbabilities[1].toInt() : 0,
      fetchedAt: DateTime.now(),
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
    );
  }
}

class WeatherFetchException implements Exception {
  WeatherFetchException(this.message);
  final String message;

  @override
  String toString() => message;
}
