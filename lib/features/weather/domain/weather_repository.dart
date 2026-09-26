import 'weather_snapshot.dart';

/// Today backed by [OpenMeteoWeatherRepository] (free, no API key). Swap
/// for a different provider later without touching the UI or the rules
/// engine (blueprint §17, §35).
abstract class WeatherRepository {
  Future<WeatherSnapshot> fetchWeather({required double latitude, required double longitude});
}
