import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

/// Placeholder content (blueprint §41, §60) — a real privacy policy needs
/// legal review before store submission; this describes current data
/// practices honestly in the meantime rather than shipping a generic
/// template.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.privacyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            _Section(
              title: 'What we store',
              body:
                  'Your farm, crop, task, expense, irrigation and price records are '
                  'saved on this device. None of it is sent anywhere yet — this app '
                  'does not have a connected server.',
            ),
            _Section(
              title: 'What we don\'t collect',
              body:
                  'No Aadhaar, bank details, or contacts. Location is only used if '
                  'you choose to add it to a farm, for weather.',
            ),
            _Section(title: 'Deleting your data', body: 'Uninstalling the app removes all locally saved data.'),
            _Section(
              title: 'Status',
              body:
                  'This is a development build. A reviewed privacy policy will '
                  'replace this page before the app is published.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
