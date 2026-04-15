import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/expense/state/expense_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartLegend extends ConsumerWidget {
  const ChartLegend({super.key, required this.categoryList});
  final List<Category> categoryList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: categoryList.map((category) {
        final totalLegend = ref.watch(totalByCategoryProvider(category));

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.favorite, color: Colors.white, size: 24),
                Icon(Icons.favorite, color: Color(category.color), size: 20),
              ],
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name),
                Text(
                  '${totalLegend.toStringAsFixed(2)} / ${category.maxAmount}',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }
}
