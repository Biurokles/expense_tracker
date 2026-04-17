import 'package:expense_tracker/data/models/category/category.dart';
import 'package:expense_tracker/provider/category/state/category_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryByNameProvider = Provider.family<Category?, String>((
  ref,
  categoryName,
) {
  final categoryAsync = ref.watch(categoryProvider).value;
  if (categoryAsync == null) return null;

  return categoryAsync.where((e) => e.name == categoryName).first;
});
