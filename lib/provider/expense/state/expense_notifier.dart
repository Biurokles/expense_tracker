import 'dart:async';

import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/provider/expense/tools/expense_repo_provider.dart';
import 'package:expense_tracker/data/repositories/expense_repo.dart';
import 'package:riverpod/riverpod.dart';

final expenseProvider = AsyncNotifierProvider<ExpenseNotifier, List<Expense>>(
  ExpenseNotifier.new,
);

final totalExpensesProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expenseProvider);

  return expensesAsync.when(
    data: (expenses) => expenses.fold(0.0, (sum, e) => sum + e.amount),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

class ExpenseNotifier extends AsyncNotifier<List<Expense>> {
  late ExpenseRepo repo;

  @override
  Future<List<Expense>> build() async {
    repo = ref.read(expenseRepoProvider);
    return repo.getAll();
  }

  Future<void> addExpense(Expense expense) async {
    await repo.add(expense);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }

  Future<void> deleteExpense(Expense expense) async {
    await repo.delete(expense);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }

  Future<void> deleteExpenseByCategory(Category category) async {
    await repo.deleteByCategory(category);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }
}
