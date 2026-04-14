import 'package:expense_tracker/provider/expense/tools/expense_hive_provider.dart';
import 'package:expense_tracker/data/repositories/expense_repo.dart';
import 'package:riverpod/riverpod.dart';

final expenseRepoProvider = Provider<ExpenseRepo>((ref) {
  final box = ref.watch(expenseHiveProvider);
  return ExpenseRepo(box);
});
