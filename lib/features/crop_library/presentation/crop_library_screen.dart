import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../crop_library_providers.dart';

class CropLibraryScreen extends ConsumerWidget {
  const CropLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final crops = ref.watch(filteredCropsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(t.cropLibraryTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                onChanged: (v) => ref.read(cropSearchQueryProvider.notifier).state = v,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: t.cropLibrarySearchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: crops.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => _Message(
                  text: t.cropLibraryLoadError,
                  actionLabel: t.tryAgain,
                  onAction: () => ref.invalidate(cropLibraryProvider),
                ),
                data: (list) {
                  if (list.isEmpty) return _Message(text: t.cropLibraryEmpty);
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final crop = list[i];
                      return Card(
                        margin: EdgeInsets.zero,
                        child: ListTile(
                          minTileHeight: 64,
                          leading: Text(crop.icon, style: const TextStyle(fontSize: 30)),
                          title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
                          subtitle: Text(crop.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.push('/crop-library/${crop.id}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.actionLabel, this.onAction});
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.eco_outlined, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center),
            if (onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel ?? '')),
            ],
          ],
        ),
      ),
    );
  }
}
