import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/config/feature_flags.dart';
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
        await ref
            .read(farmRepositoryProvider)
            .setLocation(farmId: farm.id, latitude: position.latitude, longitude: position.longitude);
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

  /// Time only for today's data; offline data from an earlier day also
  /// shows its date so it doesn't look current.
  String _fetchedAtLabel(DateTime fetchedAt) {
    final now = DateTime.now();
    final time = '${fetchedAt.hour.toString().padLeft(2, '0')}:${fetchedAt.minute.toString().padLeft(2, '0')}';
    final sameDay = fetchedAt.year == now.year && fetchedAt.month == now.month && fetchedAt.day == now.day;
    return sameDay ? time : '${fetchedAt.day}/${fetchedAt.month} $time';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final farm = ref.watch(primaryFarmProvider);
    final weatherAsync = ref.watch(currentWeatherProvider);
    final advice = ref.watch(weatherAdviceProvider);
    final needsLocation = !kUseDummyWeather && farm != null && !farm.hasLocation;

    Widget message(String text) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(t.weatherTitle)),
      body: SafeArea(
        child: needsLocation
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
                error: (e, st) => message(t.weatherUnavailableMessage),
                data: (snapshot) {
                  if (snapshot == null) {
                    return message(t.weatherUnavailableMessage);
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      _WeatherHero(
                        snapshot: snapshot,
                        farmName: farm?.name,
                        conditionText: _conditionText(t, snapshot.condition),
                        updatedText: t.lastUpdatedLabel(_fetchedAtLabel(snapshot.fetchedAt)),
                        demo: kUseDummyWeather,
                      ),
                      if (snapshot.hourly.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _HourlyStrip(hours: snapshot.hourly.take(24).toList()),
                      ],
                      const SizedBox(height: 16),
                      _DetailsGrid(snapshot: snapshot),
                      if (snapshot.daily.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _ForecastCard(days: snapshot.daily, conditionText: (c) => _conditionText(t, c)),
                      ],
                      const SizedBox(height: 16),
                      _SectionTitle(t.farmAdviceTitle),
                      const SizedBox(height: 8),
                      if (advice.isEmpty)
                        _AdviceTile(text: t.weatherNoAdvice, icon: Icons.check_circle_outline, color: AppColors.primary)
                      else
                        for (final a in advice)
                          _AdviceTile(text: _adviceText(t, a), icon: _adviceIcon(a), color: _adviceColor(a)),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

IconData _adviceIcon(WeatherAdvice a) {
  switch (a) {
    case WeatherAdvice.avoidSpraying:
      return Icons.block_rounded;
    case WeatherAdvice.irrigationNotNeeded:
      return Icons.water_drop_outlined;
    case WeatherAdvice.checkDrainage:
      return Icons.flood_outlined;
    case WeatherAdvice.goodSprayingConditions:
      return Icons.check_circle_outline;
    case WeatherAdvice.hotDay:
      return Icons.thermostat_rounded;
  }
}

Color _adviceColor(WeatherAdvice a) {
  switch (a) {
    case WeatherAdvice.avoidSpraying:
    case WeatherAdvice.hotDay:
      return AppColors.warning;
    case WeatherAdvice.checkDrainage:
      return AppColors.error;
    case WeatherAdvice.irrigationNotNeeded:
      return AppColors.weather;
    case WeatherAdvice.goodSprayingConditions:
      return AppColors.primary;
  }
}

String _hm(DateTime d) => DateFormat('h:mm a').format(d);

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16));
}

class _WeatherHero extends StatelessWidget {
  const _WeatherHero({
    required this.snapshot,
    required this.conditionText,
    required this.updatedText,
    required this.demo,
    this.farmName,
  });

  final WeatherSnapshot snapshot;
  final String conditionText;
  final String updatedText;
  final String? farmName;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final today = snapshot.daily.isNotEmpty ? snapshot.daily.first : null;
    final colors = snapshot.condition.gradient;
    const onHero = Colors.white;
    final onHeroMuted = Colors.white.withValues(alpha: 0.85);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colors.first.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 28,
            child: Icon(snapshot.condition.icon, size: 110, color: Colors.white.withValues(alpha: 0.22)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 16, color: onHeroMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      farmName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: onHeroMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (demo)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(t.weatherDemoBadge, style: const TextStyle(color: onHero, fontSize: 11)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${snapshot.temperatureCelsius.round()}°',
                    style: const TextStyle(fontSize: 72, height: 1, fontWeight: FontWeight.w300, color: onHero),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('C', style: TextStyle(fontSize: 24, color: onHero)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                conditionText,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: onHero),
              ),
              const SizedBox(height: 2),
              Text(
                [
                  if (snapshot.feelsLikeCelsius != null)
                    t.feelsLikeLabel(snapshot.feelsLikeCelsius!.round().toString()),
                  if (today != null)
                    t.highLowLabel(today.maxCelsius.round().toString(), today.minCelsius.round().toString()),
                ].join('  ·  '),
                style: TextStyle(color: onHeroMuted),
              ),
              const SizedBox(height: 14),
              Text(updatedText, style: TextStyle(color: onHeroMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HourlyStrip extends StatelessWidget {
  const _HourlyStrip({required this.hours});
  final List<HourlyForecast> hours;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _SectionTitle(t.hourlyForecastTitle)),
            const SizedBox(height: 12),
            SizedBox(
              height: 124,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: hours.length,
                separatorBuilder: (_, __) => const SizedBox(width: 4),
                itemBuilder: (context, i) {
                  final h = hours[i];
                  final now = i == 0;
                  return Container(
                    width: 58,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: now ? AppColors.weatherLight : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          now ? t.forecastTodayLabel : DateFormat('h a').format(h.time),
                          style: TextStyle(fontSize: 12, fontWeight: now ? FontWeight.w700 : FontWeight.w500),
                        ),
                        Icon(h.condition.icon, size: 22, color: AppColors.weather),
                        Text('${h.celsius.round()}°', style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(
                          '${h.rainProbabilityPercent}%',
                          style: TextStyle(
                            fontSize: 11,
                            color: h.rainProbabilityPercent >= 50 ? AppColors.weather : AppColors.textSecondary,
                            fontWeight: h.rainProbabilityPercent >= 50 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.snapshot});
  final WeatherSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final tiles = <_DetailTile>[
      _DetailTile(Icons.water_drop_outlined, t.rainProbabilityLabel, '${snapshot.rainProbabilityTodayPercent}%'),
      if ((snapshot.daily.isNotEmpty ? snapshot.daily.first.rainMm : null) ?? snapshot.rainfallMm case final mm?)
        _DetailTile(Icons.grain_rounded, t.rainfallLabel, '${mm.toStringAsFixed(mm >= 10 ? 0 : 1)} mm'),
      _DetailTile(Icons.opacity_outlined, t.humidityLabel, '${snapshot.humidityPercent.round()}%'),
      _DetailTile(Icons.air_outlined, t.windLabel, '${snapshot.windSpeedKmh.round()} km/h'),
      if (snapshot.uvIndex != null)
        _DetailTile(Icons.wb_sunny_outlined, t.uvIndexLabel, snapshot.uvIndex!.toStringAsFixed(1)),
      if (snapshot.sunrise != null) _DetailTile(Icons.wb_twilight_rounded, t.sunriseLabel, _hm(snapshot.sunrise!)),
      if (snapshot.sunset != null) _DetailTile(Icons.nights_stay_outlined, t.sunsetLabel, _hm(snapshot.sunset!)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(t.weatherDetailsTitle),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 16) / 3;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [for (final tile in tiles) SizedBox(width: w, child: tile)],
            );
          },
        ),
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: AppColors.weatherLight, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.weather, size: 18),
            ),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastCard extends StatefulWidget {
  const _ForecastCard({required this.days, required this.conditionText});

  final List<DailyForecast> days;
  final String Function(WeatherCondition) conditionText;

  @override
  State<_ForecastCard> createState() => _ForecastCardState();
}

class _ForecastCardState extends State<_ForecastCard> {
  /// 7 days by default; the farmer can open the full 16.
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final days = widget.days;
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    bool isToday(DateTime d) => d.year == now.year && d.month == now.month && d.day == now.day;
    final shown = days.take(_expanded ? 16 : 7).toList();
    final lo = shown.map((d) => d.minCelsius).reduce((a, b) => a < b ? a : b);
    final hi = shown.map((d) => d.maxCelsius).reduce((a, b) => a > b ? a : b);
    final span = (hi - lo) <= 0 ? 1.0 : hi - lo;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(_expanded ? t.sixteenDayForecastTitle : t.sevenDayForecastTitle),
            const SizedBox(height: 6),
            for (final day in shown)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        isToday(day.date) ? t.forecastTodayLabel : DateFormat.E(locale).format(day.date),
                        style: TextStyle(fontWeight: isToday(day.date) ? FontWeight.w700 : FontWeight.w500),
                      ),
                    ),
                    Icon(day.condition.icon, size: 22, color: AppColors.weather),
                    SizedBox(
                      width: 52,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${day.rainProbabilityPercent}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: day.rainProbabilityPercent >= 50 ? AppColors.weather : AppColors.textSecondary,
                            ),
                          ),
                          if (day.rainMm != null && day.rainMm! >= 0.1)
                            Text(
                              '${day.rainMm!.toStringAsFixed(day.rainMm! >= 10 ? 0 : 1)} mm',
                              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '${day.minCelsius.round()}°',
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _RangeBar(start: (day.minCelsius - lo) / span, end: (day.maxCelsius - lo) / span),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text('${day.maxCelsius.round()}°', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
            if (days.length > 7)
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? t.showFewerDays : t.showSixteenDays),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Day's temperature range drawn within the week's overall range.
class _RangeBar extends StatelessWidget {
  const _RangeBar({required this.start, required this.end});
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final left = c.maxWidth * start;
        final width = (c.maxWidth * (end - start)).clamp(8.0, c.maxWidth);
        return SizedBox(
          height: 6,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3)),
              ),
              Positioned(
                left: left.clamp(0.0, c.maxWidth - width),
                width: width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(colors: [AppColors.weather, AppColors.warning]),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AdviceTile extends StatelessWidget {
  const _AdviceTile({required this.text, required this.icon, required this.color});
  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
