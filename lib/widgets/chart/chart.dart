import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/category_storage.dart';
import 'package:flutter/material.dart';
import 'chart_bar.dart';
import 'package:expense_tracker/models/category.dart';

class Chart extends StatefulWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;
  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<ExpenseBucket> get buckets {
    return _registeredCategories.map((category) {
      return ExpenseBucket.forCategory(widget.expenses, category);
    }).toList();
  }

  @override
  void initState() {
    CategoryStorage.load().then((loadedCategories) {
      setState(() {
        _registeredCategories = loadedCategories;
      });
    });
    super.initState();
  }

  List<Category> _registeredCategories = [];

  double get maxTotalExpense {
    double maxTotalExpense = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (maxTotalExpense == 0)
                  (Center(
                    child: Text(
                      "Ufff, ja już myślałem że wydajesz nasze pieniążki w tym miesiącu ${maxTotalExpense}",
                    ),
                  ))
                else
                  for (final bucket in buckets)
                    ChartBar(
                      fill: bucket.totalExpenses / maxTotalExpense,
                      color: bucket.category.color,
                    ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: buckets
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '${bucket.category.name} ${bucket.totalExpenses} / ${bucket.category.maxAmount}',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
