import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:expense_tracker/provider/expense/state/expense_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/provider/timeRange/timeRangeProvider.dart';
import 'package:expense_tracker/widgets/chart/text_inside_pie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartInit extends ConsumerWidget {
  const ChartInit({super.key, required this.categoryList});

  final List<Category> categoryList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRange = ref.watch(timeRangeProvider);
    final totalExpensesByRange = ref.watch(totalExpensesByRangeProvider);
    List<PieChartSectionData> _buildPieSections() {
      double totalExpensesSum = ref.watch(totalExpensesProvider);

      if (totalExpensesSum == 0) return [];

      return categoryList.map((category) {
        final value = ref.watch(totalByCategoryAndRangeProvider(category));

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

    return SizedBox(
      height: 220,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          final scale = Tween<double>(
            begin: 0.96,
            end: 1.0,
          ).animate(fade);

          final slide = Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(fade);

          return FadeTransition(
            opacity: fade,
            child: SlideTransition(
              position: slide,
              child: ScaleTransition(
                scale: scale,
                child: child,
              ),
            ),
          );
        },
        child: totalExpensesByRange == 0
            ? Center(
                key: const ValueKey('empty'),
                child: Text(selectedRange.emptyChartMessage()),
              )
            : Stack(
                key: const ValueKey('chart'),
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeInOutCubic,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: PieChart(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOutCubic,
                      PieChartData(
                        sections: _buildPieSections(),
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedRange.rangeText(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      TextInsidePie(),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
