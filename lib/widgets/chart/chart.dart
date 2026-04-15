import 'package:expense_tracker/data/models/expense/expense.dart';
import 'package:expense_tracker/data/models/time_range.dart';
import 'package:expense_tracker/provider/category/state/category_notifier.dart';

import 'package:expense_tracker/provider/timeRange/timeRangeProvider.dart';
import 'package:expense_tracker/widgets/chart/chart_legend.dart';
import 'package:expense_tracker/widgets/chart/pie_chart.dart';
import 'package:expense_tracker/widgets/chart/text_inside_pie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Chart extends ConsumerStatefulWidget {
  const Chart({
    super.key,
    required this.expenseList,
  });

  final List<Expense> expenseList;

  @override
  ConsumerState<Chart> createState() => _ChartState();
}

class _ChartState extends ConsumerState<Chart> {
  @override
  Widget build(BuildContext context) {
    TimeRange selectedRange = ref.watch(timeRangeProvider);
    final categoryProv = ref.watch(categoryProvider);

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
          ref.read(timeRangeProvider.notifier).setRange(newSelection.first);
        },
      );
    }

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
      child: categoryProv.when(
        data: (categoryList) => Column(
          children: [
            buildRangeSelector(),
            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: widget.expenseList.length == 0
                  ? Center(child: Text(selectedRange.emptyChartMessage()))
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        ChartInit(categoryList: categoryList),
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

            const SizedBox(height: 12),
            ChartLegend(categoryList: categoryList),
          ],
        ),
        loading: () {
          return CircularProgressIndicator();
        },

        error: (err, _) {
          return Text("Błąd: $err");
        },
      ),
    );
  }
}
