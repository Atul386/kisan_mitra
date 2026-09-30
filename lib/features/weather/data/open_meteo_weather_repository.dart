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
      'current': 'temperature_2m,apparent_temperature,relative_humidity_2m,wind_speed_10m,weather_code,precipitation',
      'hourly': 'temperature_2m,precipitation_probability,weather_code',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,'
          'precipitation_sum,uv_index_max,sunrise,sunset',
      'forecast_hours': '24',
      'timezone': 'auto',
      'forecast_days': '16',
    });

    final response = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw WeatherFetchException('Weather API returned ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final current = body['current'] as Map<String, dynamic>;
    final daily = body['daily'] as Map<String, dynamic>;
    // Open-Meteo returns null entries for values it can't forecast.
    List<num> series(String key, num fallback) =>
        ((daily[key] as List?) ?? const []).map((v) => (v as num?) ?? fallback).toList();
    final dates = ((daily['time'] as List?) ?? const []).cast<String>();
    final rainProbabilities = series('precipitation_probability_max', 0);
    final maxTemps = series('temperature_2m_max', double.nan);
    final minTemps = series('temperature_2m_min', double.nan);
    final codes = series('weather_code', 0);
    final rainTotals = ((daily['precipitation_sum'] as List?) ?? const []);

    final forecast = <DailyForecast>[
      for (var i = 0; i < dates.length; i++)
        if (i < maxTemps.length && i < minTemps.length && !maxTemps[i].isNaN && !minTemps[i].isNaN)
          DailyForecast(
            date: DateTime.parse(dates[i]),
            maxCelsius: maxTemps[i].toDouble(),
            minCelsius: minTemps[i].toDouble(),
            rainProbabilityPercent: i < rainProbabilities.length ? rainProbabilities[i].toInt() : 0,
            weatherCode: i < codes.length ? codes[i].toInt() : 0,
            rainMm: i < rainTotals.length ? (rainTotals[i] as num?)?.toDouble() : null,
          ),
    ];

    final hourlyBody = body['hourly'] as Map<String, dynamic>?;
    final hourly = <HourlyForecast>[];
    if (hourlyBody != null) {
      final times = ((hourlyBody['time'] as List?) ?? const []).cast<String>();
      final temps = (hourlyBody['temperature_2m'] as List?) ?? const [];
      final rain = (hourlyBody['precipitation_probability'] as List?) ?? const [];
      final hCodes = (hourlyBody['weather_code'] as List?) ?? const [];
      for (var i = 0; i < times.length && i < temps.length; i++) {
        final temp = temps[i] as num?;
        if (temp == null) continue;
        hourly.add(
          HourlyForecast(
            time: DateTime.parse(times[i]),
            celsius: temp.toDouble(),
            rainProbabilityPercent: i < rain.length ? (rain[i] as num?)?.toInt() ?? 0 : 0,
            weatherCode: i < hCodes.length ? (hCodes[i] as num?)?.toInt() ?? 0 : 0,
          ),
        );
      }
    }
    DateTime? firstTime(String key) {
      final list = (daily[key] as List?) ?? const [];
      return list.isEmpty || list.first == null ? null : DateTime.parse(list.first as String);
    }

    final uvList = (daily['uv_index_max'] as List?) ?? const [];

    return WeatherSnapshot(
      temperatureCelsius: (current['temperature_2m'] as num).toDouble(),
      humidityPercent: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeedKmh: (current['wind_speed_10m'] as num).toDouble(),
      rainProbabilityTodayPercent: rainProbabilities.isNotEmpty ? rainProbabilities[0].toInt() : 0,
      rainProbabilityTomorrowPercent: rainProbabilities.length > 1 ? rainProbabilities[1].toInt() : 0,
      fetchedAt: DateTime.now(),
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      daily: forecast,
      hourly: hourly,
      feelsLikeCelsius: (current['apparent_temperature'] as num?)?.toDouble(),
      rainfallMm: (current['precipitation'] as num?)?.toDouble(),
      uvIndex: uvList.isEmpty ? null : (uvList.first as num?)?.toDouble(),
      sunrise: firstTime('sunrise'),
      sunset: firstTime('sunset'),
    );
  }
}

class WeatherFetchException implements Exception {
  WeatherFetchException(this.message);
  final String message;

  @override
  String toString() => message;
}
