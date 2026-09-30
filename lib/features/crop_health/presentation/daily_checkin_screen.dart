import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/config/feature_flags.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../core/utils/photo_storage.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop/domain/season.dart';
import '../../dashboard/dashboard_providers.dart';
import '../checkin_providers.dart';
import '../domain/daily_checkin.dart';

class DailyCheckinScreen extends ConsumerStatefulWidget {
  const DailyCheckinScreen({super.key});

  @override
  ConsumerState<DailyCheckinScreen> createState() => _DailyCheckinScreenState();
}

class _DailyCheckinScreenState extends ConsumerState<DailyCheckinScreen> {
  bool _editing = false;
  CheckinHealth? _health;
  CheckinConcern? _concern;
  String? _photoPath;
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final farm = ref.read(primaryFarmProvider);
    final health = _health;
    if (farm == null || health == null) return;

    setState(() => _saving = true);
    try {
      final season = ref.read(primaryActiveSeasonProvider).valueOrNull;
      await ref.read(checkinRepositoryProvider).saveCheckin(
            DailyCheckin(
              id: newId(),
              farmId: farm.id,
              seasonId: season?.id,
              date: DateTime.now(),
              healthStatus: health,
              concern: _concern,
              note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
              photoPath: _photoPath,
            ),
          );
      ref.read(analyticsServiceProvider).logEvent(
        'daily_checkin_completed',
        parameters: {'health_status': health.name},
      );
      if (mounted) setState(() => _editing = false);
    } catch (e, st) {
      reportError(e, st, context: 'DailyCheckinScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1280);
    if (picked == null) return;
    final path = await saveImageLocally(picked, category: 'crop_photos');
    setState(() => _photoPath = path);
  }

  void _startEditing([DailyCheckin? existing]) {
    setState(() {
      _editing = true;
      _health = existing?.healthStatus;
      _concern = existing?.concern;
      _photoPath = existing?.photoPath;
      _noteController.text = existing?.note ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final checkinAsync = ref.watch(todayCheckinProvider);
    final season = ref.watch(primaryActiveSeasonProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(t.checkInTitle),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: checkinAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(t.genericErrorMessage)),
          data: (existing) {
            if (!_editing && existing != null) {
              return _AlreadyCheckedInView(
                checkin: existing,
                onChange: () => _startEditing(existing),
              );
            }
            return _buildFlow(context, t, season);
          },
        ),
      ),
    );
  }

  Widget _buildFlow(BuildContext context, AppLocalizations t, Season? season) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      children: [
        if (season != null) _CropInfoCard(cropName: season.cropName, dayLabel: t.dayNumber(season.dayNumber)),
        if (season != null) const SizedBox(height: 20),
        Text(t.howIsYourCropToday, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MoodCard(
                icon: Icons.sentiment_satisfied_rounded,
                color: AppColors.primary,
                backgroundColor: AppColors.primaryLight,
                label: t.checkInPromptGood,
                selected: _health == CheckinHealth.good,
                onTap: () => setState(() {
                  _health = CheckinHealth.good;
                  _concern = null;
                }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MoodCard(
                icon: Icons.sentiment_neutral_rounded,
                color: AppColors.warning,
                backgroundColor: AppColors.warningLight,
                label: t.checkInPromptAttention,
                selected: _health == CheckinHealth.needsAttention,
                onTap: () => setState(() => _health = CheckinHealth.needsAttention),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MoodCard(
                icon: Icons.sentiment_dissatisfied_rounded,
                color: AppColors.error,
                backgroundColor: AppColors.errorLight,
                label: t.checkInPromptProblem,
                selected: _health == CheckinHealth.problem,
                onTap: () => setState(() => _health = CheckinHealth.problem),
              ),
            ),
          ],
        ),
        if (_health == CheckinHealth.needsAttention || _health == CheckinHealth.problem) ...[
          const SizedBox(height: 20),
          Text(t.checkInWhatDidYouNotice, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _concernChip(t.concernPest, CheckinConcern.pest),
              _concernChip(t.concernLeafChange, CheckinConcern.leafChange),
              _concernChip(t.concernWaterStress, CheckinConcern.waterStress),
              _concernChip(t.concernDisease, CheckinConcern.disease),
              _concernChip(t.concernOther, CheckinConcern.other),
            ],
          ),
        ],
        const SizedBox(height: 20),
        _ActionRow(
          icon: _photoPath != null ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
          iconColor: _photoPath != null ? AppColors.primary : AppColors.textSecondary,
          label: t.addPhoto,
          onTap: _addPhoto,
        ),
        if (kAiAssistantEnabled && _health == CheckinHealth.problem) ...[
          const SizedBox(height: 10),
          _ActionRow(
            icon: Icons.mic_none_rounded,
            iconColor: AppColors.primary,
            label: t.askKisanMitra,
            onTap: () => context.push('/dashboard/assistant'),
          ),
        ],
        const SizedBox(height: 20),
        Text(t.addNote, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: t.checkInNoteHint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: _saving || _health == null
                    ? [AppColors.disabled, AppColors.disabled]
                    : [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _saving || _health == null ? null : _save,
                child: Center(
                  child: Text(
                    t.save,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _concernChip(String label, CheckinConcern value) {
    final selected = _concern == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primaryLight,
      labelStyle: TextStyle(color: selected ? AppColors.primary : AppColors.textPrimary, fontWeight: FontWeight.w600),
      side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
      onSelected: (_) => setState(() => _concern = value),
    );
  }
}

class _CropInfoCard extends StatelessWidget {
  const _CropInfoCard({required this.cropName, required this.dayLabel});

  final String cropName;
  final String dayLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.grass_rounded, color: AppColors.primary, size: 26),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cropName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              Text(dayLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? color : Colors.transparent, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.iconColor, required this.label, required this.onTap});

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlreadyCheckedInView extends StatelessWidget {
  const _AlreadyCheckedInView({required this.checkin, required this.onChange});

  final DailyCheckin checkin;
  final VoidCallback onChange;

  (IconData, Color, Color) _visuals(CheckinHealth h) {
    switch (h) {
      case CheckinHealth.good:
        return (Icons.sentiment_satisfied_rounded, AppColors.primary, AppColors.primaryLight);
      case CheckinHealth.needsAttention:
        return (Icons.sentiment_neutral_rounded, AppColors.warning, AppColors.warningLight);
      case CheckinHealth.problem:
        return (Icons.sentiment_dissatisfied_rounded, AppColors.error, AppColors.errorLight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final (icon, color, backgroundColor) = _visuals(checkin.healthStatus);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 40),
            ),
            const SizedBox(height: 16),
            Text(t.alreadyCheckedInMessage, textAlign: TextAlign.center),
            if (checkin.note != null) ...[
              const SizedBox(height: 8),
              Text(
                checkin.note!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onChange, child: Text(t.changeCheckIn)),
          ],
        ),
      ),
    );
  }
}
