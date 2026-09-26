import 'package:flutter_test/flutter_test.dart';
import 'package:kisan_mitra/features/weather/domain/weather_advice.dart';
import 'package:kisan_mitra/features/weather/domain/weather_snapshot.dart';

WeatherSnapshot _snapshot({
  double temp = 28,
  int rainToday = 10,
  int rainTomorrow = 10,
}) {
  return WeatherSnapshot(
    temperatureCelsius: temp,
    humidityPercent: 60,
    windSpeedKmh: 10,
    rainProbabilityTodayPercent: rainToday,
    rainProbabilityTomorrowPercent: rainTomorrow,
    fetchedAt: DateTime.now(),
  );
}

void main() {
  const engine = WeatherRulesEngine();

  test('high rain tomorrow triggers avoid-spraying and no-irrigation advice', () {
    final advice = engine.adviceFor(_snapshot(rainTomorrow: 80));
    expect(advice, containsAll([WeatherAdvice.avoidSpraying, WeatherAdvice.irrigationNotNeeded]));
  });

  test('heavy rain today triggers drainage check', () {
    final advice = engine.adviceFor(_snapshot(rainToday: 85));
    expect(advice, contains(WeatherAdvice.checkDrainage));
  });

  test('low rain both days is flagged as good spraying weather', () {
    final advice = engine.adviceFor(_snapshot(rainToday: 5, rainTomorrow: 5));
    expect(advice, contains(WeatherAdvice.goodSprayingConditions));
  });

  test('hot day triggers heat advice', () {
    final advice = engine.adviceFor(_snapshot(temp: 38));
    expect(advice, contains(WeatherAdvice.hotDay));
  });

  test('mild weather with no rain risk gives good-spraying-conditions and nothing else', () {
    final advice = engine.adviceFor(_snapshot(temp: 26, rainToday: 15, rainTomorrow: 20));
    expect(advice, [WeatherAdvice.goodSprayingConditions]);
  });
}
