import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/services/category_storage.dart';
import 'package:expense_tracker/services/expense_storage.dart';
import 'package:expense_tracker/widgets/categories/new_category.dart';
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
    loadAll();
    super.initState();
  }

  Future<void> loadAll() async {
    final loadedExpenses = await ExpenseStorage.load();
    final loadedCategories = await CategoryStorage.load();
    setState(() {
      _registeredExpenses = loadedExpenses
          .where((e) => e.date.day == DateTime.now().day)
          .toList();
      _registeredCategories = loadedCategories;
    });
  }

  List<Expense> _registeredExpenses = [];
  List<Category> _registeredCategories = [];

  void changeRange(TimeRange range) {
    switch (range) {
      case TimeRange.day:
        return;
      case TimeRange.month:
        return;
      case TimeRange.year:
        return;
    }
  }

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
              child: NewExpense(
                onAddExpense: _addExpense,
                onAddCategory: _addOrModifyCategory,
              ),
            ),
          ),
        );
      },
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
        duration: const Duration(seconds: 2),
        content: const Text('I do Oskroci wracają pieniązki Iiiii'),
        action: SnackBarAction(
          label: 'wydaj spowrotem',
          onPressed: () {
            setState(() async {
              _registeredExpenses.insert(expenseIndex, expense);
              ExpenseStorage.save(_registeredExpenses);
              await loadAll();
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

  Future<bool> _removeCategory(Category category) async {
    bool isCategoryUsed(Category category) {
      return _registeredExpenses.any(
        (e) => e.category.name == category.name,
      );
    }

    if (isCategoryUsed(category)) {
      final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Powiązana kategoria'),
          content: const Text(
            'Łiła! Ta kategoria ma już zapisane wydatki...',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Niaa'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes Yes'),
            ),
          ],
        ),
      );

      if (result != true) return false;
    }

    setState(() {
      _registeredCategories.remove(category);
      _registeredExpenses.removeWhere(
        (e) => e.category.name == category.name,
      );
    });

    CategoryStorage.delete(category.id);
    ExpenseStorage.deleteByCategory(category.id);

    return true;
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
              child: NewCategory(
                onAddCategory: _addOrModifyCategory,
                onDismissedCategory: _removeCategory,
              ),
            ),
          ),
        );
      },
    ).then((_) {
      loadAll();
    });
  }

  void _addOrModifyCategory(Category category) async {
    final index = _registeredCategories.indexWhere(
      (c) => c.id == category.id,
    );
    if (index == -1) {
      _registeredCategories.add(category);
    } else {
      _registeredCategories[index] = category;
    }
    CategoryStorage.save(_registeredCategories);
    await loadAll();
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Łakocia wydatki śledź",
        ),
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
          _registeredExpenses.isNotEmpty
              ? Chart(
                  expenses: _registeredExpenses,
                  registeredCategories: _registeredCategories,
                  changeExpensesRange: changeRange,
                )
              : Text(''),
          Expanded(child: mainContent),
        ],
      ),
    ));
  }
}
