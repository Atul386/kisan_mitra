import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/shared_preferences_provider.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/open_meteo_weather_repository.dart';
import 'data/weather_cache.dart';
import 'domain/weather_advice.dart';
import 'domain/weather_repository.dart';
import 'domain/weather_snapshot.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) => OpenMeteoWeatherRepository());

final weatherCacheProvider = Provider<WeatherCache>((ref) {
  return WeatherCache(ref.watch(sharedPreferencesProvider));
});

const weatherRulesEngine = WeatherRulesEngine();

/// Fetches fresh weather for the farmer's primary farm; falls back to the
/// last cached response on failure so the card still shows something
/// useful offline (§7, §17, §34). Returns null only when the farm has no
/// location yet.
final currentWeatherProvider = FutureProvider<WeatherSnapshot?>((ref) async {
  final farm = ref.watch(primaryFarmProvider);
  if (farm == null || !farm.hasLocation) return null;

  final cache = ref.watch(weatherCacheProvider);
  try {
    final snapshot = await ref
        .watch(weatherRepositoryProvider)
        .fetchWeather(latitude: farm.latitude!, longitude: farm.longitude!);
    await cache.write(farm.id, snapshot);
    return snapshot;
  } catch (_) {
    return cache.read(farm.id);
  }
});

final weatherAdviceProvider = Provider<List<WeatherAdvice>>((ref) {
  final snapshot = ref.watch(currentWeatherProvider).value;
  if (snapshot == null) return const [];
  return weatherRulesEngine.adviceFor(snapshot);
});
