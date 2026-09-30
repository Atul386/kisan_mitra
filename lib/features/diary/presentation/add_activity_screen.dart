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
import '../../../core/utils/photo_storage.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop/crop_providers.dart';
import '../diary_providers.dart';
import '../domain/crop_activity.dart';
import 'activity_labels.dart';

/// Adds a diary entry, or edits one when [activityId] is given.
class AddActivityScreen extends ConsumerStatefulWidget {
  const AddActivityScreen({required this.seasonId, this.activityId, super.key});

  final String seasonId;
  final String? activityId;

  @override
  ConsumerState<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends ConsumerState<AddActivityScreen> {
  final _notes = TextEditingController();
  final _cost = TextEditingController();
  String? _costError;
  ActivityType _type = ActivityType.irrigation;
  DateTime _date = DateTime.now();
  String? _photoPath;
  CropActivity? _existing;
  bool _loading = false;
  bool _saving = false;

  bool get _editing => widget.activityId != null;

  @override
  void initState() {
    super.initState();
    if (_editing) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final a = await ref.read(cropActivityRepositoryProvider).getActivity(widget.activityId!);
    if (!mounted) return;
    setState(() {
      _existing = a;
      if (a != null) {
        _type = a.type;
        _date = a.date;
        _notes.text = a.notes ?? '';
        _cost.text = a.cost == null ? '' : (a.cost! == a.cost!.roundToDouble() ? a.cost!.toStringAsFixed(0) : a.cost.toString());
        _photoPath = a.photoPath;
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _notes.dispose();
    _cost.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      // Downscale + compress at pick time: keeps storage and later uploads small.
      final picked = await ImagePicker().pickImage(source: source, maxWidth: 1280, imageQuality: 70);
      if (picked == null) return;
      final path = await saveImageLocally(picked, category: 'diary_photos');
      if (mounted) setState(() => _photoPath = path);
    } catch (e, st) {
      reportError(e, st, context: 'AddActivityScreen.pickPhoto');
      if (mounted) showGenericErrorSnackBar(context);
    }
  }

  Future<void> _save() async {
    final season = ref.read(seasonProvider(widget.seasonId)).valueOrNull;
    if (season == null) return;
    final t = AppLocalizations.of(context)!;
    final costText = _cost.text.trim().replaceAll(',', '.');
    final cost = costText.isEmpty ? null : double.tryParse(costText);
    if (costText.isNotEmpty && (cost == null || cost < 0 || !cost.isFinite)) {
      setState(() => _costError = t.invalidNumber);
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(cropActivityRepositoryProvider);
      final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
      if (_editing && _existing != null) {
        await repo.updateActivity(
          CropActivity(
            id: _existing!.id,
            farmId: _existing!.farmId,
            seasonId: _existing!.seasonId,
            type: _type,
            date: _date,
            notes: notes,
            photoPath: _photoPath,
            cost: cost,
          ),
        );
      } else {
        await repo.addActivity(
          CropActivity(
            id: newId(),
            farmId: season.farmId,
            seasonId: season.id,
            type: _type,
            date: _date,
            notes: notes,
            photoPath: _photoPath,
            cost: cost,
          ),
        );
      }
      if (mounted) context.pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddActivityScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final t = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(t.deleteActivityConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(cropActivityRepositoryProvider).deleteActivity(widget.activityId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final photo = _photoPath;

    return Scaffold(
      appBar: AppBar(
        title: Text(_editing ? t.editActivity : t.addActivity),
        actions: [if (_editing) IconButton(onPressed: _delete, icon: const Icon(Icons.delete_outline), tooltip: t.deleteButton)],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(t.activityTypeLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final type in ActivityType.values)
                        ChoiceChip(
                          label: Text('${type.emoji}  ${activityLabel(t, type)}'),
                          selected: _type == type,
                          onSelected: (_) => setState(() => _type = type),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: t.activityDateLabel,
                        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                      ),
                      child: Text(DateFormat('d MMM yyyy').format(_date)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notes,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: t.activityNotesHint, alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cost,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                    decoration: InputDecoration(labelText: t.activityCostLabel, errorText: _costError),
                    onChanged: (_) {
                      if (_costError != null) setState(() => _costError = null);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (photo != null && File(photo).existsSync())
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(photo), height: 180, width: double.infinity, fit: BoxFit.cover, cacheWidth: 800),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _pickPhoto(ImageSource.camera),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(photo == null ? t.addPhoto : t.changePhoto),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _pickPhoto(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(t.galleryLabel),
                      ),
                      if (photo != null)
                        TextButton(onPressed: () => setState(() => _photoPath = null), child: Text(t.removePhoto)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _saving ? null : _save, child: Text(t.save)),
                ],
              ),
      ),
    );
  }
}
