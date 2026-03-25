import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/widgets/categories/category_item.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    super.key,
    required this.categories,
    required this.onRemoveCategory,
    required this.onClickCategory,
  });

  final List<Category> categories;
  final Future<bool> Function(Category category) onRemoveCategory;
  final void Function({Category? existing}) onClickCategory;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(categories[index].id),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        confirmDismiss: (direction) {
          return onRemoveCategory(categories[index]);
        },
        child: CategoryItem(
          category: categories[index],
          onCategoryClick: onClickCategory,
        ),
      ),
    );
  }
}
