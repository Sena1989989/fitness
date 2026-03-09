class Furniture {
  final String id;
  final String name;
  final String emoji;
  final int cost;
  bool isUnlocked;

  Furniture({
    required this.id,
    required this.name,
    required this.emoji,
    required this.cost,
    this.isUnlocked = false,
  });

  void unlock() {
    isUnlocked = true;
  }
}
