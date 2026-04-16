import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextInsidePie extends ConsumerWidget {
  const TextInsidePie({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final howMuchSpent = ref.watch(totalExpensesByRangeProvider);
    return Text(
      "${howMuchSpent} zł",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
