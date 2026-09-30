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
import '../features/advisories/presentation/advisories_tab.dart';
import '../features/soil/presentation/add_soil_report_screen.dart';
import '../features/soil/presentation/soil_screen.dart';
import '../features/documents/domain/farm_document.dart';
import '../features/documents/presentation/add_document_screen.dart';
import '../features/documents/presentation/documents_screen.dart';
import '../features/reminders/presentation/add_reminder_screen.dart';
import '../features/reminders/presentation/reminders_screen.dart';
import '../features/crop/presentation/crop_detail_screen.dart' as crop_detail;
import '../features/diary/presentation/add_activity_screen.dart';
import '../features/diary/presentation/crop_diary_screen.dart';
import '../features/advisories/presentation/official_services_screen.dart';
import '../features/advisories/presentation/scheme_detail_screen.dart';
import '../features/advisories/presentation/schemes_screen.dart';
import '../features/crop_library/presentation/crop_detail_screen.dart';
import '../features/crop_library/presentation/crop_library_screen.dart';
import '../features/more/presentation/more_tab.dart';
import '../features/nearby/presentation/nearby_services_screen.dart';
import '../features/profit/presentation/profit_calculator_screen.dart';
import '../features/irrigation/presentation/add_irrigation_screen.dart';
import '../features/irrigation/presentation/irrigation_screen.dart';
import '../features/mandi/presentation/add_mandi_price_screen.dart';
import '../features/mandi/presentation/live_mandi_screen.dart';
import '../features/mandi/presentation/mandi_history_screen.dart';
import '../features/mandi/presentation/nearby_mandis_screen.dart';
import '../features/mandi/presentation/mandi_tab.dart';
import '../features/onboarding/presentation/language_selection_screen.dart';
import '../features/onboarding/presentation/splash_screen.dart';
import '../features/profile/presentation/profile_setup_screen.dart';
import '../features/settings/presentation/about_screen.dart';
import '../features/settings/presentation/help_screen.dart';
import '../features/settings/presentation/privacy_screen.dart';
import '../features/settings/presentation/settings_tab.dart';
import '../features/spray/presentation/add_spray_screen.dart';
import '../features/spray/presentation/spray_screen.dart';
import '../features/tasks/presentation/tasks_screen.dart';
import '../features/weather/presentation/weather_screen.dart';
import '../core/config/feature_flags.dart';
import '../core/localization/locale_controller.dart';

/// Notifies go_router to re-run [redirect] whenever onboarding-relevant
/// state changes, so the farmer is always moved to the right step of the
/// flow in §4 without manual navigation calls scattered across screens.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(localeControllerProvider, (_, __) => notifyListeners());
    ref.listen(currentUserProvider, (_, __) => notifyListeners());
    ref.listen(primaryFarmProvider, (_, __) => notifyListeners());
    ref.listen(primaryFarmLoadingProvider, (_, __) => notifyListeners());
    ref.listen(primaryActiveSeasonProvider, (_, __) => notifyListeners());
  }
}

const _onboardingEntryRoutes = {'/', '/language', '/login', '/profile-setup'};

/// First-run Add Farm / Add Crop live under their own paths so, once
/// onboarding is complete, the redirect can move the farmer on to the
/// dashboard without touching the in-app `/add-farm` and
/// `/farm/:id/add-crop` screens used later from the Farm tab.
const _onboardingAddFarm = '/onboarding/add-farm';
String _onboardingAddCrop(String farmId) => '/onboarding/farm/$farmId/add-crop';

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
      if (localeAsync.valueOrNull == null) {
        return location == '/language' ? null : '/language';
      }

      final userAsync = ref.read(currentUserProvider);
      if (userAsync.isLoading) return null;
      final user = userAsync.valueOrNull;
      if (user == null) {
        // Login off (v1.0): autoGuestProvider is creating the guest account;
        // wait on the splash screen until it exists.
        if (!kPhoneLoginEnabled) return location == '/' ? null : '/';
        final onLoginFlow = location == '/login' || location.startsWith('/otp/');
        return onLoginFlow ? null : '/login';
      }

      if (user.name.trim().isEmpty) {
        return location == '/profile-setup' ? null : '/profile-setup';
      }

      // Wait for the farm list instead of treating "still loading" as "no
      // farm", which sent returning farmers to Add Farm on a cold start.
      if (ref.read(primaryFarmLoadingProvider)) return null;
      final farm = ref.read(primaryFarmProvider);
      if (farm == null) {
        return location == _onboardingAddFarm ? null : _onboardingAddFarm;
      }

      final seasonAsync = ref.read(primaryActiveSeasonProvider);
      if (seasonAsync.isLoading) return null;
      if (seasonAsync.valueOrNull == null) {
        final addCropRoute = _onboardingAddCrop(farm.id);
        return location == addCropRoute ? null : addCropRoute;
      }

      if (_onboardingEntryRoutes.contains(location) || location.startsWith('/onboarding/')) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/language', builder: (c, s) => const LanguageSelectionScreen()),
      if (kPhoneLoginEnabled) ...[
        GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
        GoRoute(
          path: '/otp/:phone',
          builder: (c, s) => OtpScreen(phone: s.pathParameters['phone']!),
        ),
      ],
      GoRoute(path: '/profile-setup', builder: (c, s) => const ProfileSetupScreen()),
      GoRoute(path: _onboardingAddFarm, builder: (c, s) => const AddFarmScreen()),
      GoRoute(
        path: '/onboarding/farm/:farmId/add-crop',
        builder: (c, s) => AddCropScreen(farmId: s.pathParameters['farmId']!),
      ),
      GoRoute(path: '/add-farm', builder: (c, s) => const AddFarmScreen()),
      GoRoute(
        path: '/farm/:farmId/edit',
        builder: (c, s) => AddFarmScreen(farmId: s.pathParameters['farmId']),
      ),
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
      GoRoute(path: '/mandi/nearby', builder: (c, s) => const NearbyMandisScreen()),
      GoRoute(path: '/mandi/live', builder: (c, s) => const LiveMandiScreen()),
      GoRoute(
        path: '/mandi/history',
        builder: (c, s) => MandiHistoryScreen(
          commodity: s.uri.queryParameters['commodity'] ?? '',
          market: s.uri.queryParameters['market'],
        ),
      ),
      GoRoute(path: '/add-mandi-price', builder: (c, s) => const AddMandiPriceScreen()),
      GoRoute(path: '/checkin', builder: (c, s) => const DailyCheckinScreen()),
      GoRoute(path: '/about', builder: (c, s) => const AboutScreen()),
      GoRoute(path: '/privacy', builder: (c, s) => const PrivacyScreen()),
      GoRoute(path: '/help', builder: (c, s) => const HelpScreen()),
      GoRoute(
        path: '/crop/:seasonId',
        builder: (c, s) => crop_detail.CropDetailScreen(seasonId: s.pathParameters['seasonId']!),
      ),
      GoRoute(
        path: '/crop/:seasonId/diary',
        builder: (c, s) => CropDiaryScreen(seasonId: s.pathParameters['seasonId']!),
      ),
      GoRoute(
        path: '/crop/:seasonId/diary/add',
        builder: (c, s) => AddActivityScreen(seasonId: s.pathParameters['seasonId']!),
      ),
      GoRoute(
        path: '/crop/:seasonId/diary/:activityId/edit',
        builder: (c, s) => AddActivityScreen(
          seasonId: s.pathParameters['seasonId']!,
          activityId: s.pathParameters['activityId'],
        ),
      ),
      GoRoute(path: '/reminders', builder: (c, s) => const RemindersScreen()),
      GoRoute(path: '/reminders/add', builder: (c, s) => const AddReminderScreen()),
      GoRoute(
        path: '/reminders/:reminderId/edit',
        builder: (c, s) => AddReminderScreen(reminderId: s.pathParameters['reminderId']),
      ),
      GoRoute(path: '/documents', builder: (c, s) => const DocumentsScreen()),
      GoRoute(
        path: '/documents/add',
        builder: (c, s) => AddDocumentScreen(
          initialCategory: s.uri.queryParameters['category'] == null
              ? null
              : DocumentCategory.fromName(s.uri.queryParameters['category']!),
        ),
      ),
      GoRoute(path: '/soil', builder: (c, s) => const SoilScreen()),
      GoRoute(path: '/soil/add', builder: (c, s) => const AddSoilReportScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsTab()),
      GoRoute(path: '/crop-library', builder: (c, s) => const CropLibraryScreen()),
      GoRoute(
        path: '/crop-library/:cropId',
        builder: (c, s) => CropDetailScreen(cropId: s.pathParameters['cropId']!),
      ),
      GoRoute(path: '/schemes', builder: (c, s) => const SchemesScreen()),
      GoRoute(
        path: '/schemes/:schemeId',
        builder: (c, s) => SchemeDetailScreen(schemeId: s.pathParameters['schemeId']!),
      ),
      GoRoute(path: '/pm-kisan', builder: (c, s) => const PmKisanScreen()),
      GoRoute(path: '/insurance', builder: (c, s) => const InsuranceScreen()),
      GoRoute(path: '/profit', builder: (c, s) => const ProfitCalculatorScreen()),
      GoRoute(path: '/nearby', builder: (c, s) => const NearbyServicesScreen()),
      if (kAiAssistantEnabled) GoRoute(path: '/dashboard/assistant', builder: (c, s) => const AiAssistantTab()),
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
            GoRoute(path: '/dashboard/advisories', builder: (c, s) => const AdvisoriesTab()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/dashboard/more', builder: (c, s) => const MoreTab()),
          ]),
        ],
      ),
    ],
  );
});
