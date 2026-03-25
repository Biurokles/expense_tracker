import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  const Chart({super.key, required this.expenses, required this.registeredCategories});

  final List<Expense> expenses;
  final List<Category> registeredCategories;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {


  List<ExpenseBucket> get buckets {
    return widget.registeredCategories.map((category) {
      return ExpenseBucket.forCategory(widget.expenses, category);
    }).toList();
  }

  double get totalExpensesSum {
    return buckets.fold(0, (sum, b) => sum + b.totalExpenses);
  }

  List<PieChartSectionData> get pieSections {
    final total = totalExpensesSum;

    if (total == 0) return [];

    return buckets.map((bucket) {
      final value = bucket.totalExpenses;

      return PieChartSectionData(
        value: value,
        color: bucket.category.color,
        title: bucket.category.name,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final total = totalExpensesSum;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      width: double.infinity,
      height: 250,
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
      child: total == 0
          ? const Center(child: Text("Brak danych do wykresu"))
          : PieChart(
              PieChartData(
                sections: pieSections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
    );
  }
}