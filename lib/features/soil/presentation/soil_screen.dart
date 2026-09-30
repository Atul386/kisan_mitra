import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../documents/document_providers.dart';
import '../../nearby/domain/nearby_category.dart';
import '../../nearby/nearby_actions.dart';
import '../domain/soil_report.dart';
import '../soil_providers.dart';

class SoilScreen extends ConsumerWidget {
  const SoilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final reports = ref.watch(soilReportsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.soilTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/soil/add'),
        icon: const Icon(Icons.add),
        label: Text(t.soilAdd),
      ),
      body: SafeArea(
        child: reports.when(
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
                      const Icon(Icons.science_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      Text(t.soilEmpty, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => openNearby(context, ref, NearbyCategory.soilLab),
                        icon: const Icon(Icons.place_outlined),
                        label: Text(t.soilFindLabs),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
                  child: Text(t.soilAdviceNote, style: const TextStyle(fontSize: 12, height: 1.4)),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => openNearby(context, ref, NearbyCategory.soilLab),
                  icon: const Icon(Icons.place_outlined),
                  label: Text(t.soilFindLabs),
                ),
                const SizedBox(height: 12),
                for (final r in list) _SoilCard(report: r),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SoilCard extends ConsumerWidget {
  const _SoilCard({required this.report});

  final SoilReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    String num(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');

    final values = <(String, String)>[
      if (report.ph != null) (t.soilPh, num(report.ph!)),
      if (report.nitrogen != null) (t.soilNitrogen, num(report.nitrogen!)),
      if (report.phosphorus != null) (t.soilPhosphorus, num(report.phosphorus!)),
      if (report.potassium != null) (t.soilPotassium, num(report.potassium!)),
      if (report.organicCarbon != null) (t.soilOrganicCarbon, num(report.organicCarbon!)),
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('d MMM yyyy').format(report.date),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                IconButton(
                  tooltip: t.deleteButton,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(t.soilDeleteConfirm),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
                        ],
                      ),
                    );
                    if (ok == true) await ref.read(soilRepositoryProvider).deleteReport(report.id);
                  },
                ),
              ],
            ),
            for (final (label, value) in values)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
                    Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            if (report.otherNutrients != null && report.otherNutrients!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(report.otherNutrients!, style: const TextStyle(height: 1.4)),
            ],
            if (report.documentId != null)
              TextButton.icon(
                onPressed: () async {
                  final doc = await ref.read(documentRepositoryProvider).getDocument(report.documentId!);
                  if (doc != null) await OpenFilex.open(doc.localPath);
                },
                icon: const Icon(Icons.badge_outlined),
                label: Text(t.soilViewCard),
              ),
          ],
        ),
      ),
    );
  }
}
