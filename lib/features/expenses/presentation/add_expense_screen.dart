import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/analytics/analytics_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/error_reporter.dart';
import '../../../core/utils/ids.dart';
import '../../../core/utils/photo_storage.dart';
import '../../../l10n/app_localizations.dart';
import '../../dashboard/dashboard_providers.dart';
import '../domain/expense.dart';
import '../expense_providers.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.seeds;
  DateTime _date = DateTime.now();
  String? _receiptPhotoPath;
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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

  Future<void> _addReceiptPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70, maxWidth: 1280);
    if (picked == null) return;
    final path = await saveImageLocally(picked, category: 'receipt_photos');
    setState(() => _receiptPhotoPath = path);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final farm = ref.read(primaryFarmProvider);
    final amount = double.tryParse(_amountController.text.trim());
    if (farm == null || amount == null) return;

    setState(() => _saving = true);
    try {
      final season = ref.read(primaryActiveSeasonProvider).valueOrNull;
      await ref.read(expenseRepositoryProvider).addExpense(
            Expense(
              id: newId(),
              farmId: farm.id,
              seasonId: season?.id,
              amount: amount,
              category: _category,
              date: _date,
              notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
              receiptPhotoPath: _receiptPhotoPath,
            ),
          );
      ref.read(analyticsServiceProvider).logEvent('expense_added', parameters: {'category': _category.name});
      if (mounted) Navigator.of(context).pop();
    } catch (e, st) {
      reportError(e, st, context: 'AddExpenseScreen.save');
      if (mounted) showGenericErrorSnackBar(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.addExpense)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: t.amountLabel, prefixText: '₹ '),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              decoration: InputDecoration(labelText: t.categoryLabel),
              items: ExpenseCategory.values
                  .map((c) => DropdownMenuItem(value: c, child: Text(_categoryLabel(t, c))))
                  .toList(),
              onChanged: (c) => setState(() => _category = c ?? _category),
            ),
            const SizedBox(height: 16),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _pickDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: t.dateLabel,
                  suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
                ),
                child: Text('${_date.day}/${_date.month}/${_date.year}'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(labelText: t.notesLabel),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _addReceiptPhoto,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _receiptPhotoPath != null ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                        color: _receiptPhotoPath != null ? AppColors.primary : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(t.addReceiptPhoto, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: Text(t.save),
            ),
          ],
        ),
      ),
    );
  }
}
