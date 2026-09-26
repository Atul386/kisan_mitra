import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/presentation/offline_banner.dart';
import '../../../l10n/app_localizations.dart';

/// Bottom navigation shell per blueprint §12: Home, Farm, Market,
/// Assistant, Profile. Kept intentionally simple (§97).
class DashboardShell extends StatelessWidget {
  const DashboardShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: t.navHome),
          NavigationDestination(icon: const Icon(Icons.agriculture_outlined), selectedIcon: const Icon(Icons.agriculture), label: t.navFarm),
          NavigationDestination(icon: const Icon(Icons.storefront_outlined), selectedIcon: const Icon(Icons.storefront), label: t.navMarket),
          NavigationDestination(icon: const Icon(Icons.mic_none_outlined), selectedIcon: const Icon(Icons.mic), label: t.navAssistant),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: t.navProfile),
        ],
      ),
    );
  }
}
