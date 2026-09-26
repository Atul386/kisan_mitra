import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/auth_providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();
  final _villageController = TextEditingController();
  Locale? _language;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    final language = _language ?? ref.read(localeControllerProvider).value ?? kSupportedLocales.first;
    setState(() => _saving = true);
    try {
      await ref.read(localeControllerProvider.notifier).setLocale(language);
      await ref.read(authRepositoryProvider).updateProfile(
            user.copyWith(
              name: _nameController.text.trim(),
              state: _stateController.text.trim(),
              district: _districtController.text.trim(),
              village: _villageController.text.trim(),
              language: language.languageCode,
            ),
          );
      // Router redirect moves to Add Farm once name is non-empty.
    } catch (e, st) {
      reportError(e, st, context: 'ProfileSetupScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              t.profileSetupHeading,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(t.profileSetupTitle, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: t.nameLabel)),
            const SizedBox(height: 16),
            TextField(controller: _stateController, decoration: InputDecoration(labelText: t.stateLabel)),
            const SizedBox(height: 16),
            TextField(
              controller: _districtController,
              decoration: InputDecoration(labelText: t.districtLabel),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _villageController,
              decoration: InputDecoration(labelText: t.villageLabel),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Locale>(
              initialValue: _language ?? ref.watch(localeControllerProvider).value,
              decoration: InputDecoration(labelText: t.preferredLanguageLabel),
              items: [
                DropdownMenuItem(value: const Locale('mr'), child: Text(t.languageMarathi)),
                DropdownMenuItem(value: const Locale('hi'), child: Text(t.languageHindi)),
                DropdownMenuItem(value: const Locale('en'), child: Text(t.languageEnglish)),
              ],
              onChanged: (l) => setState(() => _language = l),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(t.nextButton),
            ),
          ],
        ),
      ),
    );
  }
}
