import 'package:expense_tracker/services/expense_storage.dart';
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

@override
void initState() {
  super.initState();

  ExpenseStorage.load().then((loadedExpenses) {
    setState(() {
      _registeredExpenses = loadedExpenses;
    });
  });
}
  late List<Expense> _registeredExpenses;

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      ExpenseStorage.save(_registeredExpenses);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      ExpenseStorage.delete(expense.id);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        persist: false,
        duration: const Duration(seconds: 1),
        content: const Text('I do Oskroci wracają pieniązki Iiiii'),
        action: SnackBarAction(
          label: 'wydaj spowrotem',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
              ExpenseStorage.save(_registeredExpenses);

            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                persist: false,
                content: Icon(
                  Icons.face_5,
                  color: Colors.black,
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
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return (Scaffold(
      appBar: AppBar(
        title: const Text(
          "Łakocia wydatki śledź",
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
          _registeredExpenses.isNotEmpty
              ? Chart(expenses: _registeredExpenses)
              : Text(''),
          Expanded(child: mainContent),
        ],
      ),
    ));
  }
}
