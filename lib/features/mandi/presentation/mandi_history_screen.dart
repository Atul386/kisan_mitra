import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_mandi_price.dart';
import '../mandi_providers.dart';
import 'mandi_widgets.dart';
import 'price_line_chart.dart';

enum _Range { today, week, month }

class MandiHistoryScreen extends ConsumerStatefulWidget {
  const MandiHistoryScreen({required this.commodity, this.market, super.key});

  final String commodity;
  final String? market;

  @override
  ConsumerState<MandiHistoryScreen> createState() => _MandiHistoryScreenState();
}

class _MandiHistoryScreenState extends ConsumerState<MandiHistoryScreen> {
  _Range _range = _Range.week;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // "Today" shows the latest reported day out of the 7-day fetch, so both
    // share one request (the API is rate limited).
    final request = MandiHistoryRequest(
      commodity: widget.commodity,
      market: widget.market,
      days: _range == _Range.month ? 30 : 7,
    );
    final history = ref.watch(mandiHistoryProvider(request));
    final state = ref.watch(mandiStateProvider) ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(t.mandiHistoryTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(widget.commodity, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(
              widget.market ?? t.mandiHistoryStateAverage(state),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            SegmentedButton<_Range>(
              segments: [
                ButtonSegment(value: _Range.today, label: Text(t.mandiHistoryToday)),
                ButtonSegment(value: _Range.week, label: Text(t.mandiHistory7)),
                ButtonSegment(value: _Range.month, label: Text(t.mandiHistory30)),
              ],
              selected: {_range},
              onSelectionChanged: (s) => setState(() => _range = s.first),
            ),
            const SizedBox(height: 16),
            history.when(
              loading: () => const Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())),
              error: (e, _) => MandiMessage(
                text: mandiErrorText(t, e),
                actionLabel: t.tryAgain,
                onAction: () => ref.invalidate(mandiHistoryProvider(request)),
              ),
              data: (result) => _Body(result: result, range: _range),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.result, required this.range});

  final MandiResult<List<MandiHistoryPoint>> result;
  final _Range range;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final points = result.value;
    if (points.isEmpty) return MandiMessage(text: t.mandiHistoryUnavailable);

    final fmt = DateFormat('d MMM yyyy');
    final latest = points.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result.fromCache) OfflineBanner(cachedAt: result.cachedAt),
        if (range == _Range.today) ...[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.mandiLatestReported, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  PriceTriple(min: latest.minPrice, modal: latest.modalPrice, max: latest.maxPrice),
                  const SizedBox(height: 8),
                  Text(
                    t.mandiReportedOn(fmt.format(latest.date)),
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 12, 8),
              child: PriceLineChart(points: points),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (final p in points.reversed)
                  ListTile(
                    dense: true,
                    title: Text(fmt.format(p.date)),
                    subtitle: Text('${t.mandiMin} ₹${p.minPrice.round()}  ·  ${t.mandiMax} ₹${p.maxPrice.round()}'),
                    trailing: Text(
                      '₹${p.modalPrice.round()}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(t.mandiDataNote, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
      ],
    );
  }
}
