import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';
import '../farm_providers.dart';

class FarmTab extends ConsumerWidget {
  const FarmTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).value;
    final farms = user == null ? const [] : ref.watch(userFarmsProvider(user.id)).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(t.myFarm)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-farm'),
        icon: const Icon(Icons.add),
        label: Text(t.addFarm),
      ),
      body: SafeArea(
        child: farms.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(t.addFarmTitle, style: const TextStyle(color: AppColors.textSecondary)),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final farm in farms)
                    Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.soilLight,
                          child: Icon(Icons.agriculture_outlined, color: AppColors.soil),
                        ),
                        title: Text(farm.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${farm.area} ${farm.areaUnit.name}'
                            '${farm.village != null ? ' • ${farm.village}' : ''}'),
                        trailing: TextButton(
                          onPressed: () => context.push('/farm/${farm.id}/add-crop'),
                          child: Text(t.addCropTitle),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _QuickActionChip(
                        icon: Icons.water_drop_outlined,
                        label: t.irrigationTitle,
                        onTap: () => context.push('/irrigation'),
                      ),
                      _QuickActionChip(
                        icon: Icons.eco_outlined,
                        label: t.fertilizerTitle,
                        onTap: () => context.push('/fertilizer'),
                      ),
                      _QuickActionChip(
                        icon: Icons.bug_report_outlined,
                        label: t.sprayTitle,
                        onTap: () => context.push('/spray'),
                      ),
                      _QuickActionChip(
                        icon: Icons.payments_outlined,
                        label: t.expenses,
                        onTap: () => context.push('/expenses'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
