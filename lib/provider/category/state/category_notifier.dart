import 'dart:async';

import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/category/tools/category_repo_provider.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/data/repositories/category_repo.dart';
import 'package:expense_tracker/data/repositories/expense_repo.dart';
import 'package:riverpod/riverpod.dart';

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
      CategoryNotifier.new,
    );

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  late CategoryRepo repo;
  late ExpenseRepo expRepo;

  @override
  Future<List<Category>> build() async {
    repo = ref.read(categoryRepoProvider);
    return repo.getAll();
  }

  Future<void> addCategory(Category category) async {
    await repo.add(category);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }

  Future<void> updateCategory(Category category) async {
    await repo.update(category);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }

  Future<void> deleteCategory(Category category) async {
    await repo.delete(category);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }

  Future<void> deleteCategoryandExpenses(Category category) async {
    await ref.read(expenseProvider.notifier).deleteExpenseByCategory(category);
    await repo.delete(category);
    state = AsyncValue.data(
      await repo.getAll(),
    );
  }
}
