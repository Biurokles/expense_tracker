import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartInit extends ConsumerWidget {
  const ChartInit({super.key, required this.categoryList});

  final List<Category> categoryList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PieChartSectionData> _buildPieSections() {
      double totalExpensesSum = ref.watch(totalExpensesProvider);

      if (totalExpensesSum == 0) return [];

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

    return PieChart(
      PieChartData(
        sections: _buildPieSections(),
        centerSpaceRadius: 50,
        sectionsSpace: 2,
      ),
    );
  }
}
