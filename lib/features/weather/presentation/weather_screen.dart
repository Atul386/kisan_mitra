import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../../farm/farm_providers.dart';
import '../domain/weather_advice.dart';
import '../domain/weather_snapshot.dart';
import '../weather_providers.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final _locationService = LocationService();
  bool _locating = false;

  Future<void> _useCurrentLocation() async {
    final farm = ref.read(primaryFarmProvider);
    if (farm == null) return;
    setState(() => _locating = true);
    try {
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        await ref.read(farmRepositoryProvider).setLocation(
              farmId: farm.id,
              latitude: position.latitude,
              longitude: position.longitude,
            );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  String _conditionText(AppLocalizations t, WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return t.weatherConditionClear;
      case WeatherCondition.cloudy:
        return t.weatherConditionCloudy;
      case WeatherCondition.fog:
        return t.weatherConditionFog;
      case WeatherCondition.rain:
        return t.weatherConditionRain;
      case WeatherCondition.storm:
        return t.weatherConditionStorm;
      case WeatherCondition.snow:
        return t.weatherConditionSnow;
    }
  }

  String _adviceText(AppLocalizations t, WeatherAdvice advice) {
    switch (advice) {
      case WeatherAdvice.avoidSpraying:
        return t.avoidSprayingAdvice;
      case WeatherAdvice.irrigationNotNeeded:
        return t.irrigationNotNeededAdvice;
      case WeatherAdvice.checkDrainage:
        return t.checkDrainageAdvice;
      case WeatherAdvice.goodSprayingConditions:
        return t.goodSprayingConditionsAdvice;
      case WeatherAdvice.hotDay:
        return t.hotDayAdvice;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final farm = ref.watch(primaryFarmProvider);
    final weatherAsync = ref.watch(currentWeatherProvider);
    final advice = ref.watch(weatherAdviceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.weatherTitle)),
      body: SafeArea(
        child: farm != null && !farm.hasLocation
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_off_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(t.addFarmLocationMessage, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: _locating ? null : _useCurrentLocation,
                        icon: const Icon(Icons.my_location_outlined),
                        label: Text(t.useCurrentLocation),
                      ),
                    ],
                  ),
                ),
              )
            : weatherAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(t.weatherUnavailableMessage, textAlign: TextAlign.center),
                  ),
                ),
                data: (snapshot) {
                  if (snapshot == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(t.weatherUnavailableMessage, textAlign: TextAlign.center),
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _WeatherHeader(snapshot: snapshot, conditionText: _conditionText(t, snapshot.condition)),
                      const SizedBox(height: 8),
                      Text(
                        t.lastUpdatedLabel('${snapshot.fetchedAt.hour.toString().padLeft(2, '0')}:'
                            '${snapshot.fetchedAt.minute.toString().padLeft(2, '0')}'),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      for (final a in advice)
                        Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.tips_and_updates_outlined, color: AppColors.weather),
                            title: Text(_adviceText(t, a)),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _WeatherHeader extends StatelessWidget {
  const _WeatherHeader({required this.snapshot, required this.conditionText});

  final WeatherSnapshot snapshot;
  final String conditionText;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.weatherLight, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(snapshot.condition.icon, size: 40, color: AppColors.weather),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${snapshot.temperatureCelsius.round()}°C',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.weather),
                  ),
                  Text(conditionText, style: const TextStyle(color: AppColors.weather, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _WeatherStat(
                  icon: Icons.water_drop_outlined,
                  label: t.rainProbabilityLabel,
                  value: '${snapshot.rainProbabilityTodayPercent}%',
                ),
              ),
              Expanded(
                child: _WeatherStat(
                  icon: Icons.opacity_outlined,
                  label: t.humidityLabel,
                  value: '${snapshot.humidityPercent.round()}%',
                ),
              ),
              Expanded(
                child: _WeatherStat(
                  icon: Icons.air_outlined,
                  label: t.windLabel,
                  value: '${snapshot.windSpeedKmh.round()} km/h',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  const _WeatherStat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.weather, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
