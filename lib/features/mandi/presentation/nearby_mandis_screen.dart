import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/link_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/live_mandi_price.dart';
import '../domain/nearby_mandis.dart';
import '../mandi_providers.dart';
import 'mandi_widgets.dart';

/// The farmer's own district if it is known (from the farm, else the
/// profile), so the screen opens on their nearest markets.
final _homeDistrictProvider = Provider<String?>((ref) {
  final fromFarm = ref.watch(primaryFarmProvider)?.district;
  if (fromFarm != null && fromFarm.trim().isNotEmpty) return fromFarm;
  return ref.watch(currentUserProvider).valueOrNull?.district;
});

class NearbyMandisScreen extends ConsumerStatefulWidget {
  const NearbyMandisScreen({super.key});

  @override
  ConsumerState<NearbyMandisScreen> createState() => _NearbyMandisScreenState();
}

class _NearbyMandisScreenState extends ConsumerState<NearbyMandisScreen> {
  /// Set when the farmer picks a district by hand.
  String? _picked;

  Future<void> _openDirections(MandiMarket market) async {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final state = ref.read(mandiStateProvider) ?? '';
    final ok = await ref.read(linkLauncherProvider).openWebsite(mandiMapsUri(market, state).toString());
    if (!ok) messenger.showSnackBar(SnackBar(content: Text(t.couldNotOpenLink)));
  }

  void _showPrices(MandiMarket market) {
    // Narrow the live price list to this market, then open it.
    ref.read(mandiFilterProvider.notifier).update(
          (f) => f.copyWith(commodity: () => '', district: () => null, market: () => market.market, variety: () => null),
        );
    context.push('/mandi/live');
  }

  Future<void> _pickDistrict(List<String> districts) async {
    final t = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.6,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(t.nearbyMandisPickDistrict, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              Expanded(
                child: ListView(
                  children: [for (final d in districts) ListTile(title: Text(d), onTap: () => Navigator.pop(context, d))],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (choice != null) setState(() => _picked = choice);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final markets = ref.watch(mandiMarketsProvider);
    final district = _picked ?? ref.watch(_homeDistrictProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.nearbyMandisTitle)),
      body: SafeArea(
        child: markets.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => MandiMessage(
            text: mandiErrorText(t, e),
            actionLabel: t.tryAgain,
            onAction: () => ref.invalidate(mandiMarketsProvider),
          ),
          data: (result) {
            final all = result.value;
            final grouping = groupMarkets(all, district: district);
            final allDistricts = {for (final m in all) if (m.district.isNotEmpty) m.district}.toList()..sort();

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (result.fromCache) OfflineBanner(cachedAt: result.cachedAt),
                OutlinedButton.icon(
                  onPressed: () => _pickDistrict(allDistricts),
                  icon: const Icon(Icons.place_outlined),
                  label: Text(district == null ? t.nearbyMandisPickDistrict : '${t.nearbyMandisDistrictLabel}: $district'),
                ),
                const SizedBox(height: 6),
                Text(t.nearbyMandisNote, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 16),
                if (district != null) ...[
                  _Header(t.nearbyMandisInDistrict(district)),
                  if (grouping.inDistrict.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(t.nearbyMandisNoneInDistrict(district), style: const TextStyle(color: AppColors.textSecondary)),
                    )
                  else
                    for (final m in grouping.inDistrict) _MarketTile(market: m, onPrices: _showPrices, onDirections: _openDirections),
                ],
                if (grouping.otherDistricts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _Header(district == null ? t.mandiAllMarkets : t.nearbyMandisOtherDistricts),
                  for (final entry in grouping.otherDistricts.entries) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                    ),
                    for (final m in entry.value) _MarketTile(market: m, onPrices: _showPrices, onDirections: _openDirections),
                  ],
                ],
                if (grouping.isEmpty) MandiMessage(text: t.mandiNoPrices),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)));
}

class _MarketTile extends StatelessWidget {
  const _MarketTile({required this.market, required this.onPrices, required this.onDirections});

  final MandiMarket market;
  final void Function(MandiMarket) onPrices;
  final void Function(MandiMarket) onDirections;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(market.market, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            if (market.district.isNotEmpty)
              Text(market.district, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Wrap(
              children: [
                TextButton.icon(onPressed: () => onPrices(market), icon: const Icon(Icons.trending_up_rounded, size: 18), label: Text(t.nearbyMandisPrices)),
                TextButton.icon(onPressed: () => onDirections(market), icon: const Icon(Icons.directions_rounded, size: 18), label: Text(t.nearbyMandisDirections)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
