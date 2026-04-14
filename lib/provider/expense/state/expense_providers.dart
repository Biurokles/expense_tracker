import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:expense_tracker/provider/expense/tools/expense_repo_provider.dart';
import 'package:riverpod/riverpod.dart';

final expensesByCategoryProvider = Provider.family<List<Expense>, Category>((
  ref,
  category,
) {
  final repo = ref.watch(expenseRepoProvider);
  return repo.getByCategory(category);
});

final expensesByRangeProvider = Provider.family<List<Expense>, TimeRange>((
  ref,
  range,
) {
  final repo = ref.watch(expenseRepoProvider);
  return repo.getByRange(range);
});

final expenseByCategoryAndRange =
    Provider.family<List<Expense>, ({Category category, TimeRange range})>(
      (
        ref,
        params,
      ) {
        final repo = ref.read(expenseRepoProvider);
        final byRange = repo.getByRange(params.range);
        return byRange.where((e) => e.category == params.category).toList();
      },
    );

final getTotalByCategoryAndRange =
    Provider.family<double, ({Category category, TimeRange range})>((
      ref,
      params,
    ) {
      final repo = ref.read(expenseRepoProvider);
      final byRange = repo.getByRange(params.range);
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
