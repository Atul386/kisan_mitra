/// Categories from blueprint §21.
enum ExpenseCategory {
  seeds,
  fertilizer,
  pesticide,
  labour,
  tractor,
  diesel,
  irrigation,
  electricity,
  transport,
  equipment,
  other,
}

class Expense {
  const Expense({
    required this.id,
    required this.farmId,
    required this.amount,
    required this.category,
    required this.date,
    this.seasonId,
    this.notes,
    this.receiptPhotoPath,
  });

  final String id;
  final String farmId;
  final String? seasonId;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes;
  final String? receiptPhotoPath;
}
