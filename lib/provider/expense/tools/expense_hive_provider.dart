import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';

final expenseHiveProvider = Provider<Box<Expense>>((ref) {
  return Hive.box<Expense>("expenses");
});
