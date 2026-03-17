import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
final formatter = DateFormat('dd/MM');
const uuid = Uuid();

enum Category { jedzenie, wycieczkaaa, lakocieDlaLakoci, inne }

const categoryIcons = {
  Category.jedzenie: Icons.food_bank,
  Category.wycieczkaaa: Icons.travel_explore_sharp,
  Category.lakocieDlaLakoci: Icons.girl,
  Category.inne: Icons.car_rental,
};

class Expense {
  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get getFormattedDate {
    return formatter.format(date);
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: Category.values.firstWhere(
        (e) => e.name == json['category'],
      ),
    );
  }
}



class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .where((expense) => expense.date.month == DateTime.now().month)
          .toList();
  final Category category;
  final List<Expense> expenses;
  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}
