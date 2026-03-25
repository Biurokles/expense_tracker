import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class ExpenseStorage {
  static const _key = 'expenses';

  static Future<void> save(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();

    final data = expenses.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_key, data);
  }

  static Future<List<Expense>> load() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_key);

    if (data == null) return [];

    return data.map((e) => Expense.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> delete(String id) async {
    final expenses = await load();

    expenses.removeWhere((e) => e.id == id);

    await save(expenses);
  }

  static Future<void> deleteByCategory(String id) async {
    final expenses = await load();

    expenses.removeWhere((e) => e.category.id == id);

    await save(expenses);
  }
}
