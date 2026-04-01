import 'package:hive_flutter/adapters.dart';

part 'badge_data.g.dart';

@HiveType(typeId: 2)
class BadgeData extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isUnlocked;

  @HiveField(3)
  DateTime? dateEarned;

  BadgeData({
    required this.name,
    required this.description,
    required this.isUnlocked,
    this.dateEarned,
  });

  @override
  String toString() {
    return "BadgeData(name: $name, description: $description, isUnlocked: $isUnlocked, dateEarned: $dateEarned)";
  }
}