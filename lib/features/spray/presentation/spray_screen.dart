import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../spray_providers.dart';

class SprayScreen extends ConsumerWidget {
  const SprayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final logs = ref.watch(seasonSprayLogsProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(t.sprayTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-spray'),
        icon: const Icon(Icons.add),
        label: Text(t.logSpray),
      ),
      body: SafeArea(
        child: logs.isEmpty
            ? Center(
                child: Text(t.noSprayMessage, style: const TextStyle(color: AppColors.textSecondary)),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, i) {
                  final log = logs[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.warningLight,
                        child: Icon(Icons.bug_report_outlined, color: AppColors.warning),
                      ),
                      title: Text(log.product),
                      subtitle: Text([
                        '${log.date.day}/${log.date.month}/${log.date.year}',
                        if (log.reason != null) log.reason!,
                        if (log.cost != null) '₹${log.cost!.toStringAsFixed(0)}',
                      ].join(' • ')),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
