import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_providers.dart';
import '../../core/sync/sync_providers.dart';
import '../dashboard/dashboard_providers.dart';
import 'data/local_expense_repository.dart';
import 'domain/expense.dart';
import 'domain/expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return LocalExpenseRepository(ref.watch(appDatabaseProvider), ref.watch(syncQueueRepositoryProvider));
});

/// Expenses for the farmer's primary farm's active season (dashboard,
/// expenses list).
final seasonExpensesProvider = StreamProvider<List<Expense>>((ref) {
  final farm = ref.watch(primaryFarmProvider);
  final season = ref.watch(primaryActiveSeasonProvider).value;
  if (farm == null) return const Stream.empty();
  return ref
      .watch(expenseRepositoryProvider)
      .watchExpenses(farmId: farm.id, seasonId: season?.id);
});
