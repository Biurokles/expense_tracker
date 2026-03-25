import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'category.dart';

final formatter = DateFormat('dd/MM');
const uuid = Uuid();

enum TimeRange {
  day,
  month,
  year,
}

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
      'category': category.toJson(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: Category.fromJson(json['category']),
    );
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  final Category category;
  final List<Expense> expenses;

  /// Nowy konstruktor z filtrowaniem po czasie
  ExpenseBucket.forCategoryAndRange(
    List<Expense> allExpenses,
    this.category,
    TimeRange range,
  ) : expenses = allExpenses
          .where((expense) => expense.category.name == category.name)
          .where((expense) {
            switch (range) {
              case TimeRange.day:
                return expense.date.day == DateTime.now().day;
              case TimeRange.month:
                return expense.date.month == DateTime.now().month;
              case TimeRange.year:
                return expense.date.year == DateTime.now().year;
            }
          })
          .toList();

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
