import 'expense.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchExpenses({required String farmId, String? seasonId});
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
}
