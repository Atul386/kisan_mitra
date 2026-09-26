import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  static const _options = [
    (locale: Locale('mr'), native: 'मराठी', caption: 'मराठी', badge: 'म', badgeColor: AppColors.warning),
    (locale: Locale('hi'), native: 'हिंदी', caption: 'हिंदी', badge: 'हिं', badgeColor: AppColors.primary),
    (locale: Locale('en'), native: 'English', caption: 'English', badge: 'A', badgeColor: AppColors.weather),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              t.chooseLanguage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'आपली भाषा निवडा',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const Text(
              'अपनी भाषा चुनें',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  for (final option in _options) ...[
                    _LanguageCard(
                      native: option.native,
                      caption: option.caption,
                      badge: option.badge,
                      badgeColor: option.badgeColor,
                      onTap: () {
                        ref.read(localeControllerProvider.notifier).setLocale(option.locale);
                        ref.read(analyticsServiceProvider).logEvent(
                          'language_selected',
                          parameters: {'language': option.locale.languageCode},
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Image.asset('assets/images/onboarding_landscape.png', fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.native,
    required this.caption,
    required this.badge,
    required this.badgeColor,
    required this.onTap,
  });

  final String native;
  final String caption;
  final String badge;
  final Color badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: badgeColor,
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      native,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Text(caption, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.primaryDark),
            ],
          ),
        ),
      ),
    );
  }
}
