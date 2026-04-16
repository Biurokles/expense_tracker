import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:expense_tracker/widgets/categories/category_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesList extends ConsumerWidget {
  final List<Category> categories;

  const CategoriesList({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<bool> _confirmDelete() async {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Powiązana kategoria'),
          content: const Text(
            'Łiła! Ta kategoria ma już zapisane wydatki...',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Niaa'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes Yes'),
            ),
          ],
        ),
      );

      return result ?? false;
    }

    Future<bool> _removeCategory(Category category) async {
      final isUsed = ref.read(isCategoryUsedProvider(category));
      final shouldDelete = !isUsed || await _confirmDelete();

      if (!shouldDelete) return false;

      await ref
          .read(categoryProvider.notifier)
          .deleteCategoryandExpenses(category);

      return true;
    }

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
        confirmDismiss: (direction) async {
          return _removeCategory(categories[index]);
        },
        child: CategoryItem(category: categories[index]),
      ),
    );
  }
}
