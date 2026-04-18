import 'package:flutter/material.dart';
import 'package:expense_tracker/data/models/expense/expense.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem(this.expense, {super.key});

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.00,
          vertical: 16.00,
        ),
        child: Row(
          children: [
            Text(
              expense.getFormattedDate,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(),
            Text(
              expense.amount.toString(),
              style: Theme.of(context).textTheme.titleLarge,
            ),

            SizedBox(
              width: 8,
            ),
            Image.asset(
              'assets/lacoin.png',
              width: 65,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
