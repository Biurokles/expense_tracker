import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/widgets/categories/category_modal.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expenses extends ConsumerStatefulWidget {
  const Expenses({super.key});

  @override
  ConsumerState<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends ConsumerState<Expenses> {
  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/expenses.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
              ),
              child: NewExpense(),
            ),
          ),
        );
      },
    );
  }

  void _openAddCategoriesOverlay() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/category.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8), // overlay
              ),
              child: CategoryModal(),
            ),
          ),
        );
      },
    ).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final expenseAsync = ref.watch(expenseProvider);
    final expensesByRangeAsync = ref.watch(expensesByRangeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Łakocia wydatki śledź"),
        actions: [
          IconButton(
            onPressed: _openAddCategoriesOverlay,
            icon: const Icon(Icons.category),
          ),
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          expenseAsync.when(
            data: (expenses) {
              return Chart(
                expenseList: expenses,
              );
            },

            loading: () {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },

            error: (err, _) {
              return Scaffold(
                body: Center(child: Text("Błąd: $err")),
              );
            },
          ),
          Expanded(
            child: expensesByRangeAsync.isEmpty
                ? const Text("Brak wydatków")
                : ExpensesList(
                    expenses: expensesByRangeAsync,
                  ),
          ),
        ],
      ),
    );
  }
}
