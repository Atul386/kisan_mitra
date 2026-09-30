import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/config/feature_flags.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';
import '../../crop_health/checkin_providers.dart';
import '../../crop_health/domain/daily_checkin.dart';
import '../../irrigation/irrigation_providers.dart';
import '../../mandi/mandi_providers.dart';
import '../../tasks/domain/farm_task.dart';
import '../../tasks/task_providers.dart';
import '../../weather/domain/weather_advice.dart';
import '../../weather/domain/weather_snapshot.dart';
import '../../weather/weather_providers.dart';
import '../dashboard_providers.dart';
import 'dashboard_sections.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  String _greeting(AppLocalizations t) {
    final hour = DateTime.now().hour;
    if (hour < 12) return t.goodMorning;
    if (hour < 17) return t.goodAfternoon;
    return t.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final farm = ref.watch(primaryFarmProvider);
    final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
    final tasks = season == null
        ? const <FarmTaskEntity>[]
        : ref.watch(todaysTasksProvider).valueOrNull ?? const [];
    final today = DateTime.now();
    final pendingCount = tasks
        .where((task) => task.isActionableOn(today))
        .length;
    ref.watch(ensureDailyPlanReminderProvider);

    final weatherAsync = ref.watch(currentWeatherProvider);
    final weatherAdvice = ref.watch(weatherAdviceProvider);
    final daysSinceIrrigation = ref.watch(daysSinceLastIrrigationProvider);
    final mandiTrends = ref.watch(mandiTrendsProvider);
    final todayCheckin = season == null
        ? null
        : ref.watch(todayCheckinProvider).valueOrNull;
    final analytics = ref.read(analyticsServiceProvider);

    final showRainAlert =
        weatherAdvice.contains(WeatherAdvice.checkDrainage) ||
        weatherAdvice.contains(WeatherAdvice.avoidSpraying);
    final tipAdvice = weatherAdvice.isNotEmpty ? weatherAdvice.first : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Farm scene behind everything, faded so cards and text stay readable.
            Positioned.fill(
              child: Image.asset(
                'assets/images/dashbord.png',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                opacity: const AlwaysStoppedAnimation(0.35),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _HeaderBanner(
                    greeting: _greeting(t),
                    name: user?.name.isNotEmpty == true ? user!.name : null,
                    tagline: t.dashboardTagline,
                    onAvatarTap: () => context.push('/settings'),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        _ActiveCropCard(
                          cropName: season?.cropName,
                          dayLabel: season == null
                              ? null
                              : t.dayNumber(season.dayNumber),
                          onTap: season != null
                              ? null
                              : farm == null
                              ? null
                              : () => context.push('/farm/${farm.id}/add-crop'),
                        ),
                        const SizedBox(height: 12),
                        if (showRainAlert) ...[
                          _RainAlertCard(
                            title: t.rainAlertTitle,
                            message: _adviceText(t, weatherAdvice.first),
                          ),
                          const SizedBox(height: 12),
                        ],
                        _WeatherHeroCard(
                          farmHasLocation: farm?.hasLocation ?? false,
                          weatherAsync: weatherAsync,
                          onTap: () {
                            analytics.logEvent('weather_opened');
                            context.push('/weather');
                          },
                        ),
                        const SizedBox(height: 16),
                        const TodayRemindersCard(),
                        const QuickActionsRow(),
                        const SizedBox(height: 16),
                        const FarmSummaryStrip(),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.45,
                          children: [
                            _StatCard(
                              icon: Icons.checklist_rounded,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primaryLight,
                              label: t.todaysTasks,
                              value: season == null
                                  ? t.noDataDash
                                  : t.tasksCountLabel(pendingCount),
                              onTap: season == null
                                  ? null
                                  : () => context.push('/tasks'),
                            ),
                            _StatCard(
                              icon: Icons.water_drop_rounded,
                              color: AppColors.weather,
                              backgroundColor: AppColors.weatherLight,
                              label: t.irrigation,
                              value: daysSinceIrrigation == null
                                  ? t.noDataDash
                                  : daysSinceIrrigation >= 2
                                  ? t.irrigationDueStatus
                                  : t.irrigationNormalStatus,
                              onTap: farm == null
                                  ? null
                                  : () => context.push('/irrigation'),
                            ),
                            _StatCard(
                              icon: Icons.eco_rounded,
                              color: AppColors.primary,
                              backgroundColor: AppColors.primaryLight,
                              label: t.cropHealth,
                              value: season == null
                                  ? t.noDataDash
                                  : todayCheckin == null
                                  ? t.howIsYourCropToday
                                  : _checkinLabel(t, todayCheckin.healthStatus),
                              onTap: season == null
                                  ? null
                                  : () => context.push('/checkin'),
                            ),
                            _StatCard(
                              icon: Icons.trending_up_rounded,
                              color: AppColors.warning,
                              backgroundColor: AppColors.warningLight,
                              label: t.mandi,
                              value: mandiTrends.isEmpty
                                  ? t.noDataDash
                                  : '₹${mandiTrends.first.latest.price.toStringAsFixed(0)}',
                              onTap: () {
                                analytics.logEvent('mandi_opened');
                                context.go('/dashboard/market');
                              },
                            ),
                          ],
                        ),
                        if (tipAdvice != null) ...[
                          const SizedBox(height: 12),
                          _TipCard(text: _adviceText(t, tipAdvice)),
                        ],
                        const SizedBox(height: 16),
                        const MandiTicker(),
                        const SchemesSection(),
                        if (kAiAssistantEnabled) ...[
                          const SizedBox(height: 16),
                          _AskKisanMitraButton(
                            label: t.askKisanMitra,
                            onTap: () => context.go('/dashboard/assistant'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _checkinLabel(AppLocalizations t, CheckinHealth health) {
    switch (health) {
      case CheckinHealth.good:
        return t.checkInPromptGood;
      case CheckinHealth.needsAttention:
        return t.checkInPromptAttention;
      case CheckinHealth.problem:
        return t.checkInPromptProblem;
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
}

/// Frosted white card used for every dashboard tile, so the page reads as
/// one system over the background image.
class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  static const radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Glass card with a coloured stripe on the left — alerts and tips.
class _AccentCard extends StatelessWidget {
  const _AccentCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.message,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: EdgeInsets.zero,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(_GlassCard.radius),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _IconBadge(icon: icon, color: color, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color, this.size = 40});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(icon, color: color, size: size * 0.55),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner({
    required this.greeting,
    required this.name,
    required this.tagline,
    required this.onAvatarTap,
  });

  final String greeting;
  final String? name;
  final String tagline;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name != null ? '$greeting, $name' : greeting,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tagline,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 3,
            shadowColor: Colors.black26,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onAvatarTap,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.person_rounded, color: AppColors.primaryDark),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveCropCard extends StatelessWidget {
  const _ActiveCropCard({
    required this.cropName,
    required this.dayLabel,
    this.onTap,
  });

  final String? cropName;
  final String? dayLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF43A047), AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.grass_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.activeCropLabel.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cropName ?? t.addCropTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (dayLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                dayLabel!,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          // Only show the chevron when the card actually goes somewhere.
          if (onTap != null)
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}

class _RainAlertCard extends StatelessWidget {
  const _RainAlertCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return _AccentCard(
      color: AppColors.error,
      icon: Icons.warning_amber_rounded,
      title: title,
      message: message,
    );
  }
}

class _WeatherHeroCard extends StatelessWidget {
  const _WeatherHeroCard({
    required this.farmHasLocation,
    required this.weatherAsync,
    required this.onTap,
  });

  final bool farmHasLocation;
  final AsyncValue<WeatherSnapshot?> weatherAsync;
  final VoidCallback onTap;

  String _conditionText(AppLocalizations t, WeatherCondition condition) =>
      switch (condition) {
        WeatherCondition.clear => t.weatherConditionClear,
        WeatherCondition.cloudy => t.weatherConditionCloudy,
        WeatherCondition.fog => t.weatherConditionFog,
        WeatherCondition.rain => t.weatherConditionRain,
        WeatherCondition.storm => t.weatherConditionStorm,
        WeatherCondition.snow => t.weatherConditionSnow,
      };

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const white70 = TextStyle(color: Colors.white70, fontSize: 12);
    final colors =
        weatherAsync.valueOrNull?.condition.gradient ??
        const [Color(0xFF42A5F5), Color(0xFF1565C0)];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_GlassCard.radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_GlassCard.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(_GlassCard.radius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: !farmHasLocation && !kUseDummyWeather
                ? Row(
                    children: [
                      const Icon(
                        Icons.location_off_outlined,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          t.addFarmLocationMessage,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : weatherAsync.when(
                    data: (snapshot) {
                      if (snapshot == null) {
                        return Text(
                          t.weatherUnavailableMessage,
                          style: const TextStyle(color: Colors.white),
                        );
                      }
                      final today = snapshot.daily.isNotEmpty
                          ? snapshot.daily.first
                          : null;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                snapshot.condition.icon,
                                color: Colors.white,
                                size: 44,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '${snapshot.temperatureCelsius.round()}°C',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            height: 1.1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            _conditionText(
                                              t,
                                              snapshot.condition,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (today != null)
                                      Text(
                                        t.highLowLabel(
                                          today.maxCelsius.round().toString(),
                                          today.minCelsius.round().toString(),
                                        ),
                                        style: white70,
                                      ),
                                  ],
                                ),
                              ),
                              if (kUseDummyWeather)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    t.weatherDemoBadge,
                                    style: white70.copyWith(fontSize: 10),
                                  ),
                                ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _WeatherMetric(
                                  icon: Icons.water_drop_outlined,
                                  value:
                                      '${snapshot.rainProbabilityTodayPercent}%',
                                ),
                                _WeatherMetric(
                                  icon: Icons.opacity_rounded,
                                  value: '${snapshot.humidityPercent.round()}%',
                                ),
                                _WeatherMetric(
                                  icon: Icons.air_rounded,
                                  value:
                                      '${snapshot.windSpeedKmh.round()} km/h',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      height: 80,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    error: (e, st) => Text(
                      t.weatherUnavailableMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _WeatherMetric extends StatelessWidget {
  const _WeatherMetric({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBadge(icon: icon, color: color, size: 38),
              const Spacer(),
              if (onTap != null)
                Icon(
                  Icons.arrow_outward_rounded,
                  size: 16,
                  color: color.withValues(alpha: 0.7),
                ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _AccentCard(
      color: AppColors.warning,
      icon: Icons.lightbulb_rounded,
      title: t.dailyTip,
      message: text,
    );
  }
}

class _AskKisanMitraButton extends StatelessWidget {
  const _AskKisanMitraButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mic_none_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
