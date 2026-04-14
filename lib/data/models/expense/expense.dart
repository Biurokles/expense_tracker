import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../category/category.dart';
part 'expense.g.dart';

final formatter = DateFormat('dd/MM');
const uuid = Uuid();

@HiveType(typeId: 2)
class Expense {
  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final Category category;

  String get getFormattedDate {
    return formatter.format(date);
  }
}
