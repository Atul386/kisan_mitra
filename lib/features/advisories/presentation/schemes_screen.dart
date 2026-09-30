import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/advisory_content.dart';
import '../domain/advisory_models.dart';
import 'advisory_widgets.dart';

/// Schemes whose name or text contains every word the farmer typed
/// (case-insensitive). An empty search returns all of them.
List<Scheme> searchSchemes(List<Scheme> schemes, String query) {
  final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return schemes;
  return schemes.where((s) {
    final haystack = [s.name, s.overview, ...s.eligibility, ...s.benefits, ...s.documents].join(' ').toLowerCase();
    return words.every(haystack.contains);
  }).toList();
}

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final results = searchSchemes(kSchemes, _query);

    return Scaffold(
      appBar: AppBar(title: Text(t.schemesScreenTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(hintText: t.schemesSearchHint, prefixIcon: const Icon(Icons.search_rounded)),
            ),
            const SizedBox(height: 12),
            const OfficialDisclaimer(),
            const SizedBox(height: 12),
            if (results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  t.schemesNoMatch,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
              ),
            for (final s in results)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(s.overview, maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                  onTap: () => context.push('/schemes/${s.id}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
