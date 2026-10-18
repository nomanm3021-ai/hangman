import 'dart:math';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../data/models/word_category.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/word_repository.dart';

enum GameStatus { loading, playing, won, lost }

class GameController extends ChangeNotifier {
  GameController({
    required this.wordRepository,
    required this.settingsRepository,
  });

  final WordRepository wordRepository;
  final SettingsRepository settingsRepository;

  // Game config
  WordCategory? _category;
  Difficulty _difficulty = Difficulty.medium;

  // Game state
  GameStatus _status = GameStatus.loading;
  String _targetWord = '';
  final Set<String> _guessedLetters = {};
  int _wrongGuesses = 0;
  int _hintsUsed = 0;
  int _score = 0;
  bool _isNewRecord = false;
  
  // List of words to avoid immediate repetition
  List<WordEntry> _availableWords = [];

  // Getters
  GameStatus get status => _status;
  String get targetWord => _targetWord;
  Set<String> get guessedLetters => _guessedLetters;
  int get wrongGuesses => _wrongGuesses;
  int get hintsUsed => _hintsUsed;
  int get score => _score;
  bool get isNewRecord => _isNewRecord;
  WordCategory? get category => _category;
  Difficulty get difficulty => _difficulty;

  int get maxWrongGuesses => _difficulty.maxWrongGuesses;
  int get maxHints => _difficulty.maxHints;
  int get livesRemaining => maxWrongGuesses - _wrongGuesses;
  int get hintsRemaining => maxHints - _hintsUsed;
  
  bool get canUseHint => hintsRemaining > 0 && livesRemaining > AppConstants.hintLifeCost;

  /// Initializes a new game with [category] and [difficulty].
  Future<void> initGame(WordCategory category, Difficulty difficulty) async {
    _category = category;
    _difficulty = difficulty;
    _status = GameStatus.loading;
    notifyListeners();

    // Load words if we don't have available words for this config
    final allWords = await wordRepository.getWordsForCategory(category.id);
    _availableWords = wordRepository.filterWordsByDifficulty(allWords, difficulty);
    
    if (_availableWords.isEmpty) {
      // Fallback: use all words if filtering removed everything
      _availableWords = List.from(allWords);
    }
    
    // If still empty, use a default fallback (shouldn't happen with our JSON)
    if (_availableWords.isEmpty) {
      _availableWords = [const WordEntry(word: 'FLUTTER')];
    }
    
    _startRound();
  }

  void _startRound() {
    _guessedLetters.clear();
    _wrongGuesses = 0;
    _hintsUsed = 0;
    _score = 0;
    _isNewRecord = false;

    // Pick a random word
    final wordEntry = _availableWords.removeAt(Random().nextInt(_availableWords.length));
    _targetWord = wordEntry.word.toUpperCase();
    
    // Reveal spaces and punctuation by default
    for (int i = 0; i < _targetWord.length; i++) {
      final char = _targetWord[i];
      if (char == ' ' || char == '-') {
        _guessedLetters.add(char);
      }
    }

    _status = GameStatus.playing;
    notifyListeners();
  }

  /// Processes a player's letter guess.
  void guessLetter(String letter) {
    if (_status != GameStatus.playing) return;
    final upperLetter = letter.toUpperCase();
    
    if (_guessedLetters.contains(upperLetter)) return;

    _guessedLetters.add(upperLetter);

    if (!_targetWord.contains(upperLetter)) {
      _wrongGuesses++;
      if (_wrongGuesses >= maxWrongGuesses) {
        _endGame(won: false);
      } else {
        notifyListeners();
      }
    } else {
      // Check win condition
      if (_checkWin()) {
        _endGame(won: true);
      } else {
        notifyListeners();
      }
    }
  }

  /// Uses a hint if available.
  void useHint() {
    if (!canUseHint || _status != GameStatus.playing) return;

    // Find unrevealed letters
    final unrevealed = <String>[];
    for (int i = 0; i < _targetWord.length; i++) {
      final char = _targetWord[i];
      if (!_guessedLetters.contains(char)) {
        unrevealed.add(char);
      }
    }

    if (unrevealed.isNotEmpty) {
      final hintLetter = unrevealed[Random().nextInt(unrevealed.length)];
      _hintsUsed++;
      _wrongGuesses += AppConstants.hintLifeCost; // Cost of hint
      
      _guessedLetters.add(hintLetter);

      if (_checkWin()) {
        _endGame(won: true);
      } else if (_wrongGuesses >= maxWrongGuesses) {
        // Edge case: hint used last life (prevented by canUseHint, but safe)
        _endGame(won: false);
      } else {
        notifyListeners();
      }
    }
  }

  bool _checkWin() {
    for (int i = 0; i < _targetWord.length; i++) {
      if (!_guessedLetters.contains(_targetWord[i])) {
        return false;
      }
    }
    return true;
  }

  Future<void> _endGame({required bool won}) async {
    _status = won ? GameStatus.won : GameStatus.lost;
    
    if (won) {
      _calculateScore();
    } else {
      _score = 0;
    }

    final oldBestStreak = settingsRepository.bestStreak;
    await settingsRepository.recordGameResult(won: won, score: _score);
    final newBestStreak = settingsRepository.bestStreak;
    
    if (won && newBestStreak > oldBestStreak) {
      _isNewRecord = true;
    }

    notifyListeners();
  }

  void _calculateScore() {
    int baseScore = _difficulty.baseScore;
    int lifeBonus = livesRemaining * AppConstants.bonusPerRemainingLife;
    int hintPenalty = _hintsUsed * AppConstants.hintPenalty;
    
    // Add streak bonus based on *current* streak before this win is recorded
    int currentStreak = settingsRepository.currentStreak;
    double streakMultiplier = 1.0 + (currentStreak * AppConstants.streakMultiplierStep);
    
    double total = (baseScore + lifeBonus - hintPenalty) * streakMultiplier;
    _score = max(0, total.toInt());
  }

  /// Restarts the game with the same category and difficulty.
  void restartGame() {
    if (_availableWords.isEmpty && _category != null) {
      // Reload words if we ran out
      initGame(_category!, _difficulty);
    } else {
      _startRound();
    }
  }
}
