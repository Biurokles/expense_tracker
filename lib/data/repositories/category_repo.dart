import 'package:expense_tracker/data/models/category/category.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryRepo {
  CategoryRepo(this.box) {}

  final Box<Category> box;

  List<Category> getAll() {
    return box.values.toList();
  }

  Future<void> add(Category category) async {
    await box.put(category.id, category);
  }

  Future<void> update(Category category) async {
    await box.put(category.id, category);
  }

  Future<void> delete(Category category) async {
    await box.delete(category.id);
  }
}
