import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../../documents/data/document_file_service.dart';
import '../../documents/document_providers.dart';
import '../../documents/domain/farm_document.dart';
import '../domain/soil_report.dart';
import '../soil_providers.dart';

class AddSoilReportScreen extends ConsumerStatefulWidget {
  const AddSoilReportScreen({super.key});

  @override
  ConsumerState<AddSoilReportScreen> createState() => _AddSoilReportScreenState();
}

class _AddSoilReportScreenState extends ConsumerState<AddSoilReportScreen> {
  final _ph = TextEditingController();
  final _n = TextEditingController();
  final _p = TextEditingController();
  final _k = TextEditingController();
  final _oc = TextEditingController();
  final _other = TextEditingController();
  final _errors = <String, String?>{};
  DateTime _date = DateTime.now();
  String? _cardPath;
  String? _formError;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_ph, _n, _p, _k, _oc, _other]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickCard() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 2000, imageQuality: 80);
      if (picked != null) setState(() => _cardPath = picked.path);
    } catch (e, st) {
      reportError(e, st, context: 'AddSoilReportScreen.pickCard');
      if (mounted) showGenericErrorSnackBar(context);
    }
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    final farm = ref.read(primaryFarmProvider);
    if (farm == null) return;

    final fields = {
      'ph': (_ph, SoilLimits.ph),
      'n': (_n, SoilLimits.nutrientKgPerHa),
      'p': (_p, SoilLimits.nutrientKgPerHa),
      'k': (_k, SoilLimits.nutrientKgPerHa),
      'oc': (_oc, SoilLimits.organicCarbonPercent),
    };
    final parsed = <String, SoilParse>{};
    _errors.clear();
    fields.forEach((key, f) {
      final r = f.$2.parse(f.$1.text);
      parsed[key] = r;
      if (r.isInvalid) _errors[key] = t.soilValueRange(f.$2.min.toStringAsFixed(0), f.$2.max.toStringAsFixed(0));
    });
    final anyValue = parsed.values.any((r) => r.value != null);
    setState(() => _formError = (_errors.isEmpty && !anyValue) ? t.soilNeedOneValue : null);
    if (_errors.isNotEmpty || !anyValue) {
      setState(() {});
      return;
    }

    setState(() => _saving = true);
    try {
      String? documentId;
      if (_cardPath != null) {
        // The scanned card goes into the document locker as a Soil Health Card.
        final stored = await ref.read(documentFileServiceProvider).importFile(_cardPath!, displayName: 'soil_health_card.jpg');
        documentId = newId();
        await ref.read(documentRepositoryProvider).addDocument(
              FarmDocument(
                id: documentId,
                farmId: farm.id,
                category: DocumentCategory.soilHealthCard,
                title: '${t.docCatSoil} ${DateFormat('d MMM yyyy').format(_date)}',
                localPath: stored.path,
                mimeType: stored.mimeType,
                sizeBytes: stored.sizeBytes,
                createdAt: DateTime.now(),
              ),
            );
      }
      await ref.read(soilRepositoryProvider).addReport(
            SoilReport(
              id: newId(),
              farmId: farm.id,
              date: _date,
              ph: parsed['ph']!.value,
              nitrogen: parsed['n']!.value,
              phosphorus: parsed['p']!.value,
              potassium: parsed['k']!.value,
              organicCarbon: parsed['oc']!.value,
              otherNutrients: _other.text.trim().isEmpty ? null : _other.text.trim(),
              documentId: documentId,
            ),
          );
      if (mounted) context.pop();
    } on DocumentRejectedException {
      if (mounted) showGenericErrorSnackBar(context);
    } catch (e, st) {
      reportError(e, st, context: 'AddSoilReportScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    Widget field(String key, TextEditingController c, String label) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            controller: c,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: InputDecoration(labelText: label, errorText: _errors[key]),
            onChanged: (_) {
              if (_errors[key] != null || _formError != null) {
                setState(() {
                  _errors.remove(key);
                  _formError = null;
                });
              }
            },
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(t.soilAdd)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.soilDate,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text(DateFormat('d MMM yyyy').format(_date)),
              ),
            ),
            const SizedBox(height: 16),
            field('ph', _ph, t.soilPh),
            field('n', _n, t.soilNitrogen),
            field('p', _p, t.soilPhosphorus),
            field('k', _k, t.soilPotassium),
            field('oc', _oc, t.soilOrganicCarbon),
            TextField(
              controller: _other,
              maxLines: 2,
              decoration: InputDecoration(labelText: t.soilOther, hintText: t.soilOtherHint, alignLabelWithHint: true),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickCard,
              icon: Icon(_cardPath == null ? Icons.photo_camera_outlined : Icons.check_circle, color: _cardPath == null ? null : Colors.green),
              label: Text(_cardPath == null ? t.soilAttachCard : t.soilCardAttached),
            ),
            if (_cardPath != null && File(_cardPath!).existsSync()) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(_cardPath!), height: 140, fit: BoxFit.cover, cacheWidth: 600),
              ),
            ],
            if (_formError != null) ...[
              const SizedBox(height: 12),
              Text(_formError!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            Text(t.soilAdviceNote, style: const TextStyle(fontSize: 12, height: 1.4)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _saving ? null : _save, child: Text(t.save)),
          ],
        ),
      ),
    );
  }
}
