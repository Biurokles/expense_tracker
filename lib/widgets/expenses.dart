import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _reqisteredExpenses = [
    Expense(
      title: 'Czipsiki z pupciki',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.jedzenie,
    ),
    Expense(
      title: 'Wompcie pompcie',
      amount: 21.37,
      date: DateTime.now(),
      category: Category.wycieczkaaa,
    ),
  ];

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _reqisteredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _reqisteredExpenses.indexOf(expense);
    setState(() {
      _reqisteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('I do Oskroci wracają pieniązki Iiiii'),
        action: SnackBarAction(
          label: 'wydaj spowrotem',
          onPressed: () {
            setState(() {
              _reqisteredExpenses.insert(expenseIndex, expense);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Icon(
                  Icons.face_5,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text("Ufff, ja już myślałem że wydajesz nasze pieniążki"),
    );
    if (_reqisteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _reqisteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return (Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter expense tracker",
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          _reqisteredExpenses.isNotEmpty
              ? Chart(expenses: _reqisteredExpenses)
              : Text('pusto tu womp womp'),
          Expanded(child: mainContent),
        ],
      ),
    ));
  }
}
