import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/mandi_price.dart';
import '../mandi_providers.dart';

class AddMandiPriceScreen extends ConsumerStatefulWidget {
  const AddMandiPriceScreen({super.key});

  @override
  ConsumerState<AddMandiPriceScreen> createState() => _AddMandiPriceScreenState();
}

class _AddMandiPriceScreenState extends ConsumerState<AddMandiPriceScreen> {
  final _commodityController = TextEditingController();
  final _marketController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _commodityController.dispose();
    _marketController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final farm = ref.read(primaryFarmProvider);
    final price = double.tryParse(_priceController.text.trim());
    if (farm == null || price == null || _commodityController.text.trim().isEmpty) return;

    setState(() => _saving = true);
    try {
      await ref.read(mandiRepositoryProvider).addPrice(
            MandiPriceEntry(
              id: newId(),
              farmId: farm.id,
              commodity: _commodityController.text.trim(),
              market: _marketController.text.trim().isEmpty ? null : _marketController.text.trim(),
              price: price,
              date: _date,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddMandiPriceScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.addMandiPrice)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _commodityController,
              decoration: InputDecoration(labelText: t.commodityLabel),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _marketController,
              decoration: InputDecoration(labelText: t.marketLabel),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.priceLabel, prefixText: '₹ '),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.dateLabel,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text('${_date.day}/${_date.month}/${_date.year}'),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(t.save),
            ),
          ],
        ),
      ),
    );
  }
}
