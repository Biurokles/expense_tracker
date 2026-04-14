import 'package:expense_tracker/data/models/category/category.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';

final categoriesBoxProvider = Provider<Box<Category>>((ref) {
  return Hive.box<Category>('categories');
});
