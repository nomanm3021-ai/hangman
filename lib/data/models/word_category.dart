/// Represents a word category (e.g. Animals, Countries).
class WordCategory {
  const WordCategory({
    required this.id,
    required this.displayName,
    required this.emoji,
  });

  final String id;
  final String displayName;
  final String emoji;

  static const List<WordCategory> all = [
    WordCategory(id: 'animals', displayName: 'Animals', emoji: '🐾'),
    WordCategory(id: 'countries', displayName: 'Countries', emoji: '🌍'),
    WordCategory(id: 'food', displayName: 'Food', emoji: '🍕'),
    WordCategory(id: 'sports', displayName: 'Sports', emoji: '⚽'),
    WordCategory(id: 'technology', displayName: 'Technology', emoji: '💻'),
    WordCategory(id: 'movies', displayName: 'Movies', emoji: '🎬'),
  ];

  @override
  String toString() => 'WordCategory($id)';
}

/// Game difficulty level.
enum Difficulty {
  easy(
    label: 'Easy',
    emoji: '😊',
    maxWrongGuesses: 8,
    maxHints: 3,
    baseScore: 100,
    minWordLength: 3,
    maxWordLength: 6,
  ),
  medium(
    label: 'Medium',
    emoji: '🤔',
    maxWrongGuesses: 6,
    maxHints: 2,
    baseScore: 200,
    minWordLength: 5,
    maxWordLength: 9,
  ),
  hard(
    label: 'Hard',
    emoji: '😤',
    maxWrongGuesses: 5,
    maxHints: 1,
    baseScore: 350,
    minWordLength: 7,
    maxWordLength: 20,
  );

  const Difficulty({
    required this.label,
    required this.emoji,
    required this.maxWrongGuesses,
    required this.maxHints,
    required this.baseScore,
    required this.minWordLength,
    required this.maxWordLength,
  });

  final String label;
  final String emoji;
  final int maxWrongGuesses;
  final int maxHints;
  final int baseScore;
  final int minWordLength;
  final int maxWordLength;
}

/// A single word entry loaded from JSON assets.
class WordEntry {
  const WordEntry({required this.word, this.hint});

  final String word;
  final String? hint; // optional built-in hint text (not used as gameplay hint)

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      word: (json['word'] as String).toUpperCase(),
      hint: json['hint'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'word': word, if (hint != null) 'hint': hint};

  @override
  String toString() => 'WordEntry($word)';
}
