import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/notifications/notification_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop/crop_providers.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/reminder.dart';
import '../reminder_providers.dart';
import 'reminder_labels.dart';

/// Creates a reminder, or edits one when [reminderId] is given.
class AddReminderScreen extends ConsumerStatefulWidget {
  const AddReminderScreen({this.reminderId, super.key});

  final String? reminderId;

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  final _title = TextEditingController();
  final _notes = TextEditingController();
  ReminderCategory _category = ReminderCategory.irrigation;
  ReminderRepeat _repeat = ReminderRepeat.none;
  String? _cropId;
  bool _notify = true;
  late DateTime _when = _defaultTime();
  Reminder? _existing;
  String? _titleError;
  String? _timeError;
  bool _loading = false;
  bool _saving = false;

  bool get _editing => widget.reminderId != null;

  /// Tomorrow at 7 AM — a sensible start for a farm task.
  static DateTime _defaultTime() {
    final n = DateTime.now().add(const Duration(days: 1));
    return DateTime(n.year, n.month, n.day, 7);
  }

  @override
  void initState() {
    super.initState();
    if (_editing) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ref.read(reminderRepositoryProvider).getReminder(widget.reminderId!);
    if (!mounted) return;
    setState(() {
      _existing = r;
      if (r != null) {
        _title.text = r.title;
        _notes.text = r.body ?? '';
        _category = r.category;
        _repeat = r.repeat;
        _when = r.scheduledFor;
        _cropId = r.cropId;
        _notify = r.notificationEnabled;
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() {
        _when = DateTime(picked.year, picked.month, picked.day, _when.hour, _when.minute);
        _timeError = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_when));
    if (picked != null) {
      setState(() {
        _when = DateTime(_when.year, _when.month, _when.day, picked.hour, picked.minute);
        _timeError = null;
      });
    }
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context)!;
    final title = _title.text.trim();
    final past = _repeat == ReminderRepeat.none && !_when.isAfter(DateTime.now()) && !(_existing?.completed ?? false);
    setState(() {
      _titleError = title.isEmpty ? t.requiredFieldError : null;
      _timeError = past ? t.reminderPastTime : null;
    });
    if (title.isEmpty || past) return;

    setState(() => _saving = true);
    try {
      await ref.read(notificationServiceProvider).requestPermission();
      final actions = ref.read(reminderActionsProvider);
      final body = _notes.text.trim().isEmpty ? null : _notes.text.trim();
      if (_editing && _existing != null) {
        await actions.update(
          _existing!.copyWith(
            title: title,
            body: body,
            scheduledFor: _when,
            category: _category,
            repeat: _repeat,
            cropId: _cropId,
            clearCrop: _cropId == null,
            notificationEnabled: _notify,
          ),
        );
      } else {
        await actions.add(
          Reminder(
            id: '',
            title: title,
            body: body,
            scheduledFor: _when,
            category: _category,
            repeat: _repeat,
            cropId: _cropId,
            notificationEnabled: _notify,
          ),
        );
      }
      if (mounted) context.pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddReminderScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? t.reminderEdit : t.reminderNew)),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(t.reminderCategoryLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in ReminderCategory.values)
                        ChoiceChip(
                          label: Text('${c.emoji}  ${reminderCategoryLabel(t, c)}'),
                          selected: _category == c,
                          onSelected: (_) => setState(() {
                            _category = c;
                            // Prefill a title from the category, but never overwrite the farmer's own.
                            if (_title.text.trim().isEmpty && c != ReminderCategory.custom) {
                              _title.text = reminderCategoryLabel(t, c);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _title,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: t.reminderTitleLabel, errorText: _titleError),
                    onChanged: (_) {
                      if (_titleError != null) setState(() => _titleError = null);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: t.reminderDateLabel,
                              errorText: _timeError,
                              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                            ),
                            child: Text(DateFormat('d MMM yyyy').format(_when)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _pickTime,
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: t.reminderTimeLabel,
                              suffixIcon: const Icon(Icons.schedule, size: 20),
                            ),
                            child: Text(DateFormat('h:mm a').format(_when)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ReminderRepeat>(
                    initialValue: _repeat,
                    decoration: InputDecoration(labelText: t.reminderRepeatLabel),
                    items: [
                      for (final r in ReminderRepeat.values) DropdownMenuItem(value: r, child: Text(reminderRepeatLabel(t, r))),
                    ],
                    onChanged: (v) => setState(() {
                      _repeat = v ?? _repeat;
                      _timeError = null;
                    }),
                  ),
                  const SizedBox(height: 16),
                  _CropPicker(value: _cropId, onChanged: (v) => setState(() => _cropId = v)),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(t.reminderNotifyLabel),
                    value: _notify,
                    onChanged: (v) => setState(() => _notify = v),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notes,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: t.notesLabel, alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: _saving ? null : _save, child: Text(t.save)),
                ],
              ),
      ),
    );
  }
}

/// Optional link from a reminder to one of the farm's crops.
class _CropPicker extends ConsumerWidget {
  const _CropPicker({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final farm = ref.watch(primaryFarmProvider);
    final seasons = farm == null ? const [] : ref.watch(farmSeasonsProvider(farm.id)).valueOrNull ?? const [];
    if (seasons.isEmpty) return const SizedBox.shrink();
    // A saved link to a crop that has since been deleted shows as "no crop".
    final current = seasons.any((s) => s.id == value) ? value : null;

    return DropdownButtonFormField<String?>(
      key: ValueKey(current),
      initialValue: current,
      isExpanded: true,
      decoration: InputDecoration(labelText: t.reminderCropLabel),
      items: [
        DropdownMenuItem<String?>(value: null, child: Text(t.reminderNoCrop)),
        for (final s in seasons)
          DropdownMenuItem<String?>(
            value: s.id,
            child: Text(s.variety == null ? s.cropName : '${s.cropName} · ${s.variety}', overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
