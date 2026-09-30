import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/advisory_content.dart';
import '../domain/advisory_models.dart';
import 'advisory_widgets.dart';

class SchemeDetailScreen extends ConsumerWidget {
  const SchemeDetailScreen({required this.schemeId, super.key});

  final String schemeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = AppLocalizations.of(context)!;
    Scheme? scheme;
    for (final s in kSchemes) {
      if (s.id == schemeId) scheme = s;
    }
    if (scheme == null) {
      return Scaffold(appBar: AppBar(), body: Center(child: Text(t.schemesScreenTitle)));
    }
    final s = scheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.schemesScreenTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Text(s.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            _Block(t.schemeOverview, [s.overview]),
            _Block(t.schemeEligibility, s.eligibility),
            _Block(t.schemeBenefits, s.benefits),
            _Block(t.schemeDocuments, s.documents),
            _Block(t.schemeDates, [t.schemeDatesNote]),
            const SizedBox(height: 4),
            FilledButton.icon(
              onPressed: () => openWebsite(context, ref, s.officialUrl),
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(t.schemeApply),
            ),
            const SizedBox(height: 16),
            const OfficialDisclaimer(),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block(this.title, this.lines);
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.primaryDark)),
            const SizedBox(height: 8),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lines.length > 1) const Padding(padding: EdgeInsets.only(right: 8, top: 2), child: Text('•')),
                    Expanded(child: Text(line, style: const TextStyle(fontSize: 15, height: 1.4))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
