import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../diary/diary_providers.dart';
import '../../expenses/expense_providers.dart';
import '../crop_providers.dart';
import '../domain/season.dart';

/// Total spent on one crop (all its expenses), for the detail page.
final _seasonExpenseTotalProvider = StreamProvider.family<double, Season>((ref, season) {
  return ref
      .watch(expenseRepositoryProvider)
      .watchExpenses(farmId: season.farmId, seasonId: season.id)
      .map((list) => list.fold<double>(0, (sum, e) => sum + e.amount));
});

String cropStatusLabel(AppLocalizations t, String status) => switch (status) {
      SeasonStatus.harvested => t.cropStatusHarvested,
      SeasonStatus.completed => t.cropStatusCompleted,
      _ => t.cropStatusActive,
    };

Color cropStatusColor(String status) => switch (status) {
      SeasonStatus.harvested => AppColors.warning,
      SeasonStatus.completed => AppColors.textSecondary,
      _ => AppColors.primary,
    };

class CropDetailScreen extends ConsumerWidget {
  const CropDetailScreen({required this.seasonId, super.key});

  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final seasonAsync = ref.watch(seasonProvider(seasonId));
    final season = seasonAsync.valueOrNull;

    if (season == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.cropDetailTitle)),
        body: Center(child: seasonAsync.isLoading ? const CircularProgressIndicator() : Text(t.genericErrorMessage)),
      );
    }

    final activityCount = ref.watch(seasonActivitiesProvider(seasonId)).valueOrNull?.length ?? 0;
    final spent = ref.watch(_seasonExpenseTotalProvider(season)).valueOrNull ?? 0;
    final fmt = DateFormat('d MMM yyyy');
    final money = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    Widget row(IconData icon, String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(season.cropName),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => _onMenu(context, ref, season, v),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(t.editDetails)),
              if (season.status != SeasonStatus.active) PopupMenuItem(value: SeasonStatus.active, child: Text(t.markActive)),
              if (season.status != SeasonStatus.harvested)
                PopupMenuItem(value: SeasonStatus.harvested, child: Text(t.markHarvested)),
              if (season.status != SeasonStatus.completed)
                PopupMenuItem(value: SeasonStatus.completed, child: Text(t.markCompleted)),
              PopupMenuItem(value: 'delete', child: Text(t.deleteCrop, style: const TextStyle(color: AppColors.error))),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            season.variety == null ? season.cropName : '${season.cropName} · ${season.variety}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: cropStatusColor(season.status).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cropStatusLabel(t, season.status),
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: cropStatusColor(season.status)),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    row(Icons.event_outlined, t.sowingDateLabel, fmt.format(season.sowingDate)),
                    if (season.isActive) row(Icons.timelapse_rounded, t.cropStatusLabel, t.dayNumber(season.dayNumber)),
                    row(
                      Icons.agriculture_outlined,
                      t.expectedHarvestLabel,
                      season.expectedHarvestDate == null ? '—' : fmt.format(season.expectedHarvestDate!),
                    ),
                    if (season.area != null)
                      row(Icons.landscape_outlined, t.areaLabel, '${season.area} ${season.areaUnit ?? ''}'.trim()),
                    row(Icons.currency_rupee_rounded, t.cropDetailCosts, money.format(spent)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.notesLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      season.notes?.isNotEmpty == true ? season.notes! : t.cropDetailNoNotes,
                      style: TextStyle(color: season.notes?.isNotEmpty == true ? null : AppColors.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                minTileHeight: 64,
                leading: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                title: Text(t.openCropDiary, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(t.activitiesCount(activityCount)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/crop/$seasonId/diary'),
              ),
            ),
            const SizedBox(height: 4),
            Card(
              margin: const EdgeInsets.only(top: 8),
              child: ListTile(
                minTileHeight: 64,
                leading: const Icon(Icons.library_books_outlined, color: AppColors.primary),
                title: Text(t.cropLibraryTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/crop-library/${season.cropId}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onMenu(BuildContext context, WidgetRef ref, Season season, String value) async {
    final repo = ref.read(seasonRepositoryProvider);
    switch (value) {
      case 'edit':
        await _showEditSheet(context, ref, season);
      case 'delete':
        final t = AppLocalizations.of(context)!;
        final ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            content: Text(t.deleteCropConfirm),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
              TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
            ],
          ),
        );
        if (ok == true) {
          await repo.deleteSeason(season.id);
          if (context.mounted) context.pop();
        }
      default:
        await repo.updateStatus(season.id, value);
    }
  }

  Future<void> _showEditSheet(BuildContext context, WidgetRef ref, Season season) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EditSheet(season: season),
    );
  }
}

class _EditSheet extends ConsumerStatefulWidget {
  const _EditSheet({required this.season});

  final Season season;

  @override
  ConsumerState<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends ConsumerState<_EditSheet> {
  late final _variety = TextEditingController(text: widget.season.variety ?? '');
  late final _area = TextEditingController(text: widget.season.area?.toString() ?? '');
  late final _notes = TextEditingController(text: widget.season.notes ?? '');
  late DateTime? _harvest = widget.season.expectedHarvestDate;

  @override
  void dispose() {
    _variety.dispose();
    _area.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickHarvest() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _harvest ?? widget.season.sowingDate.add(const Duration(days: 120)),
      firstDate: widget.season.sowingDate,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _harvest = picked);
  }

  Future<void> _save() async {
    String? clean(String s) => s.trim().isEmpty ? null : s.trim();
    await ref.read(seasonRepositoryProvider).updateDetails(
          widget.season.id,
          variety: clean(_variety.text),
          area: double.tryParse(_area.text.trim()),
          expectedHarvestDate: _harvest,
          notes: clean(_notes.text),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _variety, decoration: InputDecoration(labelText: t.varietyLabel)),
            const SizedBox(height: 12),
            TextField(
              controller: _area,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: InputDecoration(labelText: t.areaLabel),
            ),
            const SizedBox(height: 12),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickHarvest,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.expectedHarvestLabel,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text(_harvest == null ? '—' : DateFormat('d MMM yyyy').format(_harvest!)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: t.notesLabel, alignLabelWithHint: true),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: _save, child: Text(t.save))),
          ],
        ),
      ),
    );
  }
}
