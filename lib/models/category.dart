import 'package:flutter/material.dart';

class Category {
  Category({
    this.maxAmount=100,
    required this.name,
    required this.color,
  });
  final Color color;
  final int maxAmount;
  final String name;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color':color,
      'maxAmount': maxAmount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      maxAmount: json['maxAmount'],
      color: json['color'],
    );
  }
}