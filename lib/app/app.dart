import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/locale_controller.dart';
import '../core/sync/sync_providers.dart';
import '../core/theme/theme_controller.dart';
import '../features/mandi/mandi_watchlist.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme.dart';

class KisanMitraApp extends ConsumerWidget {
  const KisanMitraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeControllerProvider).value;
    ref.watch(syncOnConnectivityProvider);
    ref.watch(mandiPriceAlertCheckerProvider);

    return MaterialApp.router(
      title: 'KisanMitra 360',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ref.watch(themeControllerProvider),
      locale: locale,
      supportedLocales: kSupportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
    );
  }
}
