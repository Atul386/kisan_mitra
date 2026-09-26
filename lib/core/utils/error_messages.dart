import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// The one farmer-facing error message (blueprint §42) — never a raw
/// exception or stack trace. Call [reportError] separately for the
/// technical detail.
void showGenericErrorSnackBar(BuildContext context) {
  final t = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.genericErrorMessage)));
}
