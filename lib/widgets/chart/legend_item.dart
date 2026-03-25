import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final ExpenseBucket bucket;

  const LegendItem({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    final total = bucket.totalExpenses;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite,
            color: bucket.category.color,
            size: 30,
          ),
          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bucket.category.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
