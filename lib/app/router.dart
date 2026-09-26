import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ai_assistant/presentation/ai_assistant_tab.dart';
import '../features/auth/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/crop/presentation/add_crop_screen.dart';
import '../features/crop_health/presentation/daily_checkin_screen.dart';
import '../features/dashboard/dashboard_providers.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';
import '../features/dashboard/presentation/home_tab.dart';
import '../features/expenses/presentation/add_expense_screen.dart';
import '../features/expenses/presentation/expenses_screen.dart';
import '../features/farm/presentation/add_farm_screen.dart';
import '../features/farm/presentation/farm_tab.dart';
import '../features/fertilizer/presentation/add_fertilizer_screen.dart';
import '../features/fertilizer/presentation/fertilizer_screen.dart';
import '../features/irrigation/presentation/add_irrigation_screen.dart';
import '../features/irrigation/presentation/irrigation_screen.dart';
import '../features/mandi/presentation/add_mandi_price_screen.dart';
import '../features/mandi/presentation/mandi_tab.dart';
import '../features/onboarding/presentation/language_selection_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/profile/presentation/profile_setup_screen.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/settings/presentation/privacy_screen.dart';
import '../features/settings/presentation/settings_tab.dart';
import '../features/spray/presentation/add_spray_screen.dart';
import '../features/spray/presentation/spray_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/weather/presentation/weather_screen.dart';
import '../core/localization/locale_controller.dart';

/// Notifies go_router to re-run [redirect] whenever onboarding-relevant
/// state changes, so the farmer is always moved to the right step of the
/// flow in §4 without manual navigation calls scattered across screens.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(localeControllerProvider, (_, __) => notifyListeners());
    ref.listen(currentUserProvider, (_, __) => notifyListeners());
    ref.listen(primaryFarmProvider, (_, __) => notifyListeners());
    ref.listen(primaryActiveSeasonProvider, (_, __) => notifyListeners());
  }
}

const _onboardingEntryRoutes = {'/', '/language', '/login', '/profile-setup'};

/// TEMPORARY dev convenience: skip the whole language/login/profile/farm
/// onboarding flow and land straight on the dashboard, so the UI can be
/// checked without re-doing onboarding on every install while Firebase
/// Anonymous/Phone sign-in are still disabled in the console. Flip back
/// to `false` once those are enabled to restore the real flow — nothing
/// else needs to change.
const kSkipOnboardingForDev = false;

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: kSkipOnboardingForDev ? '/dashboard' : '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      if (kSkipOnboardingForDev) return null;
      final location = state.matchedLocation;

      final localeAsync = ref.read(localeControllerProvider);
      if (localeAsync.isLoading) return null;
      if (localeAsync.value == null) {
        return location == '/language' ? null : '/language';
      }

      final userAsync = ref.read(currentUserProvider);
      if (userAsync.isLoading) return null;
      final user = userAsync.value;
      if (user == null) {
        final onLoginFlow = location == '/login' || location.startsWith('/otp/');
        return onLoginFlow ? null : '/login';
      }

      if (user.name.trim().isEmpty) {
        return location == '/profile-setup' ? null : '/profile-setup';
      }

      final farm = ref.read(primaryFarmProvider);
      if (farm == null) {
        return location == '/add-farm' ? null : '/add-farm';
      }

      final seasonAsync = ref.read(primaryActiveSeasonProvider);
      if (seasonAsync.isLoading) return null;
      if (seasonAsync.value == null) {
        final addCropRoute = '/farm/${farm.id}/add-crop';
        return location == addCropRoute ? null : addCropRoute;
      }

      if (_onboardingEntryRoutes.contains(location)) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/language', builder: (c, s) => const LanguageSelectionScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(
        path: '/otp/:phone',
        builder: (c, s) => OtpScreen(phone: s.pathParameters['phone']!),
      ),
      GoRoute(path: '/profile-setup', builder: (c, s) => const ProfileSetupScreen()),
      GoRoute(path: '/add-farm', builder: (c, s) => const AddFarmScreen()),
      GoRoute(
        path: '/farm/:farmId/add-crop',
        builder: (c, s) => AddCropScreen(farmId: s.pathParameters['farmId']!),
      ),
      GoRoute(path: '/tasks', builder: (c, s) => const TasksScreen()),
      GoRoute(path: '/weather', builder: (c, s) => const WeatherScreen()),
      GoRoute(path: '/irrigation', builder: (c, s) => const IrrigationScreen()),
      GoRoute(path: '/add-irrigation', builder: (c, s) => const AddIrrigationScreen()),
      GoRoute(path: '/fertilizer', builder: (c, s) => const FertilizerScreen()),
      GoRoute(path: '/add-fertilizer', builder: (c, s) => const AddFertilizerScreen()),
      GoRoute(path: '/spray', builder: (c, s) => const SprayScreen()),
      GoRoute(path: '/add-spray', builder: (c, s) => const AddSprayScreen()),
      GoRoute(path: '/expenses', builder: (c, s) => const ExpensesScreen()),
      GoRoute(path: '/add-expense', builder: (c, s) => const AddExpenseScreen()),
      GoRoute(path: '/add-mandi-price', builder: (c, s) => const AddMandiPriceScreen()),
      GoRoute(path: '/checkin', builder: (c, s) => const DailyCheckinScreen()),
      GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
      GoRoute(path: '/privacy', builder: (c, s) => const PrivacyScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            DashboardShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard', builder: (c, s) => const HomeTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/farm', builder: (c, s) => const FarmTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/market', builder: (c, s) => const MandiTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/assistant', builder: (c, s) => const AiAssistantTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/profile', builder: (c, s) => const SettingsTab()),
          ]),
        ],
      ),
    ],
  );
});
