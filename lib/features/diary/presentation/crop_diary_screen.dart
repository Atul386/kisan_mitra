import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../crop/crop_providers.dart';
import '../diary_providers.dart';
import '../domain/crop_activity.dart';
import 'activity_labels.dart';

/// Timeline of everything done on one crop, newest first.
class CropDiaryScreen extends ConsumerWidget {
  const CropDiaryScreen({required this.seasonId, super.key});

  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final season = ref.watch(seasonProvider(seasonId)).valueOrNull;
    final activities = ref.watch(seasonActivitiesProvider(seasonId));

    return Scaffold(
      appBar: AppBar(title: Text(season == null ? t.cropDiaryTitle : '${t.cropDiaryTitle} · ${season.cropName}')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crop/$seasonId/diary/add'),
        icon: const Icon(Icons.add),
        label: Text(t.addActivity),
      ),
      body: SafeArea(
        child: activities.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(t.genericErrorMessage)),
          data: (list) {
            if (list.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(
                        t.diaryEmpty,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: list.length,
              itemBuilder: (context, i) => _TimelineRow(
                activity: list[i],
                isFirst: i == 0,
                isLast: i == list.length - 1,
                seasonId: seasonId,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.activity, required this.isFirst, required this.isLast, required this.seasonId});

  final CropActivity activity;
  final bool isFirst;
  final bool isLast;
  final String seasonId;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final photo = activity.photoPath;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Expanded(flex: 1, child: Container(width: 2, color: isFirst ? Colors.transparent : AppColors.border)),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                  child: Text(activity.type.emoji, style: const TextStyle(fontSize: 20)),
                ),
                Expanded(flex: 4, child: Container(width: 2, color: isLast ? Colors.transparent : AppColors.border)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 4),
              child: Card(
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/crop/$seasonId/diary/${activity.id}/edit'),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('d MMM yyyy').format(activity.date),
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activityLabel(t, activity.type),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        if (activity.cost != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '₹${NumberFormat.decimalPattern('en_IN').format(activity.cost)}',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                          ),
                        ],
                        if (activity.notes != null && activity.notes!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(activity.notes!, style: const TextStyle(height: 1.35)),
                        ],
                        if (photo != null && File(photo).existsSync()) ...[
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(photo), height: 140, width: double.infinity, fit: BoxFit.cover, cacheWidth: 600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
