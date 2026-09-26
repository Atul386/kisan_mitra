import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_providers.dart';
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
    final user = ref.watch(currentUserProvider).value;
    final farm = ref.watch(primaryFarmProvider);
    final season = ref.watch(primaryActiveSeasonProvider).value;
    final tasks = season == null ? const <FarmTaskEntity>[] : ref.watch(todaysTasksProvider).value ?? const [];
    final pendingCount = tasks.where((task) => task.state == FarmTaskState.pending).length;
    ref.watch(ensureDailyPlanReminderProvider);

    final weatherAsync = ref.watch(currentWeatherProvider);
    final weatherAdvice = ref.watch(weatherAdviceProvider);
    final daysSinceIrrigation = ref.watch(daysSinceLastIrrigationProvider);
    final mandiTrends = ref.watch(mandiTrendsProvider);
    final todayCheckin = season == null ? null : ref.watch(todayCheckinProvider).value;
    final analytics = ref.read(analyticsServiceProvider);

    final showRainAlert = weatherAdvice.contains(WeatherAdvice.checkDrainage) ||
        weatherAdvice.contains(WeatherAdvice.avoidSpraying);
    final tipAdvice = weatherAdvice.isNotEmpty ? weatherAdvice.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HeaderBanner(
              greeting: _greeting(t),
              name: user?.name.isNotEmpty == true ? user!.name : null,
              tagline: t.dashboardTagline,
              onAvatarTap: () => context.go('/dashboard/profile'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: _ActiveCropCard(
                      cropName: season?.cropName,
                      dayLabel: season == null ? null : t.dayNumber(season.dayNumber),
                      onTap: season != null
                          ? null
                          : farm == null
                              ? null
                              : () => context.push('/farm/${farm.id}/add-crop'),
                    ),
                  ),
                  if (showRainAlert) ...[
                    _RainAlertCard(title: t.rainAlertTitle, message: _adviceText(t, weatherAdvice.first)),
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
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _StatCard(
                        icon: Icons.checklist_rounded,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primaryLight,
                        label: t.todaysTasks,
                        value: season == null ? t.noDataDash : t.tasksCountLabel(pendingCount),
                        onTap: season == null ? null : () => context.push('/tasks'),
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
                        onTap: farm == null ? null : () => context.push('/irrigation'),
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
                        onTap: season == null ? null : () => context.push('/checkin'),
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
                    const SizedBox(height: 4),
                    _TipCard(text: _adviceText(t, tipAdvice)),
                  ],
                  const SizedBox(height: 16),
                  _AskKisanMitraButton(
                    label: t.askKisanMitra,
                    onTap: () => context.go('/dashboard/assistant'),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name != null ? '$greeting, $name' : greeting,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  tagline,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onAvatarTap,
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveCropCard extends StatelessWidget {
  const _ActiveCropCard({required this.cropName, required this.dayLabel, this.onTap});

  final String? cropName;
  final String? dayLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryLight, Color(0xFFC8E6C9)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.grass_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.activeCropLabel,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cropName ?? t.addCropTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dayLabel != null)
                      Text(dayLabel!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.errorLight, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.error)),
                const SizedBox(height: 2),
                Text(message, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherHeroCard extends StatelessWidget {
  const _WeatherHeroCard({required this.farmHasLocation, required this.weatherAsync, required this.onTap});

  final bool farmHasLocation;
  final AsyncValue<WeatherSnapshot?> weatherAsync;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.weather, Color(0xFF0D47A1)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: !farmHasLocation
              ? Row(
                  children: [
                    const Icon(Icons.location_off_outlined, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(t.addFarmLocationMessage, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              : weatherAsync.when(
                  data: (snapshot) {
                    if (snapshot == null) {
                      return Text(t.weatherUnavailableMessage, style: const TextStyle(color: Colors.white));
                    }
                    return Row(
                      children: [
                        Icon(snapshot.condition.icon, color: Colors.white, size: 40),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.temperatureCelsius.round()}°C',
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                              ),
                              Text(t.weather, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                        Text(
                          '${snapshot.rainProbabilityTodayPercent}% 💧',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                  ),
                  error: (e, st) => Text(t.weatherUnavailableMessage, style: const TextStyle(color: Colors.white)),
                ),
          ),
        ),
      ),
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
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.dailyTip, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
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
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
