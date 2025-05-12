class Task {
  final String title;
  final String description;
  final String slimeAsset;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.slimeAsset,
    this.isCompleted = false,
  });
}
