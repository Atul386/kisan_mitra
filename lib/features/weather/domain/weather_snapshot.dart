import 'package:flutter/material.dart';

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.windSpeedKmh,
    required this.rainProbabilityTodayPercent,
    required this.rainProbabilityTomorrowPercent,
    required this.fetchedAt,
    this.weatherCode = 0,
    this.daily = const [],
    this.hourly = const [],
    this.feelsLikeCelsius,
    this.rainfallMm,
    this.uvIndex,
    this.sunrise,
    this.sunset,
  });

  /// Sample data for UI preview / demos (see `kUseDummyWeather`).
  factory WeatherSnapshot.demo() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const dayCodes = [1, 2, 61, 80, 95, 3, 0, 1, 2, 3, 61, 2, 1, 0, 1, 2];
    const maxes = [34.0, 33.0, 29.0, 28.0, 27.0, 31.0, 35.0, 34.0, 33.0, 31.0, 29.0, 30.0, 32.0, 34.0, 35.0, 33.0];
    const mins = [23.0, 23.0, 22.0, 21.0, 21.0, 22.0, 24.0, 24.0, 23.0, 22.0, 21.0, 22.0, 23.0, 24.0, 24.0, 23.0];
    const rains = [10, 20, 75, 80, 90, 35, 5, 5, 15, 30, 70, 25, 10, 5, 5, 15];
    const rainMm = [0.0, 0.4, 12.0, 18.5, 26.0, 2.0, 0.0, 0.0, 0.3, 1.5, 9.0, 0.8, 0.0, 0.0, 0.0, 0.2];
    const hourTemps = [31.0, 32.0, 33.0, 34.0, 33.0, 31.0, 29.0, 27.0, 26.0, 25.0, 24.0, 24.0];
    const hourCodes = [1, 1, 2, 2, 3, 61, 61, 3, 2, 0, 0, 1];
    const hourRain = [5, 5, 10, 15, 30, 65, 70, 40, 20, 10, 5, 5];
    final startHour = DateTime(now.year, now.month, now.day, now.hour);
    return WeatherSnapshot(
      temperatureCelsius: 32,
      feelsLikeCelsius: 36,
      rainfallMm: 0,
      humidityPercent: 68,
      windSpeedKmh: 14,
      uvIndex: 8.5,
      rainProbabilityTodayPercent: 10,
      rainProbabilityTomorrowPercent: 20,
      fetchedAt: now,
      weatherCode: 2,
      sunrise: today.add(const Duration(hours: 6, minutes: 8)),
      sunset: today.add(const Duration(hours: 18, minutes: 41)),
      hourly: [
        for (var i = 0; i < hourTemps.length; i++)
          HourlyForecast(
            time: startHour.add(Duration(hours: i)),
            celsius: hourTemps[i],
            rainProbabilityPercent: hourRain[i],
            weatherCode: hourCodes[i],
          ),
      ],
      daily: [
        for (var i = 0; i < 16; i++)
          DailyForecast(
            date: today.add(Duration(days: i)),
            maxCelsius: maxes[i],
            minCelsius: mins[i],
            rainProbabilityPercent: rains[i],
            weatherCode: dayCodes[i],
            rainMm: rainMm[i],
          ),
      ],
    );
  }

  final double temperatureCelsius;
  final double humidityPercent;
  final double windSpeedKmh;
  final int rainProbabilityTodayPercent;
  final int rainProbabilityTomorrowPercent;
  final DateTime fetchedAt;

  /// Open-Meteo's WMO weather code for the current conditions — see
  /// [WeatherCondition.fromCode]. Defaults to 0 (clear) for cached
  /// snapshots written before this field existed.
  final int weatherCode;

  /// Up to 16 days starting today. Empty for snapshots cached before the
  /// forecast was added.
  final List<DailyForecast> daily;

  /// Next ~24 hours, hour by hour. Empty for older cached snapshots.
  final List<HourlyForecast> hourly;

  final double? feelsLikeCelsius;

  /// Rain falling right now (mm), from the current conditions.
  final double? rainfallMm;
  final double? uvIndex;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  Map<String, dynamic> toJson() => {
    'temperatureCelsius': temperatureCelsius,
    'humidityPercent': humidityPercent,
    'windSpeedKmh': windSpeedKmh,
    'rainProbabilityTodayPercent': rainProbabilityTodayPercent,
    'rainProbabilityTomorrowPercent': rainProbabilityTomorrowPercent,
    'fetchedAt': fetchedAt.toIso8601String(),
    'weatherCode': weatherCode,
    'daily': daily.map((d) => d.toJson()).toList(),
    'hourly': hourly.map((h) => h.toJson()).toList(),
    'feelsLikeCelsius': feelsLikeCelsius,
    'rainfallMm': rainfallMm,
    'uvIndex': uvIndex,
    'sunrise': sunrise?.toIso8601String(),
    'sunset': sunset?.toIso8601String(),
  };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) => WeatherSnapshot(
    temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
    humidityPercent: (json['humidityPercent'] as num).toDouble(),
    windSpeedKmh: (json['windSpeedKmh'] as num).toDouble(),
    rainProbabilityTodayPercent: json['rainProbabilityTodayPercent'] as int,
    rainProbabilityTomorrowPercent: json['rainProbabilityTomorrowPercent'] as int,
    fetchedAt: DateTime.parse(json['fetchedAt'] as String),
    weatherCode: json['weatherCode'] as int? ?? 0,
    daily: (json['daily'] as List?)?.map((d) => DailyForecast.fromJson(d as Map<String, dynamic>)).toList() ?? const [],
    hourly:
        (json['hourly'] as List?)?.map((h) => HourlyForecast.fromJson(h as Map<String, dynamic>)).toList() ?? const [],
    feelsLikeCelsius: (json['feelsLikeCelsius'] as num?)?.toDouble(),
    rainfallMm: (json['rainfallMm'] as num?)?.toDouble(),
    uvIndex: (json['uvIndex'] as num?)?.toDouble(),
    sunrise: json['sunrise'] == null ? null : DateTime.parse(json['sunrise'] as String),
    sunset: json['sunset'] == null ? null : DateTime.parse(json['sunset'] as String),
  );
}

class HourlyForecast {
  const HourlyForecast({
    required this.time,
    required this.celsius,
    required this.rainProbabilityPercent,
    required this.weatherCode,
  });

  final DateTime time;
  final double celsius;
  final int rainProbabilityPercent;
  final int weatherCode;

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'celsius': celsius,
    'rainProbabilityPercent': rainProbabilityPercent,
    'weatherCode': weatherCode,
  };

  factory HourlyForecast.fromJson(Map<String, dynamic> json) => HourlyForecast(
    time: DateTime.parse(json['time'] as String),
    celsius: (json['celsius'] as num).toDouble(),
    rainProbabilityPercent: json['rainProbabilityPercent'] as int,
    weatherCode: json['weatherCode'] as int,
  );
}

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.maxCelsius,
    required this.minCelsius,
    required this.rainProbabilityPercent,
    required this.weatherCode,
    this.rainMm,
  });

  final DateTime date;
  final double maxCelsius;
  final double minCelsius;
  final int rainProbabilityPercent;
  final int weatherCode;

  /// Total rain expected that day (mm); null if the forecast didn't give one.
  final double? rainMm;

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'rainMm': rainMm,
    'maxCelsius': maxCelsius,
    'minCelsius': minCelsius,
    'rainProbabilityPercent': rainProbabilityPercent,
    'weatherCode': weatherCode,
  };

  factory DailyForecast.fromJson(Map<String, dynamic> json) => DailyForecast(
    date: DateTime.parse(json['date'] as String),
    maxCelsius: (json['maxCelsius'] as num).toDouble(),
    minCelsius: (json['minCelsius'] as num).toDouble(),
    rainProbabilityPercent: json['rainProbabilityPercent'] as int,
    weatherCode: json['weatherCode'] as int,
    rainMm: (json['rainMm'] as num?)?.toDouble(),
  );
}

/// Buckets Open-Meteo's WMO weather codes (open-meteo.com/en/docs, field
/// `weather_code`) into the handful of conditions the UI actually
/// distinguishes, each with an icon — avoids needing per-code localized
/// strings for all ~28 WMO codes.
enum WeatherCondition {
  clear,
  cloudy,
  fog,
  rain,
  storm,
  snow;

  static WeatherCondition fromCode(int code) {
    if (code == 0 || code == 1) return WeatherCondition.clear;
    if (code == 2 || code == 3) return WeatherCondition.cloudy;
    if (code == 45 || code == 48) return WeatherCondition.fog;
    if (code >= 51 && code <= 67) return WeatherCondition.rain;
    if (code >= 80 && code <= 82) return WeatherCondition.rain;
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) return WeatherCondition.snow;
    if (code == 95 || code == 96 || code == 99) return WeatherCondition.storm;
    return WeatherCondition.clear;
  }
}

extension WeatherConditionIcon on WeatherCondition {
  IconData get icon {
    switch (this) {
      case WeatherCondition.clear:
        return Icons.wb_sunny_rounded;
      case WeatherCondition.cloudy:
        return Icons.wb_cloudy_rounded;
      case WeatherCondition.fog:
        return Icons.foggy;
      case WeatherCondition.rain:
        return Icons.water_drop_rounded;
      case WeatherCondition.storm:
        return Icons.thunderstorm_rounded;
      case WeatherCondition.snow:
        return Icons.ac_unit_rounded;
    }
  }
}

extension WeatherConditionGradient on WeatherCondition {
  List<Color> get gradient {
    switch (this) {
      case WeatherCondition.clear:
        return const [Color(0xFF1E88E5), Color(0xFF64B5F6)];
      case WeatherCondition.cloudy:
        return const [Color(0xFF546E7A), Color(0xFF90A4AE)];
      case WeatherCondition.fog:
        return const [Color(0xFF78909C), Color(0xFFB0BEC5)];
      case WeatherCondition.rain:
        return const [Color(0xFF1A4F8B), Color(0xFF5C8DC4)];
      case WeatherCondition.storm:
        return const [Color(0xFF263238), Color(0xFF5C6BC0)];
      case WeatherCondition.snow:
        return const [Color(0xFF5C9CD6), Color(0xFFBBDEFB)];
    }
  }
}
