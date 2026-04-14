import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

const uuid = Uuid();

@HiveType(typeId: 1)
class Category extends HiveObject {
  Category({
    String? id,

    this.maxAmount = 100,
    required this.name,
    required this.color,
  }) : id = id ?? uuid.v4();

  @HiveField(0)
  final String id;
  @HiveField(1)
  int color;
  @HiveField(2)
  double maxAmount;
  @HiveField(3)
  String name;
}
