import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/models/category.dart';

class CategoryStorage {
  static const _key = 'categories';

   static Future<void> save(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();

    final data = categories
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await prefs.setStringList(_key, data);
  }

  static Future<List<Category>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_key);

    if (data == null) return [];

    return data
        .map((e) => Category.fromJson(jsonDecode(e)))
        .toList();
  }

    static Future<void> delete(String id) async {
    final categories = await load();

    categories.removeWhere((e) => e.id == id);

    await save(categories);
  }
}