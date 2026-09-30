import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/expense.dart';
import '../expense_providers.dart';

enum _TimeRange { month, season }

class _CategoryVisual {
  const _CategoryVisual(this.icon, this.color, this.backgroundColor);
  final IconData icon;
  final Color color;
  final Color backgroundColor;
}

const _categoryVisuals = <ExpenseCategory, _CategoryVisual>{
  ExpenseCategory.seeds: _CategoryVisual(Icons.eco_rounded, AppColors.warning, AppColors.warningLight),
  ExpenseCategory.fertilizer: _CategoryVisual(Icons.science_outlined, AppColors.weather, AppColors.weatherLight),
  ExpenseCategory.pesticide: _CategoryVisual(Icons.bug_report_outlined, AppColors.error, AppColors.errorLight),
  ExpenseCategory.labour: _CategoryVisual(Icons.groups_outlined, AppColors.soil, AppColors.soilLight),
  ExpenseCategory.tractor: _CategoryVisual(Icons.agriculture_rounded, AppColors.weather, AppColors.weatherLight),
  ExpenseCategory.diesel: _CategoryVisual(Icons.local_gas_station_outlined, AppColors.error, AppColors.errorLight),
  ExpenseCategory.irrigation: _CategoryVisual(Icons.water_drop_outlined, AppColors.weather, AppColors.weatherLight),
  ExpenseCategory.electricity: _CategoryVisual(Icons.bolt_rounded, AppColors.warning, AppColors.warningLight),
  ExpenseCategory.transport: _CategoryVisual(Icons.local_shipping_outlined, AppColors.warning, AppColors.warningLight),
  ExpenseCategory.equipment: _CategoryVisual(Icons.build_outlined, AppColors.soil, AppColors.soilLight),
  ExpenseCategory.other: _CategoryVisual(Icons.more_horiz_rounded, AppColors.info, AppColors.border),
};

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  _TimeRange _range = _TimeRange.season;

  String _categoryLabel(AppLocalizations t, ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.seeds:
        return t.expenseCategorySeeds;
      case ExpenseCategory.fertilizer:
        return t.expenseCategoryFertilizer;
      case ExpenseCategory.pesticide:
        return t.expenseCategoryPesticide;
      case ExpenseCategory.labour:
        return t.expenseCategoryLabour;
      case ExpenseCategory.tractor:
        return t.expenseCategoryTractor;
      case ExpenseCategory.diesel:
        return t.expenseCategoryDiesel;
      case ExpenseCategory.irrigation:
        return t.expenseCategoryIrrigation;
      case ExpenseCategory.electricity:
        return t.expenseCategoryElectricity;
      case ExpenseCategory.transport:
        return t.expenseCategoryTransport;
      case ExpenseCategory.equipment:
        return t.expenseCategoryEquipment;
      case ExpenseCategory.other:
        return t.expenseCategoryOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final allExpenses = ref.watch(seasonExpensesProvider).valueOrNull ?? const [];
    final now = DateTime.now();
    final expenses = _range == _TimeRange.season
        ? allExpenses
        : allExpenses.where((e) => e.date.year == now.year && e.date.month == now.month).toList();

    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final byCategory = <ExpenseCategory, double>{};
    for (final e in expenses) {
      byCategory.update(e.category, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    final categoryEntries = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(t.expenses),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.totalCropExpenseLabel, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    '₹${total.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.soil),
                  ),
                  Text(
                    _range == _TimeRange.season ? '(${t.thisSeasonLabel})' : '(${t.thisMonthLabel})',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _RangeToggle(
                    label: t.thisMonthLabel,
                    selected: _range == _TimeRange.month,
                    onTap: () => setState(() => _range = _TimeRange.month),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _RangeToggle(
                    label: t.thisSeasonLabel,
                    selected: _range == _TimeRange.season,
                    onTap: () => setState(() => _range = _TimeRange.season),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (categoryEntries.isNotEmpty)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.7,
                children: [
                  for (final entry in categoryEntries)
                    _CategoryCard(
                      visual: _categoryVisuals[entry.key]!,
                      label: _categoryLabel(t, entry.key),
                      amount: entry.value,
                    ),
                ],
              ),
            const SizedBox(height: 20),
            Text(t.recentExpensesLabel, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 12),
            if (expenses.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(t.noExpensesMessage, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                ),
              )
            else
              for (final e in expenses.take(20))
                _ExpenseRow(
                  visual: _categoryVisuals[e.category]!,
                  label: _categoryLabel(t, e.category),
                  amount: e.amount,
                  dateLabel: '${e.date.day}/${e.date.month}/${e.date.year}${e.notes != null ? ' • ${e.notes}' : ''}',
                ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.push('/add-expense'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.add),
            label: Text(t.addExpense, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

class _RangeToggle extends StatelessWidget {
  const _RangeToggle({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: selected ? Colors.transparent : AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.visual, required this.label, required this.amount});

  final _CategoryVisual visual;
  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: visual.backgroundColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(visual.icon, color: visual.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
                Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.visual, required this.label, required this.amount, required this.dateLabel});

  final _CategoryVisual visual;
  final String label;
  final double amount;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: visual.backgroundColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(visual.icon, color: visual.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(dateLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
