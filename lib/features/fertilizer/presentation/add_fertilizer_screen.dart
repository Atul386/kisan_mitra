import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/fertilizer_log.dart';
import '../fertilizer_providers.dart';

class AddFertilizerScreen extends ConsumerStatefulWidget {
  const AddFertilizerScreen({super.key});

  @override
  ConsumerState<AddFertilizerScreen> createState() => _AddFertilizerScreenState();
}

class _AddFertilizerScreenState extends ConsumerState<AddFertilizerScreen> {
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final farm = ref.read(primaryFarmProvider);
    if (farm == null || _productController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      final season = ref.read(primaryActiveSeasonProvider).valueOrNull;
      await ref.read(fertilizerRepositoryProvider).addLog(
            FertilizerLogEntry(
              id: newId(),
              farmId: farm.id,
              seasonId: season?.id,
              date: _date,
              product: _productController.text.trim(),
              quantity: double.tryParse(_quantityController.text.trim()),
              unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
              cost: double.tryParse(_costController.text.trim()),
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddFertilizerScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.logFertilizer)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: t.productLabel),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t.quantityLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _unitController,
                    decoration: InputDecoration(labelText: t.unitLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _costController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.costLabel, prefixText: '₹ '),
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
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: t.notesLabel),
              maxLines: 2,
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
