import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables.dart';
import '../../../core/sync/sync_queue_repository.dart';
import '../../../core/utils/ids.dart';
import '../domain/expense.dart' as domain;
import '../domain/expense_repository.dart';

const _table = 'expenses';

class LocalExpenseRepository implements ExpenseRepository {
  LocalExpenseRepository(this._db, this._syncQueue);

  final AppDatabase _db;
  final SyncQueueRepository _syncQueue;

  @override
  Stream<List<domain.Expense>> watchExpenses({required String farmId, String? seasonId}) {
    final query = _db.select(_db.expenses)
      ..where((e) {
        var predicate = e.farmId.equals(farmId) & e.deletedAt.isNull();
        if (seasonId != null) predicate = predicate & e.seasonId.equals(seasonId);
        return predicate;
      })
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addExpense(domain.Expense expense) async {
    final now = DateTime.now();
    final id = expense.id.isEmpty ? newId() : expense.id;
    await _db.into(_db.expenses).insert(
          ExpensesCompanion.insert(
            id: id,
            farmId: expense.farmId,
            seasonId: Value(expense.seasonId),
            amount: expense.amount,
            category: expense.category.name,
            date: expense.date,
            notes: Value(expense.notes),
            receiptPhotoPath: Value(expense.receiptPhotoPath),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'create');
  }

  @override
  Future<void> deleteExpense(String id) async {
    await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
      ExpensesCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingDelete),
      ),
    );
    await _syncQueue.enqueue(table: _table, entityId: id, operation: 'delete');
  }

  domain.Expense _toDomain(Expense row) => domain.Expense(
        id: row.id,
        farmId: row.farmId,
        seasonId: row.seasonId,
        amount: row.amount,
        category: domain.ExpenseCategory.values.firstWhere(
          (c) => c.name == row.category,
          orElse: () => domain.ExpenseCategory.other,
        ),
        date: row.date,
        notes: row.notes,
        receiptPhotoPath: row.receiptPhotoPath,
      );
}
