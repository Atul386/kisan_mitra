import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../core/sync/sync_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
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
    final user = ref.watch(currentUserProvider).value;
    final pendingSyncCount = ref.watch(pendingSyncCountProvider).value ?? 0;
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);

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
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: Text(t.darkModeLabel),
              value: isDark,
              onChanged: (on) =>
                  ref.read(themeControllerProvider.notifier).setThemeMode(on ? ThemeMode.dark : ThemeMode.light),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(t.dailyReminderLabel),
              subtitle: Text(t.dailyReminderSubtitle),
              value: ref.watch(dailyReminderEnabledProvider),
              onChanged: (on) => ref.read(dailyReminderEnabledProvider.notifier).set(on),
            ),
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
            ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: AppColors.error),
              title: Text(t.deleteAccountTitle, style: const TextStyle(color: AppColors.error)),
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
      title: Text(t.deleteAccountTitle),
      content: Text(t.deleteAccountConfirmMessage),
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
    // Signs the farmer out too; the router redirect takes them to login.
    await ref.read(authRepositoryProvider).deleteAccount();
  } catch (e, st) {
    reportError(e, st, context: 'SettingsTab.deleteAccount');
    if (context.mounted) showGenericErrorSnackBar(context);
  }
}
