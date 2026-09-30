import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/locale_controller.dart';
import '../core/notifications/notification_providers.dart';
import '../core/sync/sync_providers.dart';
import '../core/utils/today_provider.dart';
import '../features/auth/auth_providers.dart';
import '../features/mandi/mandi_watchlist.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class KisanMitraApp extends ConsumerStatefulWidget {
  const KisanMitraApp({super.key});

  @override
  ConsumerState<KisanMitraApp> createState() => _KisanMitraAppState();
}

class _KisanMitraAppState extends ConsumerState<KisanMitraApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Reopened from the 8 AM reminder after a night in memory: move tasks
    // and check-in on to the new day.
    _lifecycle = AppLifecycleListener(onResume: () => ref.read(todayProvider.notifier).refresh());
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeControllerProvider).valueOrNull;
    ref.watch(syncOnConnectivityProvider);
    ref.watch(cloudSyncStartupProvider);
    ref.watch(pushRegistrationProvider);
    ref.watch(mandiPriceAlertCheckerProvider);
    ref.watch(upgradeOfflineGuestProvider);
    ref.watch(autoGuestProvider);

    return MaterialApp.router(
      title: 'KisanMitra 360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Light only for v1.0: many screens still hard-code light colours, so
      // the dark theme renders white text on white cards. Restore
      // ThemeMode.system (and the Settings switch) once they use theme colours.
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
