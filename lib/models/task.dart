import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum SlimeColor {
  @HiveField(0)
  red,
  @HiveField(1)
  green,
  @HiveField(2)
  blue
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  SlimeColor slimeColor;

  @HiveField(3)
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.slimeColor,
    this.isCompleted = false,
  });

  String get slimeAsset =>
      "assets/images/Run${slimeColor.name.capitalize()}SlimeCrop.gif";
}
