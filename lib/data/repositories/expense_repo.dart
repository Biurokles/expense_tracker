import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseRepo {
  ExpenseRepo(this.box);
  final Box<Expense> box;

  List<Expense> getAll() {
    return box.values.toList();
  }

  List<Expense> getByCategory(
    Category category, {
    List<Expense>? expenses,
  }) {
    final source = expenses ?? box.values;

    return source.where((e) => e.category == category).toList();
  }

  List<Expense> getByRange(TimeRange range) {
    return box.values.where((expense) => range.matches(expense.date)).toList();
  }

  List<Expense> getByCategoryAndRange(Category category, TimeRange range) {
    return getByCategory(category, expenses: getByRange(range));
  }

  Future<void> add(Expense expense) async {
    await box.put(expense.id, expense);
  }

  Future<void> delete(Expense expense) async {
    await box.delete(expense.id);
  }

  Future<void> deleteByCategory(Category category) async {
    final keysToDelete = <dynamic>[];

    for (final expense in box.values) {
      if (expense.category == category) {
        keysToDelete.add(expense.id);
      }
    }

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}
