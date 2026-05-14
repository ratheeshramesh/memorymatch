class MemoryCard {
  final int id;
  final String emoji;
  final String label;
  bool isFaceUp;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.emoji,
    required this.label,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id,
      emoji: emoji,
      label: label,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
