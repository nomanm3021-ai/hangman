import 'dart:math';
import 'package:flutter/material.dart';

/// Miscellaneous utility functions.
class AppUtils {
  AppUtils._();

  static final Random _random = Random();

  /// Returns a random element from [list], or null if empty.
  static T? randomElement<T>(List<T> list) {
    if (list.isEmpty) return null;
    return list[_random.nextInt(list.length)];
  }

  /// Formats a double percentage to one decimal place with a % sign.
  static String formatPercent(double value) =>
      '${(value * 100).toStringAsFixed(1)}%';

  /// Returns a colour interpolated between [from] and [to] based on [progress] (0–1).
  static Color lerpColor(Color from, Color to, double progress) =>
      Color.lerp(from, to, progress.clamp(0.0, 1.0))!;

  /// Converts a category key such as "animals" to a display emoji.
  static String categoryEmoji(String categoryId) {
    const map = {
      'animals': '🐾',
      'countries': '🌍',
      'food': '🍕',
      'sports': '⚽',
      'technology': '💻',
      'movies': '🎬',
    };
    return map[categoryId] ?? '❓';
  }

  /// Converts difficulty index to a label.
  static String difficultyLabel(int index) =>
      ['Easy', 'Medium', 'Hard'][index.clamp(0, 2)];

  /// Returns the max wrong guesses allowed for [difficultyIndex].
  static int maxWrongForDifficulty(int difficultyIndex) =>
      [8, 6, 5][difficultyIndex.clamp(0, 2)];

  /// Returns max hints for [difficultyIndex].
  static int maxHintsForDifficulty(int difficultyIndex) =>
      [3, 2, 1][difficultyIndex.clamp(0, 2)];

  /// Returns base score for [difficultyIndex].
  static int baseScoreForDifficulty(int difficultyIndex) =>
      [100, 200, 350][difficultyIndex.clamp(0, 2)];

  /// Pads a number with a leading zero if < 10.
  static String twoDigits(int n) => n.toString().padLeft(2, '0');
}

/// Extension to simplify Theme access.
extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
