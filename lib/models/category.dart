import 'package:flutter/material.dart';

class Category {
  Category({
    this.maxAmount = 100,
    required this.name,
    required this.color,
  });
  final Color color;
  final double maxAmount;
  final String name;

  int colorToJson(Color color) {
    return color.toARGB32();
  }

  static Color colorFromJson(int value) {
    return Color(value);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': colorToJson(color),
      'maxAmount': maxAmount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      maxAmount: json['maxAmount'],
      color: colorFromJson(json['color']),
    );
  }
}
