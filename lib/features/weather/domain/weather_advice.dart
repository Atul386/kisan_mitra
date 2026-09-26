import 'weather_snapshot.dart';

/// Translates raw weather into farmer actions (blueprint §17, §68) — kept
/// separate from [WeatherSnapshot] so the UI maps each advice to localized
/// text rather than the domain layer holding hardcoded English strings.
enum WeatherAdvice {
  avoidSpraying,
  irrigationNotNeeded,
  checkDrainage,
  goodSprayingConditions,
  hotDay,
}

class WeatherRulesEngine {
  const WeatherRulesEngine();

  List<WeatherAdvice> adviceFor(WeatherSnapshot snapshot) {
    final advice = <WeatherAdvice>[];

    final highRainTomorrow = snapshot.rainProbabilityTomorrowPercent >= 60;
    final highRainToday = snapshot.rainProbabilityTodayPercent >= 70;
    final lowRainBoth =
        snapshot.rainProbabilityTodayPercent < 30 && snapshot.rainProbabilityTomorrowPercent < 30;

    if (highRainTomorrow) {
      advice.add(WeatherAdvice.avoidSpraying);
      advice.add(WeatherAdvice.irrigationNotNeeded);
    }
    if (highRainToday) {
      advice.add(WeatherAdvice.checkDrainage);
    }
    if (lowRainBoth) {
      advice.add(WeatherAdvice.goodSprayingConditions);
    }
    if (snapshot.temperatureCelsius >= 35) {
      advice.add(WeatherAdvice.hotDay);
    }

    return advice;
  }
}
