import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../fertilizer_providers.dart';

class FertilizerScreen extends ConsumerWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final logs = ref.watch(seasonFertilizerLogsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(t.fertilizerTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-fertilizer'),
        icon: const Icon(Icons.add),
        label: Text(t.logFertilizer),
      ),
      body: SafeArea(
        child: logs.isEmpty
            ? Center(
                child: Text(t.noFertilizerMessage, style: const TextStyle(color: AppColors.textSecondary)),
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
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(Icons.eco_outlined, color: AppColors.primary),
                      ),
                      title: Text(log.product),
                      subtitle: Text([
                        '${log.date.day}/${log.date.month}/${log.date.year}',
                        if (log.quantity != null) '${log.quantity} ${log.unit ?? ''}'.trim(),
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
