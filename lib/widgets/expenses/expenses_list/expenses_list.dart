import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/widgets/expenses/expenses_list/expenses_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/expense/expense.dart';
import 'package:flutter/material.dart';

class ExpensesList extends ConsumerWidget {
  const ExpensesList({
    required this.expenses,
    super.key,
  });

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _removeExpense(Expense expense) async {
      final notifier = ref.read(expenseProvider.notifier);
      await notifier.deleteExpense(expense);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          persist: false,
          duration: const Duration(seconds: 2),
          content: const Text('I do Oskroci wracają pieniązki Iiiii'),
          action: SnackBarAction(
            label: 'wydaj spowrotem',
            onPressed: () async {
              await notifier.addExpense(expense);
            },
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          _removeExpense(expenses[index]);
        },
        child: ExpensesItem(expenses[index]),
      ),
    );
  }
}
