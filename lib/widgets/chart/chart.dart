import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Chart extends StatefulWidget {
  const Chart({
    super.key,
    required this.expenses,
    required this.registeredCategories,
    required this.changeExpensesRange,
  });

  final void Function(TimeRange range) changeExpensesRange;
  final List<Expense> expenses;
  final List<Category> registeredCategories;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  TimeRange selectedRange = TimeRange.month;

  List<ExpenseBucket> get buckets {
    return widget.registeredCategories.map((category) {
      return ExpenseBucket.forCategoryAndRange(
        widget.expenses,
        category,
        selectedRange,
      );
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

      Color getTextColor(Color background) {
        final luminance = background.computeLuminance();
        return luminance > 0.5 ? Colors.black : Colors.white;
      }

      return PieChartSectionData(
        value: value,
        color: bucket.category.color,
        title: bucket.category.name,
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: getTextColor(bucket.category.color),
        ),
      );
    }).toList();
  }

  Widget buildRangeSelector() {
    return SegmentedButton<TimeRange>(
      segments: const [
        ButtonSegment(
          value: TimeRange.day,
          label: Text("Dzień"),
        ),
        ButtonSegment(
          value: TimeRange.month,
          label: Text("Miesiąc"),
        ),
        ButtonSegment(
          value: TimeRange.year,
          label: Text("Rok"),
        ),
      ],
      selected: {selectedRange},
      onSelectionChanged: (Set<TimeRange> newSelection) {
        setState(() {
          selectedRange = newSelection.first;
        });
      },
    );
  }

  double get todayExpenses {
    var now = DateTime.now();

    switch (selectedRange) {
      case TimeRange.day:
        return widget.expenses
            .where(
              (e) => e.date.day == now.day,
            )
            .fold(0, (sum, e) => sum + e.amount);
      case TimeRange.month:
        return widget.expenses
            .where(
              (e) => e.date.month == now.month,
            )
            .fold(0, (sum, e) => sum + e.amount);
      case TimeRange.year:
        return widget.expenses
            .where(
              (e) => e.date.year == now.year,
            )
            .fold(0, (sum, e) => sum + e.amount);
    }
  }

  Widget buildLegend() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: buckets.map((bucket) {
        final total = bucket.totalExpenses;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
                Icon(
                  Icons.favorite,
                  color: bucket.category.color,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bucket.category.name),
                Text(
                  '${total.toStringAsFixed(2)} / ${bucket.category.maxAmount}',

                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }

  String get emptyChartMessage {
    switch (selectedRange) {
      case TimeRange.day:
        return "Łiła! Dzisiaj jeszcze nic nie kupiłaś! Jakby girl!";
      case TimeRange.month:
        return "Najwyraźniej nie przyszła jeszcze wypłata";
      case TimeRange.year:
        return "Uuu to chyba nowy rok, że tak nic nie kupujesz";
    }
  }

  String get rangeText {
    switch (selectedRange) {
      case TimeRange.day:
        widget.changeExpensesRange(TimeRange.day);
        return 'Dzisiaj';
      case TimeRange.month:
        widget.changeExpensesRange(TimeRange.month);
        return 'W tym miesiącu';
      case TimeRange.year:
        widget.changeExpensesRange(TimeRange.year);
        return 'W tym roku';
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = totalExpensesSum;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
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
          buildRangeSelector(),
          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            child: total == 0
                ? Center(child: Text(emptyChartMessage))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: pieSections,
                          centerSpaceRadius: 50,
                          sectionsSpace: 2,
                        ),
                      ),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rangeText,
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "${todayExpenses.toStringAsFixed(2)} zł",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 12),
          buildLegend(),
        ],
      ),
    );
  }
}
