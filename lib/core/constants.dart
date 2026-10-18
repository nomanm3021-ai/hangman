/// App-wide constants. All magic numbers and strings live here.
library constants;

class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'Hangman';
  static const String appVersion = '1.0.0';

  // Game rules
  static const int maxWrongGuessesEasy = 8;
  static const int maxWrongGuessesM = 6;
  static const int maxWrongGuessesHard = 5;

  static const int maxHintsEasy = 3;
  static const int maxHintsMedium = 2;
  static const int maxHintsHard = 1;

  static const int hintLifeCost = 1; // lives subtracted per hint used

  // Scoring
  static const int baseScoreEasy = 100;
  static const int baseScoreMedium = 200;
  static const int baseScoreHard = 350;
  static const int bonusPerRemainingLife = 20;
  static const int hintPenalty = 30;
  static const double streakMultiplierStep = 0.1; // +10% per consecutive win

  // Animation durations (ms)
  static const int hangmanStrokeDuration = 400;
  static const int letterFlipDuration = 300;
  static const int shakeAnimDuration = 600;
  static const int splashDuration = 2500;
  static const int resultDialogDelay = 800;

  // Sizes
  static const double keyboardKeySize = 40.0;
  static const double keyboardKeyRadius = 8.0;
  static const double hangmanStrokeWidth = 4.0;
  static const double wordLetterWidth = 32.0;
  static const double wordLetterHeight = 48.0;
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double scaffoldPadding = 16.0;

  // SharedPreferences keys
  static const String prefSoundEnabled = 'sound_enabled';
  static const String prefVibrationEnabled = 'vibration_enabled';
  static const String prefThemeMode = 'theme_mode';
  static const String prefGamesPlayed = 'games_played';
  static const String prefGamesWon = 'games_won';
  static const String prefGamesLost = 'games_lost';
  static const String prefCurrentStreak = 'current_streak';
  static const String prefBestStreak = 'best_streak';
  static const String prefTotalScore = 'total_score';
  static const String prefUsedWords = 'used_words';

  // Asset paths
  static const String audioCorrect = 'audio/correct.mp3';
  static const String audioWrong = 'audio/wrong.mp3';
  static const String audioWin = 'audio/win.mp3';
  static const String audioLose = 'audio/lose.mp3';
  static const String audioButtonTap = 'audio/button_tap.mp3';
  static const String audioHint = 'audio/hint.mp3';
}

class AppStrings {
  AppStrings._();

  // Navigation / buttons
  static const String play = 'Play';
  static const String categories = 'Categories';
  static const String howToPlay = 'How to Play';
  static const String settings = 'Settings';
  static const String statistics = 'Statistics';
  static const String back = 'Back';
  static const String playAgain = 'Play Again';
  static const String changeCategory = 'Change Category';
  static const String home = 'Home';
  static const String hint = 'Hint';
  static const String pause = 'Pause';
  static const String resume = 'Resume';
  static const String restart = 'Restart';
  static const String quit = 'Quit';
  static const String select = 'Select';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';
  static const String resetStats = 'Reset Statistics';
  static const String resetConfirm = 'Are you sure you want to reset all statistics?';

  // Difficulties
  static const String easy = 'Easy';
  static const String medium = 'Medium';
  static const String hard = 'Hard';

  // Categories
  static const String animals = 'Animals';
  static const String countries = 'Countries';
  static const String food = 'Food';
  static const String sports = 'Sports';
  static const String technology = 'Technology';
  static const String movies = 'Movies';

  // Game screen labels
  static const String category = 'Category';
  static const String livesRemaining = 'Lives';
  static const String wrongGuesses = 'Wrong';
  static const String hintsLeft = 'Hints';

  // Results
  static const String youWin = '🎉 You Win!';
  static const String youLose = '😞 Game Over';
  static const String theWordWas = 'The word was:';
  static const String scoreEarned = 'Score:';
  static const String newRecord = '🏆 New Record!';

  // Statistics labels
  static const String gamesPlayed = 'Games Played';
  static const String wins = 'Wins';
  static const String losses = 'Losses';
  static const String winRate = 'Win Rate';
  static const String currentStreak = 'Current Streak';
  static const String bestStreak = 'Best Streak';
  static const String totalScore = 'Total Score';

  // Settings labels
  static const String sound = 'Sound Effects';
  static const String vibration = 'Vibration';
  static const String theme = 'Theme';
  static const String systemTheme = 'System';
  static const String lightTheme = 'Light';
  static const String darkTheme = 'Dark';

  // How to play
  static const String howToPlayTitle = 'How to Play';
  static const List<String> howToPlaySteps = [
    'A secret word is chosen from the selected category.',
    'Guess letters one at a time using the on-screen keyboard.',
    'Correct letters are revealed in the word.',
    'Wrong guesses draw the hangman — 6 mistakes and it\'s over!',
    'Use Hints to reveal a letter (costs 1 life).',
    'Win by guessing the word before the hangman is complete!',
  ];

  // Pause dialog
  static const String gamePaused = 'Game Paused';
}
