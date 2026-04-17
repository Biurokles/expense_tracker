import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/widgets/expenses/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class ExpenseScaffold extends ConsumerStatefulWidget {
  const ExpenseScaffold({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ExpenseScaffoldState();
  }
}

class _ExpenseScaffoldState extends ConsumerState<ExpenseScaffold> {
  final now = DateTime.now();
  late DateTime startDate;
  late DateTime endDate;
  @override
  void initState() {
    startDate = DateTime(now.year, now.month, 1);
    endDate = now;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final expenseByDate = ref.watch(
      expenseByDateProvider((start: startDate, end: endDate)),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Zaawansowane Łakociowanie wydatków'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2024),
            lastDay: DateTime.now(),
            focusedDay: DateTime.now(),
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            rangeStartDay: startDate,
            rangeEndDay: endDate,
            calendarStyle: CalendarStyle(
              rangeHighlightColor: Color(0xFFBE95FA),
              rangeStartDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
            ),
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                startDate = start!;
                endDate = end ?? start;
              });
            },
          ),
          Expanded(child: ExpensesList(expenses: expenseByDate)),
        ],
      ),
    );
  }
}
