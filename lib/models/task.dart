class Task {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final int rewardPoints;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    required this.rewardPoints,
    this.isCompleted = false,
  });

  void complete() {
    isCompleted = true;
  }
}
