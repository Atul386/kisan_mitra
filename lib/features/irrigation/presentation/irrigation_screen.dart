import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../weather/domain/weather_advice.dart';
import '../../weather/weather_providers.dart';
import '../domain/irrigation_log.dart';
import '../irrigation_providers.dart';

class IrrigationScreen extends ConsumerWidget {
  const IrrigationScreen({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final logs = ref.watch(seasonIrrigationLogsProvider).valueOrNull ?? const [];
    final daysSinceLast = ref.watch(daysSinceLastIrrigationProvider);
    final suggestedNext = ref.watch(suggestedNextIrrigationProvider);

    final relevantAdvice = ref.watch(weatherAdviceProvider).where(
          (a) => a == WeatherAdvice.irrigationNotNeeded || a == WeatherAdvice.hotDay,
        );
    final advice = relevantAdvice.isEmpty ? null : relevantAdvice.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(t.irrigationTitle),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: logs.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.water_drop_outlined, size: 40, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(t.noIrrigationMessage, style: const TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _IrrigationStatCard(
                          icon: Icons.water_drop_rounded,
                          color: AppColors.weather,
                          backgroundColor: AppColors.weatherLight,
                          title: t.lastIrrigationTitle,
                          value: _formatDate(logs.first.date),
                          badge: daysSinceLast == null ? null : t.daysAgoLabel(daysSinceLast),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: suggestedNext == null
                            ? _IrrigationEmptyStatCard(
                                icon: Icons.event_repeat_rounded,
                                title: t.suggestedNextIrrigationTitle,
                                message: t.irrigationHistoryNeededMessage,
                              )
                            : _IrrigationStatCard(
                                icon: Icons.event_available_rounded,
                                color: AppColors.primary,
                                backgroundColor: AppColors.primaryLight,
                                title: t.suggestedNextIrrigationTitle,
                                value: _formatDate(suggestedNext),
                                badge: t.inDaysLabel(
                                  suggestedNext.difference(DateTime.now()).inDays.clamp(0, 999),
                                ),
                              ),
                      ),
                    ],
                  ),
                  if (advice != null) ...[
                    const SizedBox(height: 12),
                    _AdviceCard(text: _adviceText(t, advice)),
                  ],
                  const SizedBox(height: 20),
                  Text(t.irrigationHistoryTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  for (final log in logs) _IrrigationHistoryCard(log: log, t: t),
                ],
              ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/add-irrigation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.add),
            label: Text(t.logIrrigation, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _IrrigationStatCard extends StatelessWidget {
  const _IrrigationStatCard({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.value,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String title;
  final String value;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          if (badge != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
              child: Text(badge!, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}

class _IrrigationEmptyStatCard extends StatelessWidget {
  const _IrrigationEmptyStatCard({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 2),
          Text(message, style: const TextStyle(fontSize: 12), maxLines: 3),
        ],
      ),
    );
  }
}

class _AdviceCard extends StatelessWidget {
  const _AdviceCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.weatherLight, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.wb_cloudy_rounded, color: AppColors.weather),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _IrrigationHistoryCard extends StatelessWidget {
  const _IrrigationHistoryCard({required this.log, required this.t});

  final IrrigationLogEntry log;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.weatherLight, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.water_drop_outlined, color: AppColors.weather, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.date.day}/${log.date.month}/${log.date.year}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                if (log.method != null || log.notes != null)
                  Text(
                    [if (log.method != null) log.method!, if (log.notes != null) log.notes!].join(' • '),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (log.durationMinutes != null)
            Text(
              '${log.durationMinutes} ${t.minutesUnitLabel}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
