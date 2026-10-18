import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hangman/core/constants.dart';
import 'package:hangman/data/models/word_category.dart';
import 'package:hangman/data/repositories/settings_repository.dart';
import 'package:hangman/data/repositories/word_repository.dart';
import 'package:hangman/logic/game_controller.dart';

// A mock word repository to provide deterministic words for testing
class MockWordRepository extends WordRepository {
  @override
  Future<List<WordEntry>> getWordsForCategory(String categoryId) async {
    return [
      const WordEntry(word: 'TEST'),
      const WordEntry(word: 'FLUTTER'),
    ];
  }

  @override
  List<WordEntry> filterWordsByDifficulty(List<WordEntry> words, Difficulty difficulty) {
    // Return all for testing
    return words;
  }
}

void main() {
  late GameController gameController;
  late MockWordRepository wordRepository;
  late SettingsRepository settingsRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    
    settingsRepository = SettingsRepository(prefs);
    wordRepository = MockWordRepository();
    
    gameController = GameController(
      wordRepository: wordRepository,
      settingsRepository: settingsRepository,
    );
  });

  group('GameController Logic Tests', () {
    test('Initialization sets correct status and word', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      expect(gameController.status, GameStatus.playing);
      expect(gameController.targetWord.isNotEmpty, true);
      expect(gameController.wrongGuesses, 0);
      expect(gameController.hintsUsed, 0);
    });

    test('Correct guess adds to guessed letters but not wrong guesses', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      // Since it's random between 'TEST' and 'FLUTTER', we find a letter that exists
      final word = gameController.targetWord;
      final correctLetter = word[0];

      gameController.guessLetter(correctLetter);

      expect(gameController.guessedLetters.contains(correctLetter), true);
      expect(gameController.wrongGuesses, 0);
    });

    test('Wrong guess increments wrong guesses count', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      // Pick a letter definitely not in 'TEST' or 'FLUTTER'
      const wrongLetter = 'Z';

      gameController.guessLetter(wrongLetter);

      expect(gameController.guessedLetters.contains(wrongLetter), true);
      expect(gameController.wrongGuesses, 1);
    });

    test('Winning the game updates status to won and calculates score', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      final word = gameController.targetWord;
      
      // Guess all correct letters
      for (int i = 0; i < word.length; i++) {
        gameController.guessLetter(word[i]);
      }

      expect(gameController.status, GameStatus.won);
      expect(gameController.score > 0, true);
    });

    test('Losing the game updates status to lost', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      // Guess wrong letters until we reach max limit
      final wrongLetters = ['Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Q', 'W'];
      
      for (final letter in wrongLetters) {
        if (gameController.status == GameStatus.lost) break;
        gameController.guessLetter(letter);
      }

      expect(gameController.status, GameStatus.lost);
      expect(gameController.wrongGuesses, Difficulty.easy.maxWrongGuesses);
    });

    test('Using a hint reveals a letter and costs a life', () async {
      await gameController.initGame(WordCategory.all.first, Difficulty.easy);
      
      final initialLives = gameController.livesRemaining;
      
      gameController.useHint();

      expect(gameController.hintsUsed, 1);
      expect(gameController.livesRemaining, initialLives - AppConstants.hintLifeCost);
      expect(gameController.guessedLetters.isNotEmpty, true);
    });
  });
}
