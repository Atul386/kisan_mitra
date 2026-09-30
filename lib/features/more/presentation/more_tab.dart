import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = [
      (Icons.alarm_rounded, t.toolReminders, '/reminders'),
      (Icons.folder_copy_rounded, t.toolDocuments, '/documents'),
      (Icons.science_rounded, t.toolSoil, '/soil'),
      (Icons.menu_book_rounded, t.moreCropLibrary, '/crop-library'),
      (Icons.calculate_rounded, t.moreProfit, '/profit'),
      (Icons.currency_rupee_rounded, t.moreExpenses, '/expenses'),
      (Icons.place_rounded, t.moreNearby, '/nearby'),
      (Icons.settings_rounded, t.moreSettings, '/settings'),
      (Icons.support_agent_rounded, t.moreHelp, '/help'),
      (Icons.info_outline_rounded, t.moreAbout, '/about'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.moreTitle)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final (icon, label, route) = items[i];
            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                minTileHeight: 64,
                leading: Icon(icon, color: AppColors.primary, size: 26),
                title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(route),
              ),
            );
          },
        ),
      ),
    );
  }
}
