import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../expenses/expense_providers.dart';
import '../../mandi/domain/live_mandi_price.dart';
import '../../reminders/reminder_providers.dart';
import '../../mandi/mandi_providers.dart';
import '../dashboard_providers.dart';

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white.withValues(alpha: 0.92),
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ],
);

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, {this.caption});
  final String title;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          if (caption != null) ...[
            const SizedBox(width: 8),
            Text(
              caption!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Reminders due today. Shows nothing when there are none, so the
/// dashboard stays quiet on a free day.
class TodayRemindersCard extends ConsumerWidget {
  const TodayRemindersCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final today = ref.watch(todaysRemindersProvider);
    if (today.isEmpty) return const SizedBox.shrink();
    final actions = ref.read(reminderActionsProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(t.todayRemindersTitle),
          Container(
            decoration: _cardDecoration(),
            child: Column(
              children: [
                for (final r in today.take(4))
                  ListTile(
                    minTileHeight: 56,
                    onTap: () => context.push('/reminders/${r.id}/edit'),
                    leading: Text(r.category.emoji, style: const TextStyle(fontSize: 24)),
                    title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(DateFormat('h:mm a').format(r.scheduledFor)),
                    trailing: IconButton(
                      tooltip: t.reminderMarkDone,
                      icon: const Icon(Icons.check_circle_outline, color: AppColors.primary),
                      onPressed: () => actions.complete(r),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shortcut icons to the logs a farmer fills in most often.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final actions = [
      (
        Icons.pest_control_rounded,
        t.qaSpray,
        '/add-spray',
        const Color(0xFF7B1FA2),
        const Color(0xFFF3E5F5),
      ),
      (
        Icons.currency_rupee_rounded,
        t.qaExpense,
        '/add-expense',
        AppColors.warning,
        AppColors.warningLight,
      ),
      (
        Icons.grass_rounded,
        t.qaFertilizer,
        '/add-fertilizer',
        AppColors.primary,
        AppColors.primaryLight,
      ),
      (
        Icons.water_drop_rounded,
        t.qaIrrigation,
        '/add-irrigation',
        AppColors.weather,
        AppColors.weatherLight,
      ),
      (
        Icons.eco_rounded,
        t.qaCropCheck,
        '/checkin',
        AppColors.soil,
        AppColors.soilLight,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(t.quickActionsTitle),
        SizedBox(
          height: 88,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final (icon, label, route, color, bg) = actions[i];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => context.push(route),
                child: Container(
                  width: 82,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 4,
                  ),
                  decoration: _cardDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 22),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Typical days from sowing to harvest, used only for the progress bar.
const _typicalCropDays = {
  'rice': 120,
  'wheat': 120,
  'soybean': 100,
  'cotton': 170,
  'sugarcane': 365,
  'maize': 100,
  'groundnut': 110,
  'onion': 120,
  'potato': 90,
  'tomato': 110,
  'tur': 160,
  'gram': 105,
};

/// Area, crop progress and season spend in one card.
class FarmSummaryStrip extends ConsumerWidget {
  const FarmSummaryStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
    final expenses = ref.watch(seasonExpensesProvider).valueOrNull ?? const [];
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    final typical = season == null
        ? 120
        : (_typicalCropDays[season.cropId] ?? 120);
    final day = season?.dayNumber ?? 0;
    final progress = (day / typical).clamp(0.0, 1.0);
    final areaText = season?.area == null
        ? t.summaryNotSet
        : '${season!.area!.toStringAsFixed(season.area! % 1 == 0 ? 0 : 1)} ${season.areaUnit ?? ''}'
              .trim();

    Widget stat(IconData icon, String label, String value) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(t.farmSummaryTitle),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  stat(Icons.landscape_outlined, t.summaryArea, areaText),
                  stat(
                    Icons.currency_rupee_rounded,
                    t.summaryExpenses,
                    '₹${total.toStringAsFixed(0)}',
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: season == null ? 0 : progress,
                  minHeight: 8,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                season == null
                    ? t.summaryNoCrop
                    : t.summaryCropDay(day, typical),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Horizontal list of crop prices: the farmer's own logged prices when
/// there are any, otherwise the reported government prices. Shows nothing
/// (rather than invented numbers) when neither is available.
class MandiTicker extends ConsumerWidget {
  const MandiTicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final trends = ref.watch(mandiTrendsProvider);
    final live = ref.watch(liveMandiPricesProvider).valueOrNull ?? const <LiveMandiPrice>[];

    // (name, modal price, change vs previous — null when unknown)
    final items = trends.isNotEmpty
        ? [for (final tr in trends) (tr.latest.commodity, tr.latest.price, tr.change)]
        : [for (final p in live.take(10)) (p.commodity, p.modalPrice, null as double?)];
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(t.mandiTickerTitle, caption: trends.isEmpty ? t.mandiReportedCaption : null),
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final (name, price, change) = items[i];
                final known = change != null;
                final up = (change ?? 0) > 0;
                final flat = (change ?? 0) == 0;
                final color = !known || flat ? AppColors.textSecondary : (up ? AppColors.primary : AppColors.error);
                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.go('/dashboard/market'),
                  child: Container(
                    width: 128,
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text('₹${price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                        Row(
                          children: [
                            if (known)
                              Icon(
                                flat ? Icons.remove_rounded : (up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded),
                                size: 14,
                                color: color,
                              ),
                            if (known)
                              Text(
                                flat ? '—' : change.abs().toStringAsFixed(0),
                                style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
                              ),
                            if (known) const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                t.mandiPerQuintal,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Tip of the day plus government scheme cards. Sample content — swap for
/// a remote source once there is one.
class SchemesSection extends StatelessWidget {
  const SchemesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final schemes = [
      (
        Icons.account_balance_rounded,
        t.schemePmKisanTitle,
        t.schemePmKisanDesc,
        AppColors.primary,
        AppColors.primaryLight,
      ),
      (
        Icons.shield_outlined,
        t.schemePmfbyTitle,
        t.schemePmfbyDesc,
        AppColors.weather,
        AppColors.weatherLight,
      ),
      (
        Icons.credit_card_rounded,
        t.schemeKccTitle,
        t.schemeKccDesc,
        AppColors.warning,
        AppColors.warningLight,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_rounded, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.dailyTipTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.dailyTipBody,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(t.schemesTitle, caption: t.schemesSampleCaption),
        for (final (icon, title, desc, color, bg) in schemes)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
