import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
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
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text("Flutter expense tracker"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.add),)
        ],
      ),
      body: Column(
        children: [
          const Text('czart'),
          Expanded(child: ExpensesList(expenses: _reqisteredExpenses))
        ],
      ),
    ));
  }
}
