import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chart extends ConsumerStatefulWidget {
  const Chart({
    super.key,
    required this.changeExpensesRange,
  });

  final void Function(TimeRange range) changeExpensesRange;

  @override
  ConsumerState<Chart> createState() => _ChartState();
}

class _ChartState extends ConsumerState<Chart> {
  TimeRange selectedRange = TimeRange.month;

  double get totalExpensesSum {
    return ref.watch(totalExpensesProvider);
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

  List<PieChartSectionData> _buildPieSections(List<Category> categoryList) {
    final total = totalExpensesSum;

    if (total == 0) return [];

    return categoryList.map((category) {
      final value = ref.watch(totalByCategoryProvider(category));

      Color getTextColor(Color background) {
        final luminance = background.computeLuminance();
        return luminance > 0.5 ? Colors.black : Colors.white;
      }

      return PieChartSectionData(
        value: value,
        color: Color(category.color),
        title: category.name,
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: getTextColor(Color(category.color)),
        ),
      );
    }).toList();
  }

  double _calculateExpenses(List<Expense> expenseList) {
    var now = DateTime.now();

    switch (selectedRange) {
      case TimeRange.day:
        return expenseList
            .where((e) => e.date.day == now.day)
            .fold(0, (sum, e) => sum + e.amount);

      case TimeRange.month:
        return expenseList
            .where((e) => e.date.month == now.month)
            .fold(0, (sum, e) => sum + e.amount);

      case TimeRange.year:
        return expenseList
            .where((e) => e.date.year == now.year)
            .fold(0, (sum, e) => sum + e.amount);
    }
  }

  Widget _buildLegend(List<Category> categoryList) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: categoryList.map((category) {
        final total = ref.watch(totalByCategoryProvider(category));

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 24),
                Icon(Icons.favorite, color: Color(category.color), size: 20),
              ],
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name),
                Text(
                  '${total.toStringAsFixed(2)} / ${category.maxAmount}',
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
    final categoryAsync = ref.watch(categoryProvider);
    final expenseAsync = ref.watch(expenseProvider);

    return categoryAsync.when(
      data: (categoryList) {
        return expenseAsync.when(
          data: (expenseList) {
            final total = totalExpensesSum;

            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
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
                                  sections: _buildPieSections(categoryList),
                                  centerSpaceRadius: 50,
                                  sectionsSpace: 2,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    rangeText,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "${_calculateExpenses(expenseList).toStringAsFixed(2)} zł",
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
                  _buildLegend(categoryList),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Expense error: $e")),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Category error: $e")),
    );
  }
}
