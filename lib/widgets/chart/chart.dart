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

class _ChartState extends State<Chart>{

   List<ExpenseBucket> get buckets {
    for(var i=0; i<_registeredCategories.length; i++)
    {
      ExpenseBucket.forCategory(widget.expenses, _registeredCategories[i]);
    }
    throw 'Nie ma nawet kategorii pieniążkowych!';

    
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
  late List<Category> _registeredCategories;

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
                      "Ufff, ja już myślałem że wydajesz nasze pieniążki w tym miesiącu",
                    ),
                  ))
                else
                  for (final bucket in buckets)
                    ChartBar(
                      fill: bucket.totalExpenses / maxTotalExpense,
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
