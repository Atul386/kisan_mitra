import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../../farm/domain/farm.dart';
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
  final _notesController = TextEditingController();
  DateTime? _expectedHarvest;
  MasterCrop? _selectedCrop;
  DateTime _sowingDate = DateTime.now();
  String? _season;
  AreaUnit? _areaUnit;
  bool _saving = false;

  static const _seasons = ['kharif', 'rabi', 'zaid'];

  /// Indian cropping calendar: Kharif sown Jun–Sep, Rabi Oct–Feb, Zaid Mar–May.
  static String _seasonForMonth(int month) {
    if (month >= 6 && month <= 9) return 'kharif';
    if (month >= 3 && month <= 5) return 'zaid';
    return 'rabi';
  }

  String _seasonLabel(AppLocalizations t, String season) => switch (season) {
        'kharif' => t.seasonKharif,
        'rabi' => t.seasonRabi,
        _ => t.seasonZaid,
      };

  @override
  void dispose() {
    _varietyController.dispose();
    _areaController.dispose();
    _notesController.dispose();
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

  Future<void> _pickHarvestDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedHarvest ?? _sowingDate.add(const Duration(days: 120)),
      firstDate: _sowingDate,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _expectedHarvest = picked);
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
              areaUnit: _effectiveAreaUnit.name,
              seasonName: _season ?? _seasonForMonth(_sowingDate.month),
              expectedHarvestDate: _expectedHarvest,
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            ),
          );
      ref.read(analyticsServiceProvider).logEvent('crop_added', parameters: {'cropId': crop.id});
      // During onboarding the router redirect moves the farmer on; when
      // opened from the Farm tab, close so repeat taps can't add duplicates.
      if (mounted && context.canPop()) context.pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddCropScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Defaults to the farm's own unit so crop area reads the same way.
  AreaUnit get _effectiveAreaUnit {
    final farm = ref.read(primaryFarmProvider);
    return _areaUnit ?? (farm?.id == widget.farmId ? farm!.areaUnit : AreaUnit.acre);
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
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _areaController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: t.areaLabel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<AreaUnit>(
                    initialValue: _effectiveAreaUnit,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: t.areaUnitLabel),
                    items: AreaUnit.values
                        .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                        .toList(),
                    onChanged: (u) => setState(() => _areaUnit = u),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              // Keyed on the sowing month so the default follows date changes
              // until the farmer picks a season explicitly.
              key: ValueKey(_season ?? _seasonForMonth(_sowingDate.month)),
              initialValue: _season ?? _seasonForMonth(_sowingDate.month),
              decoration: InputDecoration(labelText: t.seasonLabel),
              items: _seasons
                  .map((s) => DropdownMenuItem(value: s, child: Text(_seasonLabel(t, s))))
                  .toList(),
              onChanged: (s) => setState(() => _season = s),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickHarvestDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.expectedHarvestLabel,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text(
                  _expectedHarvest == null ? '—' : '${_expectedHarvest!.day}/${_expectedHarvest!.month}/${_expectedHarvest!.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: t.notesLabel, alignLabelWithHint: true),
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
