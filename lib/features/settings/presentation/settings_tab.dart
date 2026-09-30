import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/config/feature_flags.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/notifications/push_service.dart';
import '../../../core/sync/sync_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../mandi/mandi_watchlist.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).valueOrNull;
    final pendingSyncCount = ref.watch(pendingSyncCountProvider).valueOrNull ?? 0;

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
            if (!kEnglishOnly)
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(t.languageSettingTitle),
                trailing: DropdownButton<Locale>(
                  value: ref.watch(localeControllerProvider).valueOrNull,
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
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(t.dailyReminderLabel),
              subtitle: Text(t.dailyReminderSubtitle),
              value: ref.watch(dailyReminderEnabledProvider),
              onChanged: (on) => ref.read(dailyReminderEnabledProvider.notifier).set(on),
            ),
            const _PushToggles(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text(t.helpSupportTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/help'),
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
            // Nothing syncs in the offline-only v1.0, so the status would
            // only ever say "not connected".
            if (kPhoneLoginEnabled) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cloud_sync_outlined),
                title: Text(t.syncStatusTitle),
                subtitle: Text('${t.syncPendingLabel(pendingSyncCount)}\n${t.syncNotConnectedMessage}'),
                isThreeLine: true,
              ),
            ],
            const Divider(),
            // No account to log out of with login off; Reset app data below
            // is the way to start fresh.
            if (kPhoneLoginEnabled)
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: Text(t.logout, style: const TextStyle(color: AppColors.error)),
                onTap: () => ref.read(authRepositoryProvider).signOut(),
              ),
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
              title: Text(
                kPhoneLoginEnabled ? t.deleteAccountTitle : t.resetAppDataTitle,
                style: const TextStyle(color: AppColors.error),
              ),
              onTap: () => _confirmDeleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmDeleteAccount(BuildContext context, WidgetRef ref) async {
  final t = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(kPhoneLoginEnabled ? t.deleteAccountTitle : t.resetAppDataTitle),
      content: Text(kPhoneLoginEnabled ? t.deleteAccountConfirmMessage : t.resetAppDataMessage),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(t.deleteButton),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  try {
    await ref.read(notificationServiceProvider).cancelAll();
    final photosDir = Directory(p.join((await getApplicationDocumentsDirectory()).path, 'crop_photos'));
    if (await photosDir.exists()) await photosDir.delete(recursive: true);
    await ref.read(mandiWatchlistProvider.notifier).clear();
    // Signs the farmer out too; the router then shows login, or (login off)
    // a fresh guest account is created and onboarding starts again.
    await ref.read(authRepositoryProvider).deleteAccount();
  } catch (e, st) {
    reportError(e, st, context: 'SettingsTab.deleteAccount');
    if (context.mounted) showGenericErrorSnackBar(context);
  }
}

/// Per-type push switches. Hidden for guests: the server can only send
/// notifications to a signed-in farmer.
class _PushToggles extends ConsumerStatefulWidget {
  const _PushToggles();

  @override
  ConsumerState<_PushToggles> createState() => _PushTogglesState();
}

class _PushTogglesState extends ConsumerState<_PushToggles> {
  @override
  Widget build(BuildContext context) {
    final service = ref.watch(pushServiceProvider);
    final signedIn = ref.watch(firebaseUidProvider).valueOrNull != null;
    if (service == null || !signedIn) return const SizedBox.shrink();
    final t = AppLocalizations.of(context)!;

    final labels = {
      PushTopic.weatherAlerts: t.pushWeather,
      PushTopic.mandiAlerts: t.pushMandi,
      PushTopic.governmentUpdates: t.pushGovt,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text(t.pushSectionTitle, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        for (final entry in labels.entries)
          SwitchListTile(
            title: Text(entry.value),
            value: service.isEnabled(entry.key),
            onChanged: (on) async {
              await service.setEnabled(entry.key, on);
              if (mounted) setState(() {});
            },
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(t.pushNote, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
