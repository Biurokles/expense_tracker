import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/provider/timeRange/timeRangeProvider.dart';
import 'package:riverpod/riverpod.dart';

final expensesByCategoryProvider = Provider.family<List<Expense>, Category>((
  ref,
  category,
) {
  final expenseAsync = ref.watch(expenseProvider);

  return expenseAsync.when(
    data: (expenseList) =>
        expenseList.where((e) => e.category.id == category.id).toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
    error: (_, __) => [],
    loading: () => [],
  );
});

final expensesByRangeProvider = Provider<List<Expense>>((ref) {
  final expenseAsync = ref.watch(expenseProvider);
  final range = ref.watch(timeRangeProvider);
  return expenseAsync.when(
    data: (expenseList) =>
        expenseList.where((e) => range.matches(e.date)).toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
    error: (_, __) => [],
    loading: () => [],
  );
});

final expenseByDateProvider =
    Provider.family<List<Expense>, ({DateTime start, DateTime end})>(
      (ref, params) {
        final expenses = ref.watch(expenseProvider);
        return expenses.when(
          data: (expenseList) {
            return expenseList
                .where(
                  (e) =>
                      e.date.isAfter(params.start) &&
                      e.date.isBefore(params.end),
                )
                .toList();
          },
          error: (_, __) => [],
          loading: () => [],
        );
      },
    );

final expenseByCategoryAndRangeProvider =
    Provider.family<List<Expense>, ({Category category})>(
      (
        ref,
        params,
      ) {
        final byRange = ref.watch(expensesByRangeProvider);
        return byRange.where((e) => e.category == params.category).toList();
      },
    );

final totalExpensesByRangeProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expenseProvider);
  final range = ref.watch(timeRangeProvider);

  return expensesAsync.when(
    data: (expenses) => expenses
        .where((expense) => range.matches(expense.date))
        .fold(0.0, (sum, e) => sum + e.amount),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

final totalByCategoryAndRangeProvider = Provider.family<double, Category>((
  ref,
  category,
) {
  final expensesAsync = ref.watch(expensesByRangeProvider);
  return expensesAsync
      .where((e) => e.category.id == category.id)
      .fold(0.0, (sum, e) => sum += e.amount);
});

final totalByCategoryProvider = Provider.family<double, Category>((
  ref,
  category,
) {
  final expensesAsync = ref.watch(expenseProvider);

  return expensesAsync.when(
    data: (expenses) => expenses
        .where((e) => e.category.id == category.id)
        .fold(0.0, (sum, e) => sum + e.amount),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

final isCategoryUsedProvider = Provider.family<bool, Category>((
  ref,
  category,
) {
  final expenses = ref.watch(expenseProvider);
  return expenses.when(
    data: (expenseList) =>
        expenseList.any((e) => e.category.name == category.name),
    error: (_, __) => false,
    loading: () => false,
  );
});
