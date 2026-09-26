import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/sync/sync_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).value;
    final pendingSyncCount = ref.watch(pendingSyncCountProvider).value ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(t.settingsTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text(user?.name.isNotEmpty == true ? user!.name : t.continueAsGuest),
              subtitle: user?.phone != null ? Text(user!.phone!) : null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: Text(t.languageSettingTitle),
              trailing: DropdownButton<Locale>(
                value: ref.watch(localeControllerProvider).value,
                items: kSupportedLocales
                    .map((l) => DropdownMenuItem(value: l, child: Text(l.languageCode.toUpperCase())))
                    .toList(),
                onChanged: (locale) {
                  if (locale != null) {
                    ref.read(localeControllerProvider.notifier).setLocale(locale);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.aboutTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/about'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(t.privacyTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/privacy'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cloud_sync_outlined),
              title: Text(t.syncStatusTitle),
              subtitle: Text('${t.syncPendingLabel(pendingSyncCount)}\n${t.syncNotConnectedMessage}'),
              isThreeLine: true,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: Text(t.logout, style: const TextStyle(color: AppColors.error)),
              onTap: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
