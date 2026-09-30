import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/nearby_category.dart';
import '../nearby_actions.dart';

class NearbyServicesScreen extends ConsumerWidget {
  const NearbyServicesScreen({super.key});

  String _label(AppLocalizations t, NearbyCategory c) => switch (c) {
        NearbyCategory.apmc => t.nearbyApmc,
        NearbyCategory.soilLab => t.nearbySoilLab,
        NearbyCategory.agriOffice => t.nearbyAgriOffice,
        NearbyCategory.seedDealer => t.nearbySeedDealer,
        NearbyCategory.fertilizerDealer => t.nearbyFertilizerDealer,
        NearbyCategory.equipmentRental => t.nearbyEquipmentRental,
        NearbyCategory.tractorRental => t.nearbyTractorRental,
        NearbyCategory.vet => t.nearbyVet,
        NearbyCategory.csc => t.nearbyCsc,
        NearbyCategory.bank => t.nearbyBank,
        NearbyCategory.govOffice => t.nearbyGovOffice,
      };

  IconData _icon(NearbyCategory c) => switch (c) {
        NearbyCategory.apmc => Icons.storefront_rounded,
        NearbyCategory.soilLab => Icons.science_rounded,
        NearbyCategory.agriOffice => Icons.apartment_rounded,
        NearbyCategory.seedDealer => Icons.grass_rounded,
        NearbyCategory.fertilizerDealer => Icons.inventory_2_rounded,
        NearbyCategory.equipmentRental => Icons.construction_rounded,
        NearbyCategory.tractorRental => Icons.agriculture_rounded,
        NearbyCategory.vet => Icons.pets_rounded,
        NearbyCategory.csc => Icons.computer_rounded,
        NearbyCategory.bank => Icons.account_balance_rounded,
        NearbyCategory.govOffice => Icons.account_balance_wallet_rounded,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final farm = ref.watch(primaryFarmProvider);
    final hasPoint = farm?.hasLocation ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(t.nearbyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(t.nearbyIntro, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(
              hasPoint ? t.nearbyNearFarm : t.nearbyNearArea,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
              children: [
                for (final c in NearbyCategory.values)
                  Card(
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => openNearby(context, ref, c),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_icon(c), size: 30, color: AppColors.primary),
                            const SizedBox(height: 8),
                            Text(
                              _label(t, c),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
