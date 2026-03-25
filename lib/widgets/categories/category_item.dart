import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.bucket,
    required this.onCategoryClick,
  });

  final ExpenseBucket bucket;
  final void Function({Category? existing}) onCategoryClick;
  

  

  @override
  Widget build(BuildContext context) {
    final category = bucket.category;
    final totalSpent = bucket.totalExpenses;


    final percent = totalSpent / category.maxAmount;

Color getAmountColor() {
  if (percent >= 1.0) return Colors.red;       // przekroczony limit
  if (percent >= 0.8) return Colors.orange;    // blisko limitu
  return Colors.green;                         // bezpiecznie
}

    return Card(
      child: InkWell(
        onTap: () => onCategoryClick(existing: category),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.favorite,
                color: category.color,
                size: 30,
              ),
              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${totalSpent.toStringAsFixed(2)}',
                    style:  TextStyle(fontWeight: FontWeight.bold, color: getAmountColor(), ),
                  ),
                  Text(
                    '/ ${category.maxAmount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12, color:getAmountColor(),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
