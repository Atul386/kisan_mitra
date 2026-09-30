import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';
import '../../crop/crop_providers.dart';
import '../../crop/domain/season.dart';
import '../../crop/presentation/crop_detail_screen.dart' show cropStatusColor, cropStatusLabel;
import '../../dashboard/dashboard_providers.dart';
import '../domain/farm.dart';
import '../farm_providers.dart';

/// Farm hub: pick the active farm, see its details and crops, and jump to
/// the tools that work on it (diary, expenses, profit, documents, ...).
class FarmTab extends ConsumerWidget {
  const FarmTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final farms = user == null ? const <Farm>[] : ref.watch(userFarmsProvider(user.id)).valueOrNull ?? const <Farm>[];
    final farm = ref.watch(primaryFarmProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.myFarm),
        actions: [
          IconButton(
            tooltip: t.addFarm,
            onPressed: () => context.push('/add-farm'),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: farm == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.noFarmsYet, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.push('/add-farm'),
                        icon: const Icon(Icons.add),
                        label: Text(t.addFarm),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (farms.length > 1) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final f in farms)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(f.name),
                                selected: f.id == farm.id,
                                onSelected: (_) => ref.read(selectedFarmIdProvider.notifier).select(f.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _FarmDetailsCard(farm: farm, showActiveBadge: farms.length > 1),
                  const SizedBox(height: 20),
                  _CropsSection(farm: farm),
                  const SizedBox(height: 20),
                  _ToolsGrid(farm: farm),
                ],
              ),
      ),
    );
  }
}

class _FarmDetailsCard extends ConsumerWidget {
  const _FarmDetailsCard({required this.farm, required this.showActiveBadge});

  final Farm farm;
  final bool showActiveBadge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final place = [farm.village, farm.taluka, farm.district, farm.state].whereType<String>().where((s) => s.isNotEmpty).join(', ');

    Widget line(IconData icon, String? value) => value == null || value.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(child: Text(value)),
              ],
            ),
          );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.soilLight,
              child: Icon(Icons.agriculture_outlined, color: AppColors.soil),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(farm.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  Text(
                    t.farmAreaLine(farm.area.toString(), farm.areaUnit.name),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  line(Icons.place_outlined, place),
                  line(Icons.terrain_outlined, farm.soilType),
                  line(Icons.water_drop_outlined, [farm.irrigationType, farm.waterSource].whereType<String>().join(' · ')),
                  if (showActiveBadge)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                        label: Text(t.activeFarmBadge),
                      ),
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'edit') {
                  context.push('/farm/${farm.id}/edit');
                } else if (v == 'delete') {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text(t.deleteFarmConfirm),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.deleteButton)),
                      ],
                    ),
                  );
                  if (ok == true) await ref.read(farmRepositoryProvider).deleteFarm(farm.id);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(t.editDetails)),
                PopupMenuItem(value: 'delete', child: Text(t.deleteFarm, style: const TextStyle(color: AppColors.error))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CropsSection extends ConsumerWidget {
  const _CropsSection({required this.farm});

  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final seasons = ref.watch(farmSeasonsProvider(farm.id)).valueOrNull ?? const <Season>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(t.farmCropsTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
            TextButton.icon(
              onPressed: () => context.push('/farm/${farm.id}/add-crop'),
              icon: const Icon(Icons.add, size: 18),
              label: Text(t.addCropTitle),
            ),
          ],
        ),
        if (seasons.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(t.noCropsYet, style: const TextStyle(color: AppColors.textSecondary)),
          )
        else
          for (final s in seasons)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                minTileHeight: 64,
                title: Text(
                  s.variety == null ? s.cropName : '${s.cropName} · ${s.variety}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(s.isActive ? t.dayNumber(s.dayNumber) : cropStatusLabel(t, s.status)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: cropStatusColor(s.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cropStatusLabel(t, s.status),
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: cropStatusColor(s.status)),
                  ),
                ),
                onTap: () => context.push('/crop/${s.id}'),
              ),
            ),
      ],
    );
  }
}

class _ToolsGrid extends ConsumerWidget {
  const _ToolsGrid({required this.farm});

  final Farm farm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final active = ref.watch(primaryActiveSeasonProvider).valueOrNull;

    final tools = [
      (Icons.menu_book_rounded, t.toolDiary, active == null ? '/farm/${farm.id}/add-crop' : '/crop/${active.id}/diary'),
      (Icons.currency_rupee_rounded, t.toolExpenses, '/expenses'),
      (Icons.calculate_rounded, t.toolProfit, '/profit'),
      (Icons.folder_copy_rounded, t.toolDocuments, '/documents'),
      (Icons.science_rounded, t.toolSoil, '/soil'),
      (Icons.alarm_rounded, t.toolReminders, '/reminders'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.farmToolsTitle, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.05,
          children: [
            for (final (icon, label, route) in tools)
              Card(
                margin: EdgeInsets.zero,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push(route),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 28, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
