import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/widgets/categories/category_dialog.dart';
import 'package:expense_tracker/widgets/categories/category_scaffold.dart';
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
      totalByCategoryAndRangeProvider(category),
    );

    final percent = totalSpent / category.maxAmount;

    Color getAmountColor() {
      if (percent >= 1.0) return Colors.red;
      if (percent >= 0.8) return Colors.orange;
      return Colors.green;
    }

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => CategoryScaffold(
                category: category,
              ),
            ),
          );
        },
        onLongPress: () {
          showCategoryDialog(context, existing: category);
        },

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
              Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 34),
                  Icon(
                    Icons.favorite,
                    color: Color(category.color),
                    size: 30,
                  ),
                ],
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
