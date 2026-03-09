class StoryStep {
  final String id;
  final String title;
  final String message;
  final String characterEmoji;
  final String? characterName;
  final String? buttonText;

  StoryStep({
    required this.id,
    required this.title,
    required this.message,
    required this.characterEmoji,
    this.characterName,
    this.buttonText,
  });
}
