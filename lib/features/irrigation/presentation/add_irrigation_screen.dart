import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/irrigation_log.dart';
import '../irrigation_providers.dart';

class AddIrrigationScreen extends ConsumerStatefulWidget {
  const AddIrrigationScreen({super.key});

  @override
  ConsumerState<AddIrrigationScreen> createState() => _AddIrrigationScreenState();
}

class _AddIrrigationScreenState extends ConsumerState<AddIrrigationScreen> {
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  String? _method;
  bool _saving = false;

  static const _methods = ['borewell', 'canal', 'drip', 'sprinkler', 'flood'];

  @override
  void dispose() {
    _durationController.dispose();
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
    if (farm == null) return;
    setState(() => _saving = true);
    try {
      final season = ref.read(primaryActiveSeasonProvider).valueOrNull;
      await ref.read(irrigationRepositoryProvider).addLog(
            IrrigationLogEntry(
              id: newId(),
              farmId: farm.id,
              seasonId: season?.id,
              date: _date,
              durationMinutes: int.tryParse(_durationController.text.trim()),
              method: _method,
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddIrrigationScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.logIrrigation)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
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
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t.durationMinutesLabel),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _method,
              decoration: InputDecoration(labelText: t.methodLabel),
              items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (m) => setState(() => _method = m),
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
