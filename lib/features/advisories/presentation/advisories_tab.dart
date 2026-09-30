import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class AdvisoriesTab extends StatelessWidget {
  const AdvisoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = [
      (Icons.wb_sunny_rounded, t.advWeather, t.advWeatherDesc, '/weather', AppColors.weather, AppColors.weatherLight),
      (Icons.menu_book_rounded, t.advCropAdvisories, t.advCropAdvisoriesDesc, '/crop-library', AppColors.primary, AppColors.primaryLight),
      (Icons.account_balance_rounded, t.advSchemes, t.advSchemesDesc, '/schemes', AppColors.warning, AppColors.warningLight),
      (Icons.shield_rounded, t.advInsurance, t.advInsuranceDesc, '/insurance', AppColors.info, const Color(0xFFECEFF1)),
      (Icons.payments_rounded, t.advPmKisan, t.advPmKisanDesc, '/pm-kisan', AppColors.soil, AppColors.soilLight),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.advisoriesTitle)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final (icon, title, desc, route, color, bg) = items[i];
            return Card(
              margin: EdgeInsets.zero,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push(route),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
                        child: Icon(icon, color: color, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                            const SizedBox(height: 2),
                            Text(desc, style: const TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
