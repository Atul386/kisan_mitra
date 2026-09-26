import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_mandi_price.dart';
import '../mandi_providers.dart';

/// Two sources feed this screen (see lib/features/mandi/README.md):
/// government Agmarknet live prices when a data.gov.in API key is
/// configured, and the farmer's own manually logged prices, which always
/// work offline and drive the trend cards.
class MandiTab extends ConsumerWidget {
  const MandiTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final trends = ref.watch(mandiTrendsProvider);
    final livePrices = ref.watch(liveMandiPricesProvider).value ?? const [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.mandi)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-mandi-price'),
        icon: const Icon(Icons.add),
        label: Text(t.addMandiPrice),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            if (livePrices.isNotEmpty)
              _LiveMandiPricesSection(prices: livePrices)
            else
              _InfoBanner(text: t.mandiManualTrackingNote),
            const SizedBox(height: 20),
            Text(t.yourTrackedPricesLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            if (trends.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    const Icon(Icons.storefront_outlined, size: 40, color: AppColors.textSecondary),
                    const SizedBox(height: 12),
                    Text(
                      t.noMandiPricesMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              for (final trend in trends) _MandiTrendCard(trend: trend, t: t),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _LiveMandiPricesSection extends StatelessWidget {
  const _LiveMandiPricesSection({required this.prices});

  final List<LiveMandiPrice> prices;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final top = prices.first;
    final rest = prices.skip(1).take(4).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.warning, Color(0xFFE65100)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.podcasts_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                t.liveMandiPricesTitle,
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(top.commodity, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(
            '₹${top.modalPrice.toStringAsFixed(0)}',
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
          ),
          Text(
            '${top.market} • ${t.perQuintalLabel}',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: rest.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final price = rest[i];
                  return Container(
                    width: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          price.commodity,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '₹${price.modalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(t.liveMandiSourceLabel, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _MandiTrendCard extends StatelessWidget {
  const _MandiTrendCard({required this.trend, required this.t});

  final MandiTrend trend;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final change = trend.change;
    final isUp = (change ?? 0) >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.trending_up_rounded, color: AppColors.warning),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trend.latest.commodity, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  [
                    if (trend.latest.market != null) trend.latest.market!,
                    '${trend.latest.date.day}/${trend.latest.date.month}/${trend.latest.date.year}',
                  ].join(' • '),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹${trend.latest.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              if (change != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isUp ? AppColors.primaryLight : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${isUp ? '+' : ''}₹${change.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isUp ? AppColors.primary : AppColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
