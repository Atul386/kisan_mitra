import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../connectivity_provider.dart';

/// "You're offline. Showing saved information." (blueprint §34) — shown
/// whenever connectivity drops, never a raw exception.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    if (isOnline) return const SizedBox.shrink();

    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      color: AppColors.warningLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 16, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(child: Text(t.offlineBanner, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
