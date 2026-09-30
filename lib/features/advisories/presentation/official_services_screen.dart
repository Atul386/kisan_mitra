import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/advisory_content.dart';
import '../domain/advisory_models.dart';
import 'advisory_widgets.dart';

class _ServicesPage extends StatelessWidget {
  const _ServicesPage({required this.title, required this.note, required this.services});

  final String title;
  final String note;
  final List<OfficialService> services;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(note, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
            const SizedBox(height: 12),
            Text(t.officialServicesTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            OfficialServiceList(services: services),
            const SizedBox(height: 4),
            const OfficialDisclaimer(),
          ],
        ),
      ),
    );
  }
}

class PmKisanScreen extends StatelessWidget {
  const PmKisanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _ServicesPage(title: t.pmKisanScreenTitle, note: t.pmKisanAadhaarNote, services: kPmKisanServices);
  }
}

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return _ServicesPage(title: t.insuranceScreenTitle, note: t.insuranceReportNote, services: kInsuranceServices);
  }
}
