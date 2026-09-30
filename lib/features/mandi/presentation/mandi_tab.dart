import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/notifications/notification_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../domain/live_mandi_price.dart';
import 'mandi_widgets.dart';
import '../mandi_providers.dart';
import '../mandi_watchlist.dart';

/// Two sources feed this screen (see lib/features/mandi/README.md):
/// reported government mandi prices from the keyless Mandi Price API, and
/// the farmer's own manually logged prices, which always work offline and
/// drive the trend cards.
class MandiTab extends ConsumerWidget {
  const MandiTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final trends = ref.watch(mandiTrendsProvider);
    final liveResult = ref.watch(liveMandiResultProvider);
    final livePrices = liveResult.valueOrNull?.value ?? const <LiveMandiPrice>[];
    final watchlist = ref.watch(mandiWatchlistProvider);

    final favouriteTrends = trends.where((tr) => watchlist.isFavourite(tr.latest.commodity)).toList();
    final favouriteLive = livePrices.where((p) => watchlist.isFavourite(p.commodity)).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(t.mandi),
          actions: [
            IconButton(
              tooltip: t.nearbyMandisTitle,
              icon: const Icon(Icons.place_outlined),
              onPressed: () => context.push('/mandi/nearby'),
            ),
          ],
          bottom: TabBar(tabs: [Tab(text: t.mandiAllTab), Tab(text: t.mandiFavouritesTab)]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-mandi-price'),
          icon: const Icon(Icons.add),
          label: Text(t.addMandiPrice),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  _LiveMandiPricesSection(prices: livePrices, result: liveResult),
                  const SizedBox(height: 20),
                  Text(t.yourTrackedPricesLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (trends.isEmpty)
                    _EmptyMessage(icon: Icons.storefront_outlined, text: t.noMandiPricesMessage)
                  else
                    for (final trend in trends) _MandiTrendCard(trend: trend, t: t),
                ],
              ),
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  if (favouriteTrends.isEmpty && favouriteLive.isEmpty)
                    _EmptyMessage(icon: Icons.star_border_rounded, text: t.noFavouritesMessage)
                  else ...[
                    for (final trend in favouriteTrends) _MandiTrendCard(trend: trend, t: t),
                    for (final price in favouriteLive) _LivePriceTile(price: price),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _LivePriceTile extends StatelessWidget {
  const _LivePriceTile({required this.price});

  final LiveMandiPrice price;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.podcasts_rounded, color: AppColors.warning),
        title: Text(price.commodity, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${price.market} • ${t.liveMandiPricesTitle}'),
        trailing: Text('₹${price.modalPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

Future<void> showPriceAlertDialog(BuildContext context, WidgetRef ref, String commodity) async {
  final t = AppLocalizations.of(context)!;
  final existing = ref.read(mandiWatchlistProvider).alertFor(commodity);
  final controller = TextEditingController(text: existing?.toStringAsFixed(0) ?? '');
  final result = await showDialog<({bool remove, double? price})>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(t.priceAlertDialogTitle(commodity)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: t.priceAlertTargetLabel),
          ),
          const SizedBox(height: 10),
          Text(t.priceAlertHelp, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
      actions: [
        if (existing != null)
          TextButton(
            onPressed: () => Navigator.pop(context, (remove: true, price: null)),
            child: Text(t.removeAlert, style: const TextStyle(color: AppColors.error)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
        FilledButton(
          onPressed: () => Navigator.pop(context, (remove: false, price: double.tryParse(controller.text.trim()))),
          child: Text(t.save),
        ),
      ],
    ),
  );
  controller.dispose();
  if (result == null) return;
  if (result.remove) {
    await ref.read(mandiWatchlistProvider.notifier).setAlert(commodity, null);
  } else if (result.price != null && result.price! > 0) {
    await ref.read(notificationServiceProvider).requestPermission();
    await ref.read(mandiWatchlistProvider.notifier).setAlert(commodity, result.price);
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
  const _LiveMandiPricesSection({required this.prices, required this.result});

  final List<LiveMandiPrice> prices;
  final AsyncValue<MandiResult<List<LiveMandiPrice>>> result;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (result.isLoading && prices.isEmpty) {
      return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
    }
    if (prices.isEmpty) {
      final error = result.error;
      return _InfoBanner(text: error != null ? mandiErrorText(t, error) : t.mandiNoPrices);
    }

    final top = prices.first;
    final rest = prices.skip(1).take(4).toList();
    final fromCache = result.valueOrNull?.fromCache ?? false;

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
              Expanded(
                child: Text(
                  t.mandiLiveTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              if (fromCache) const Icon(Icons.cloud_off_outlined, color: Colors.white70, size: 18),
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
          Text(
            t.mandiReportedOn(DateFormat('d MMM yyyy').format(top.arrivalDate)),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
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
          Row(
            children: [
              Expanded(
                child: Text(t.liveMandiSourceLabel, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () => context.push('/mandi/live'),
                child: Text(t.mandiSeeAll),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MandiTrendCard extends ConsumerWidget {
  const _MandiTrendCard({required this.trend, required this.t});

  final MandiTrend trend;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commodity = trend.latest.commodity;
    final watchlist = ref.watch(mandiWatchlistProvider);
    final isFavourite = watchlist.isFavourite(commodity);
    final alert = watchlist.alertFor(commodity);
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
                if (alert != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.notifications_active_outlined, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        t.priceAlertActiveLabel(alert.toStringAsFixed(0)),
                        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: isFavourite ? t.removeFromFavourite : t.addToFavourite,
            onPressed: () => ref.read(mandiWatchlistProvider.notifier).toggleFavourite(commodity),
            icon: Icon(
              isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavourite ? AppColors.warning : AppColors.textSecondary,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: t.setPriceAlert,
            onPressed: () => showPriceAlertDialog(context, ref, commodity),
            icon: Icon(
              alert != null ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
              color: alert != null ? AppColors.primary : AppColors.textSecondary,
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
