import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.onCategoryClick,
  });

  final Category category;
  final void Function({Category? existing}) onCategoryClick;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => onCategoryClick(existing: category),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.00,
            vertical: 8.00,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.favorite,
                    color: category.color,
                    size: 30,
                  ),
                  Spacer(),
                  Text('polskich złociszy ${category.maxAmount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
