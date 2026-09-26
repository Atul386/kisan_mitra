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
  });

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

  WeatherCondition get condition => WeatherCondition.fromCode(weatherCode);

  Map<String, dynamic> toJson() => {
        'temperatureCelsius': temperatureCelsius,
        'humidityPercent': humidityPercent,
        'windSpeedKmh': windSpeedKmh,
        'rainProbabilityTodayPercent': rainProbabilityTodayPercent,
        'rainProbabilityTomorrowPercent': rainProbabilityTomorrowPercent,
        'fetchedAt': fetchedAt.toIso8601String(),
        'weatherCode': weatherCode,
      };

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) => WeatherSnapshot(
        temperatureCelsius: (json['temperatureCelsius'] as num).toDouble(),
        humidityPercent: (json['humidityPercent'] as num).toDouble(),
        windSpeedKmh: (json['windSpeedKmh'] as num).toDouble(),
        rainProbabilityTodayPercent: json['rainProbabilityTodayPercent'] as int,
        rainProbabilityTomorrowPercent: json['rainProbabilityTomorrowPercent'] as int,
        fetchedAt: DateTime.parse(json['fetchedAt'] as String),
        weatherCode: json['weatherCode'] as int? ?? 0,
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
