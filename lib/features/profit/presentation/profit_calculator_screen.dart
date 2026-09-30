import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop_library/crop_library_providers.dart';
import '../../dashboard/dashboard_providers.dart';
import '../../mandi/mandi_providers.dart';
import '../domain/profit_estimate.dart';

class ProfitCalculatorScreen extends ConsumerStatefulWidget {
  const ProfitCalculatorScreen({super.key});

  @override
  ConsumerState<ProfitCalculatorScreen> createState() => _ProfitCalculatorScreenState();
}

class _ProfitCalculatorScreenState extends ConsumerState<ProfitCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _area = TextEditingController();
  final _yield = TextEditingController();
  final _price = TextEditingController();
  final _seed = TextEditingController();
  final _fertilizer = TextEditingController();
  final _labour = TextEditingController();
  final _irrigation = TextEditingController();
  final _transport = TextEditingController();
  final _other = TextEditingController();
  String? _cropId;
  ProfitEstimate? _result;
  bool _prefilled = false;

  List<TextEditingController> get _all => [_area, _yield, _price, _seed, _fertilizer, _labour, _irrigation, _transport, _other];

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  String? _required(String? v, AppLocalizations t) {
    final n = double.tryParse((v ?? '').trim());
    return n == null || n < 0 ? t.invalidNumber : null;
  }

  String? _optional(String? v, AppLocalizations t) {
    if (v == null || v.trim().isEmpty) return null;
    final n = double.tryParse(v.trim());
    return n == null || n < 0 ? t.invalidNumber : null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _result = ProfitEstimate.calculate(
        areaAcres: _num(_area),
        yieldPerAcreQuintal: _num(_yield),
        pricePerQuintal: _num(_price),
        costs: [_seed, _fertilizer, _labour, _irrigation, _transport, _other].map(_num),
      );
    });
  }

  void _reset() {
    for (final c in _all) {
      c.clear();
    }
    setState(() {
      _result = null;
      _cropId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final crops = ref.watch(cropLibraryProvider).valueOrNull ?? const [];
    final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;
    final trends = ref.watch(mandiTrendsProvider);

    // Start from the farmer's own crop and area once, without overwriting edits.
    if (!_prefilled && season != null) {
      _prefilled = true;
      _cropId = crops.any((c) => c.id == season.cropId) ? season.cropId : null;
      if (season.area != null && _area.text.isEmpty) _area.text = season.area!.toString();
    }

    final savedPrice = trends.isEmpty ? null : trends.first.latest.price;
    final money = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    Widget field(TextEditingController c, String label, {bool required = false}) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: c,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(labelText: label),
            validator: (v) => required ? _required(v, t) : _optional(v, t),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(t.profitTitle)),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.estimateOnly, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(t.estimateDisclaimer, style: const TextStyle(fontSize: 12, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (crops.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DropdownButtonFormField<String>(
                    key: ValueKey(_cropId),
                    initialValue: _cropId,
                    decoration: InputDecoration(labelText: t.profitCrop),
                    items: [for (final c in crops) DropdownMenuItem(value: c.id, child: Text('${c.icon}  ${c.name}'))],
                    onChanged: (v) => setState(() => _cropId = v),
                  ),
                ),
              field(_area, t.profitArea, required: true),
              field(_yield, t.profitYield, required: true),
              field(_price, t.profitPrice, required: true),
              if (savedPrice != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => setState(() => _price.text = savedPrice.toStringAsFixed(0)),
                    icon: const Icon(Icons.trending_up_rounded),
                    label: Text(t.profitUseSavedPrice(savedPrice.toStringAsFixed(0))),
                  ),
                ),
              field(_seed, t.costSeed),
              field(_fertilizer, t.costFertilizer),
              field(_labour, t.costLabour),
              field(_irrigation, t.costIrrigation),
              field(_transport, t.costTransport),
              field(_other, t.costOther),
              const SizedBox(height: 4),
              FilledButton(onPressed: _calculate, child: Text(t.profitCalculate)),
              TextButton(onPressed: _reset, child: Text(t.profitReset)),
              if (_result != null) ...[
                const SizedBox(height: 12),
                _ResultCard(result: _result!, money: money),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, required this.money});

  final ProfitEstimate result;
  final NumberFormat money;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final color = result.isLoss ? AppColors.error : AppColors.primary;

    Widget row(String label, String value, {bool bold = false, Color? c}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
              Text(value, style: TextStyle(fontWeight: FontWeight.w800, fontSize: bold ? 20 : 16, color: c)),
            ],
          ),
        );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            row(t.profitRevenue, money.format(result.revenue)),
            row(t.profitCost, money.format(result.cost)),
            const Divider(),
            row(result.isLoss ? t.profitLossLabel : t.profitMargin, money.format(result.margin.abs()), bold: true, c: color),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(t.estimateOnly, style: const TextStyle(fontSize: 11, letterSpacing: 1, color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
