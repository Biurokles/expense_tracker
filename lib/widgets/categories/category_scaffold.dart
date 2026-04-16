import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryScaffold extends ConsumerWidget {
  const CategoryScaffold({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesByCategoryProvider(category));
    return Scaffold(
      appBar: AppBar(
        title: Text('Wydatki z kategorii ${category.name}'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/expense_scaffold.png'),
            fit: BoxFit.fill,
            opacity: 0.1,
          ),
        ),
        child: ExpensesList(expenses: expenses),
      ),
    );
  }
}
