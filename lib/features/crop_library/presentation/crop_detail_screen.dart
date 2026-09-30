import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../crop_library_providers.dart';
import '../domain/crop_info.dart';

class CropDetailScreen extends ConsumerWidget {
  const CropDetailScreen({required this.cropId, super.key});

  final String cropId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final crops = ref.watch(cropLibraryProvider);
    CropInfo? crop;
    for (final c in crops.valueOrNull ?? const <CropInfo>[]) {
      if (c.id == cropId) crop = c;
    }

    return Scaffold(
      appBar: AppBar(title: Text(crop?.name ?? t.cropLibraryTitle)),
      body: SafeArea(
        child: crop == null
            ? Center(
                child: crops.isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(t.cropLibraryLoadError, textAlign: TextAlign.center),
                      ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Row(
                    children: [
                      Text(crop.icon, style: const TextStyle(fontSize: 44)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(crop.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _Section(Icons.info_outline, t.cropOverview, crop.overview),
                  _Section(Icons.calendar_month_outlined, t.cropSowing, crop.sowing),
                  _Section(Icons.terrain_outlined, t.cropSoil, crop.soil),
                  _Section(Icons.wb_sunny_outlined, t.cropClimate, crop.climate),
                  _Section(Icons.water_drop_outlined, t.cropIrrigation, crop.irrigation),
                  _Section(Icons.science_outlined, t.cropNutrients, crop.nutrients),
                  _Section(Icons.bug_report_outlined, t.cropPests, crop.pests.join(', ')),
                  _Section(Icons.coronavirus_outlined, t.cropDiseases, crop.diseases.join(', ')),
                  _Section(Icons.agriculture_outlined, t.cropHarvest, crop.harvest),
                  _Section(Icons.warehouse_outlined, t.cropStorage, crop.storage),
                  const SizedBox(height: 8),
                  Text(
                    t.cropGeneralNote,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    if (body.trim().isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: const TextStyle(fontSize: 15, height: 1.45)),
          ],
        ),
      ),
    );
  }
}
