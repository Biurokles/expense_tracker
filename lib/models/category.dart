import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class Category {
  Category({
    String? id,

    this.maxAmount = 100,
    required this.name,
    required this.color,
  }) : id = id ?? uuid.v4();

  final String id;
  Color color;
  double maxAmount;
  String name;

  int colorToJson(Color color) {
    return color.toARGB32();
  }

  static Color colorFromJson(int value) {
    return Color(value);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': colorToJson(color),
      'maxAmount': maxAmount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      maxAmount: json['maxAmount'],
      color: colorFromJson(json['color']),
    );
  }
}
