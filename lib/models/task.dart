enum SlimeColor { red, green, blue }

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class Task {
  final String title;
  final String description;
  final SlimeColor slimeColor;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.slimeColor,
    this.isCompleted = false,
  });

  String get slimeAsset =>
      "assets/images/Run${slimeColor.name.capitalize()}SlimeCrop.gif";
}
