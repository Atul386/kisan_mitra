import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/live_mandi_repository.dart';

/// Friendly text for a failed mandi request — never the raw exception.
String mandiErrorText(AppLocalizations t, Object error) {
  if (error is MandiRateLimitedException) return t.mandiRateLimited;
  if (error is MandiUnsupportedStateException) return t.mandiUnsupportedState;
  return t.mandiLoadError;
}

class MandiMessage extends StatelessWidget {
  const MandiMessage({required this.text, this.actionLabel, this.onAction, super.key});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          const Icon(Icons.storefront_outlined, size: 44, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
          if (onAction != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel ?? '')),
          ],
        ],
      ),
    );
  }
}

/// Shown when the network failed and older saved prices are on screen.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({this.cachedAt, super.key});

  final DateTime? cachedAt;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, size: 20, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cachedAt == null
                  ? t.mandiOfflineBanner
                  : '${t.mandiOfflineBanner}\n${t.mandiSavedOn(DateFormat('d MMM, h:mm a').format(cachedAt!))}',
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// Minimum / modal / maximum side by side.
class PriceTriple extends StatelessWidget {
  const PriceTriple({required this.min, required this.modal, required this.max, super.key});

  final double min;
  final double modal;
  final double max;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    Widget cell(String label, double value, {bool strong = false}) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(
            '₹${NumberFormat.decimalPattern('en_IN').format(value.round())}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: strong ? 20 : 16,
              color: strong ? AppColors.primaryDark : null,
            ),
          ),
        ],
      ),
    );
    return Row(children: [cell(t.mandiMin, min), cell(t.mandiModal, modal, strong: true), cell(t.mandiMax, max)]);
  }
}
