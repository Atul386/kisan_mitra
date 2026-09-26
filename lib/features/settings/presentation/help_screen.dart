import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final faqs = [
      (t.helpFaqOfflineQ, t.helpFaqOfflineA),
      (t.helpFaqTasksQ, t.helpFaqTasksA),
      (t.helpFaqLanguageQ, t.helpFaqLanguageA),
      (t.helpFaqDataQ, t.helpFaqDataA),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(t.helpSupportTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(t.helpIntro, style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            for (final (question, answer) in faqs)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                  title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
                  shape: const Border(),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(answer)],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
