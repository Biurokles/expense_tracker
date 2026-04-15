import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/provider/expense/tools/expense_repo_provider.dart';
import 'package:expense_tracker/provider/timeRange/timeRangeProvider.dart';
import 'package:riverpod/riverpod.dart';

final expensesByCategoryProvider = Provider.family<List<Expense>, Category>((
  ref,
  category,
) {
  final repo = ref.watch(expenseRepoProvider);
  return repo.getByCategory(category);
});

final expensesByRangeProvider = Provider<List<Expense>>((ref) {
  final repo = ref.watch(expenseRepoProvider);
  final range = ref.read(timeRangeProvider);
  return repo.getByRange(range);
});

final expenseByCategoryAndRange =
    Provider.family<List<Expense>, ({Category category})>(
      (
        ref,
        params,
      ) {
        final repo = ref.read(expenseRepoProvider);
        final range = ref.read(timeRangeProvider);
        final byRange = repo.getByRange(range);
        return byRange.where((e) => e.category == params.category).toList();
      },
    );

final getTotalByCategoryAndRange =
    Provider.family<double, ({Category category})>((
      ref,
      params,
    ) {
      final repo = ref.read(expenseRepoProvider);
      final range = ref.read(timeRangeProvider);
      final byRange = repo.getByRange(range);
      return byRange
          .where((e) => e.category == params.category)
          .fold(0.0, (sum, e) => sum += e.amount);
    });

final totalByCategoryProvider = Provider.family<double, Category>((
  ref,
  category,
) {
  final repo = ref.read(expenseRepoProvider);
  return repo.getTotalByCategory(category);
});

final isCategoryUsedProvider = Provider.family<bool, Category>((
  ref,
  category,
) {
  final repo = ref.read(expenseRepoProvider);
  return repo.isCategoryUsed(category);
});
