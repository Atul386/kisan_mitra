import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_mandi_price.dart';
import '../domain/live_mandi_repository.dart';
import '../mandi_providers.dart';
import '../mandi_watchlist.dart';
import 'mandi_tab.dart' show showPriceAlertDialog;
import 'mandi_widgets.dart';

const _pageSize = 25;

class LiveMandiScreen extends ConsumerStatefulWidget {
  const LiveMandiScreen({super.key});

  @override
  ConsumerState<LiveMandiScreen> createState() => _LiveMandiScreenState();
}

class _LiveMandiScreenState extends ConsumerState<LiveMandiScreen> {
  Timer? _debounce;
  String _query = '';
  int _shown = _pageSize;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _query = value.trim().toLowerCase();
          _shown = _pageSize;
        });
      }
    });
  }

  List<LiveMandiPrice> _apply(List<LiveMandiPrice> all) {
    if (_query.isEmpty) return all;
    return all
        .where(
          (p) =>
              p.market.toLowerCase().contains(_query) ||
              p.variety.toLowerCase().contains(_query) ||
              p.commodity.toLowerCase().contains(_query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final result = ref.watch(liveMandiResultProvider);
    final filter = ref.watch(mandiFilterProvider);
    final commodity = ref.watch(mandiEffectiveCommodityProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.mandiLiveTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(liveMandiResultProvider);
            await ref.read(liveMandiResultProvider.future).catchError((_) => const MandiResult(<LiveMandiPrice>[]));
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              TextField(
                onChanged: _onSearch,
                decoration: InputDecoration(hintText: t.mandiSearchHint, prefixIcon: const Icon(Icons.search_rounded)),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: t.mandiFilterCrop,
                      value: commodity,
                      onTap: () => _pickCommodity(context),
                    ),
                    _FilterChip(
                      label: t.mandiFilterDistrict,
                      value: filter.district,
                      onTap: () => _pickDistrict(context),
                    ),
                    _FilterChip(
                      label: t.mandiFilterMarket,
                      value: filter.market,
                      onTap: () => _pickMarket(context),
                    ),
                    _FilterChip(
                      label: t.mandiFilterVariety,
                      value: filter.variety,
                      onTap: () => _pickVariety(context, result.valueOrNull?.value ?? const []),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              result.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => MandiMessage(
                  text: mandiErrorText(t, e),
                  actionLabel: e is MandiUnsupportedStateException ? null : t.tryAgain,
                  onAction: e is MandiUnsupportedStateException ? null : () => ref.invalidate(liveMandiResultProvider),
                ),
                data: (r) {
                  final rows = _apply(r.value);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (r.fromCache) OfflineBanner(cachedAt: r.cachedAt),
                      if (rows.isEmpty)
                        MandiMessage(text: t.mandiNoPrices)
                      else ...[
                        for (final p in rows.take(_shown)) _PriceCard(price: p),
                        if (rows.length > _shown)
                          Center(
                            child: TextButton(
                              onPressed: () => setState(() => _shown += _pageSize),
                              child: Text(t.mandiShowMore),
                            ),
                          ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        '${t.liveMandiSourceLabel}\n${t.mandiDataNote}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCommodity(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final crops = ref.read(mandiCommoditiesProvider).valueOrNull?.value ?? const <String>[];
    final choice = await _showPicker(context, t.mandiFilterCrop, crops, ref.read(mandiEffectiveCommodityProvider));
    if (choice == null) return;
    ref.read(mandiFilterProvider.notifier).update(
      // '' = all crops (see MandiFilter.commodity); market/variety depend on the crop.
      (f) => f.copyWith(commodity: () => choice.value ?? '', market: () => null, variety: () => null),
    );
    setState(() => _shown = _pageSize);
  }

  Future<void> _pickDistrict(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final markets = ref.read(mandiMarketsProvider).valueOrNull?.value ?? const <MandiMarket>[];
    final districts = markets.map((m) => m.district).where((d) => d.isNotEmpty).toSet().toList()..sort();
    final choice = await _showPicker(context, t.mandiFilterDistrict, districts, ref.read(mandiFilterProvider).district);
    if (choice == null) return;
    ref.read(mandiFilterProvider.notifier).update((f) => f.copyWith(district: () => choice.value, market: () => null));
    setState(() => _shown = _pageSize);
  }

  Future<void> _pickMarket(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    final district = ref.read(mandiFilterProvider).district;
    final markets = (ref.read(mandiMarketsProvider).valueOrNull?.value ?? const <MandiMarket>[])
        .where((m) => district == null || m.district == district)
        .map((m) => m.market)
        .toSet()
        .toList()
      ..sort();
    final choice = await _showPicker(context, t.mandiFilterMarket, markets, ref.read(mandiFilterProvider).market);
    if (choice == null) return;
    ref.read(mandiFilterProvider.notifier).update((f) => f.copyWith(market: () => choice.value));
    setState(() => _shown = _pageSize);
  }

  Future<void> _pickVariety(BuildContext context, List<LiveMandiPrice> current) async {
    final t = AppLocalizations.of(context)!;
    final varieties = current.map((p) => p.variety).where((v) => v.isNotEmpty).toSet().toList()..sort();
    final choice = await _showPicker(context, t.mandiFilterVariety, varieties, ref.read(mandiFilterProvider).variety);
    if (choice == null) return;
    ref.read(mandiFilterProvider.notifier).update((f) => f.copyWith(variety: () => choice.value));
    setState(() => _shown = _pageSize);
  }
}

/// `null` = dismissed; a record with a null value = "All".
Future<({String? value})?> _showPicker(BuildContext context, String title, List<String> options, String? selected) {
  final t = AppLocalizations.of(context)!;
  return showModalBottomSheet<({String? value})>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      var query = '';
      return StatefulBuilder(
        builder: (context, setSheet) {
          final filtered = options.where((o) => o.toLowerCase().contains(query)).toList();
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      onChanged: (v) => setSheet(() => query = v.trim().toLowerCase()),
                      decoration: InputDecoration(hintText: title, prefixIcon: const Icon(Icons.search_rounded)),
                    ),
                  ),
                  ListTile(
                    title: Text(t.mandiFilterAll),
                    trailing: selected == null ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                    onTap: () => Navigator.pop(context, (value: null)),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(filtered[i]),
                        trailing: filtered[i] == selected ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                        onTap: () => Navigator.pop(context, (value: filtered[i])),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.value, required this.onTap});

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = value != null && value!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        onPressed: onTap,
        backgroundColor: active ? AppColors.primaryLight : null,
        label: Text(active ? '$label: $value' : label),
        avatar: Icon(Icons.arrow_drop_down, color: active ? AppColors.primary : AppColors.textSecondary),
      ),
    );
  }
}

class _PriceCard extends ConsumerWidget {
  const _PriceCard({required this.price});

  final LiveMandiPrice price;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final watchlist = ref.watch(mandiWatchlistProvider);
    final fav = watchlist.isFavourite(price.commodity);
    final alert = watchlist.alertFor(price.commodity);
    final meta = [price.variety, price.grade].where((s) => s.isNotEmpty).join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price.commodity.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 0.3),
                      ),
                      if (meta.isNotEmpty)
                        Text(meta, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: fav ? t.removeFromFavourite : t.addToFavourite,
                  onPressed: () => ref.read(mandiWatchlistProvider.notifier).toggleFavourite(price.commodity),
                  icon: Icon(
                    fav ? Icons.star_rounded : Icons.star_border_rounded,
                    color: fav ? AppColors.warning : AppColors.textSecondary,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: t.setPriceAlert,
                  onPressed: () => showPriceAlertDialog(context, ref, price.commodity),
                  icon: Icon(
                    alert != null ? Icons.notifications_active_rounded : Icons.notifications_none_rounded,
                    color: alert != null ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    [price.market, price.district].where((s) => s.isNotEmpty).join(', '),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PriceTriple(min: price.minPrice, modal: price.modalPrice, max: price.maxPrice),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${t.mandiReportedOn(DateFormat('d MMM yyyy').format(price.arrivalDate))} · ${t.perQuintalLabel}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.push(
                    Uri(
                      path: '/mandi/history',
                      queryParameters: {'commodity': price.commodity, 'market': price.market},
                    ).toString(),
                  ),
                  icon: const Icon(Icons.show_chart_rounded, size: 18),
                  label: Text(t.mandiHistoryTitle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
