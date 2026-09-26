import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../crop_providers.dart';
import '../domain/master_crop.dart';
import '../domain/season.dart';

class AddCropScreen extends ConsumerStatefulWidget {
  const AddCropScreen({required this.farmId, super.key});

  final String farmId;

  @override
  ConsumerState<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends ConsumerState<AddCropScreen> {
  final _varietyController = TextEditingController();
  final _areaController = TextEditingController();
  MasterCrop? _selectedCrop;
  DateTime _sowingDate = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _varietyController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _pickSowingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sowingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _sowingDate = picked);
  }

  Future<void> _save() async {
    final crop = _selectedCrop;
    if (crop == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(seasonRepositoryProvider).addSeason(
            Season(
              id: newId(),
              farmId: widget.farmId,
              cropId: crop.id,
              cropName: crop.nameFor('en'),
              sowingDate: _sowingDate,
              variety: _varietyController.text.trim().isEmpty ? null : _varietyController.text.trim(),
              area: double.tryParse(_areaController.text.trim()),
            ),
          );
      ref.read(analyticsServiceProvider).logEvent('crop_added', parameters: {'cropId': crop.id});
      // Router redirect moves to Dashboard once an active season exists.
    } catch (e, st) {
      reportError(e, st, context: 'AddCropScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final crops = ref.watch(masterCropsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(t.addCropTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            DropdownButtonFormField<MasterCrop>(
              initialValue: _selectedCrop,
              decoration: InputDecoration(labelText: t.cropLabel),
              items: crops
                  .map((c) => DropdownMenuItem(value: c, child: Text(c.nameFor('en'))))
                  .toList(),
              onChanged: (c) => setState(() => _selectedCrop = c),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _varietyController,
              decoration: InputDecoration(labelText: t.varietyLabel),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickSowingDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.sowingDateLabel,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text('${_sowingDate.day}/${_sowingDate.month}/${_sowingDate.year}'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _areaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.areaLabel),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saving || _selectedCrop == null ? null : _save,
              child: Text(t.saveAndContinue),
            ),
          ],
        ),
      ),
    );
  }
}
