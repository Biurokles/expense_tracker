import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const  uuid = Uuid();
final formatter = DateFormat.yMMMMEEEEd();

enum Category{jedzenie, wycieczkaaa,lakocieDlaLakoci, inne }

const categoryIcons = {
  Category.jedzenie: Icons.food_bank,
  Category.wycieczkaaa: Icons.travel_explore_sharp,
  Category.lakocieDlaLakoci: Icons.girl,
  Category.inne: Icons.car_rental,
};
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }): id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;


  String get getFormattedDate
  {
    return formatter.format(date);
  }


}
