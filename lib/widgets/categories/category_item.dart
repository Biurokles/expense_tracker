import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryItem extends ConsumerWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalSpent = ref.watch(
      getTotalByCategoryAndRange((category: category)),
    );

    final percent = totalSpent / category.maxAmount;

    Color getAmountColor() {
      if (percent >= 1.0) return Colors.red;
      if (percent >= 0.8) return Colors.orange;
      return Colors.green;
    }

    return Card(
      child: InkWell(
        onTap: () {},
        /* TODO: dialog do podglądania wydatków po kliknięciu w kategorie*/
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
                color: Color(category.color),
                size: 30,
              ),
              const Spacer(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${totalSpent.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getAmountColor(),
                    ),
                  ),
                  Text(
                    '/ ${category.maxAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: getAmountColor(),
                    ),
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
