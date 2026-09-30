import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/link_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/advisory_models.dart';

/// Shown at the foot of every scheme/insurance page.
class OfficialDisclaimer extends StatelessWidget {
  const OfficialDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(t.officialDisclaimer, style: const TextStyle(fontSize: 12, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

Future<void> openWebsite(BuildContext context, WidgetRef ref, String url) async {
  final t = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.of(context);
  final ok = await ref.read(linkLauncherProvider).openWebsite(url);
  if (!ok) messenger.showSnackBar(SnackBar(content: Text(t.couldNotOpenLink)));
}

/// A titled list of official links / helplines.
class OfficialServiceList extends ConsumerWidget {
  const OfficialServiceList({required this.services, super.key});

  final List<OfficialService> services;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        for (final s in services)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final launcher = ref.read(linkLauncherProvider);
                final ok = s.phone != null
                    ? await launcher.dial(s.phone!)
                    : s.url != null
                        ? await launcher.openWebsite(s.url!)
                        : true;
                if (!ok) messenger.showSnackBar(SnackBar(content: Text(t.couldNotOpenLink)));
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: Icon(
                        s.phone != null ? Icons.call_rounded : Icons.open_in_new_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            s.phone != null ? '${s.description}\n${t.callHelpline} ${s.phone}' : s.description,
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
