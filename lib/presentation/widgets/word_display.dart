import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';

/// Displays the target word, showing guessed letters and underscores for unguessed ones.
class WordDisplay extends StatelessWidget {
  const WordDisplay({
    super.key,
    required this.word,
    required this.guessedLetters,
    this.isGameOver = false,
  });

  final String word;
  final Set<String> guessedLetters;
  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    // Split word into lines if it has spaces
    final words = word.split(' ');

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16.0, // Space between words
      runSpacing: 10.0,
      children: words.map((w) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: w.split('').map((char) {
              final isGuessed = guessedLetters.contains(char);
              final isRevealedAtEnd = isGameOver && !isGuessed;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: _LetterBox(
                  letter: char,
                  isRevealed: isGuessed || isRevealedAtEnd,
                  isMissed: isRevealedAtEnd,
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _LetterBox extends StatelessWidget {
  const _LetterBox({
    required this.letter,
    required this.isRevealed,
    required this.isMissed,
  });

  final String letter;
  final bool isRevealed;
  final bool isMissed;

  @override
  Widget build(BuildContext context) {
    final themeExt = context.theme.extension<HangmanThemeExtension>()!;
    
    // For non-alphabetical characters (like hyphens), just show them without a box
    if (!RegExp(r'[A-Z]').hasMatch(letter)) {
      return Container(
        height: AppConstants.wordLetterHeight,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          letter,
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: 28,
          ),
        ),
      );
    }

    return Container(
      width: AppConstants.wordLetterWidth,
      height: AppConstants.wordLetterHeight,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: themeExt.wordLetterBorderColor,
            width: 3.0,
          ),
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedOpacity(
        opacity: isRevealed ? 1.0 : 0.0,
        duration: const Duration(milliseconds: AppConstants.letterFlipDuration),
        child: Text(
          letter,
          style: context.textTheme.displayMedium?.copyWith(
            fontSize: 28,
            color: isMissed ? themeExt.errorColor : themeExt.wordLetterColor,
          ),
        ),
      ),
    );
  }
}
