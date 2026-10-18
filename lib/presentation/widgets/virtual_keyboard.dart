import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';

enum KeyState { unused, correct, wrong }

/// A single key on the virtual keyboard.
class KeyboardKey extends StatelessWidget {
  const KeyboardKey({
    super.key,
    required this.letter,
    required this.state,
    required this.onTap,
    this.size = AppConstants.keyboardKeySize,
    this.height,
  });

  final String letter;
  final KeyState state;
  final VoidCallback onTap;
  final double size;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final themeExt = context.theme.extension<HangmanThemeExtension>()!;
    
    Color bgColor;
    Color fgColor = Colors.white;

    switch (state) {
      case KeyState.correct:
        bgColor = themeExt.successColor;
        break;
      case KeyState.wrong:
        bgColor = themeExt.errorColor;
        break;
      case KeyState.unused:
        bgColor = themeExt.keyUnusedColor;
        break;
    }

    final bool isDisabled = state != KeyState.unused;
    final effectiveHeight = height ?? size;
    final double radius = (effectiveHeight * 0.16).clamp(4.0, AppConstants.keyboardKeyRadius);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(radius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: effectiveHeight,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 3,
                      )
                    ],
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: context.textTheme.titleMedium?.copyWith(
                color: fgColor,
                fontWeight: FontWeight.bold,
                fontSize: (effectiveHeight * 0.42).clamp(12.0, 18.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The A-Z virtual keyboard layout.
class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({
    super.key,
    required this.guessedLetters,
    required this.targetWord,
    required this.onKeyPressed,
  });

  final Set<String> guessedLetters;
  final String targetWord;
  final ValueChanged<String> onKeyPressed;

  static const List<String> _row1 = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
  static const List<String> _row2 = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'];
  static const List<String> _row3 = ['Z', 'X', 'C', 'V', 'B', 'N', 'M'];

  KeyState _getKeyState(String letter) {
    if (!guessedLetters.contains(letter)) return KeyState.unused;
    if (targetWord.contains(letter)) return KeyState.correct;
    return KeyState.wrong;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate key height adaptively based on available height
        double keyHeight = 44.0;
        if (constraints.maxHeight.isFinite && constraints.maxHeight > 0) {
          final maxPossible = (constraints.maxHeight - 16.0) / 3.0;
          keyHeight = maxPossible.clamp(26.0, 46.0);
        }

        final double verticalGap = (keyHeight * 0.15).clamp(3.0, 7.0);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRow(_row1, keyHeight, 0),
                  SizedBox(height: verticalGap),
                  _buildRow(_row2, keyHeight, 1),
                  SizedBox(height: verticalGap),
                  _buildRow(_row3, keyHeight, 3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(List<String> letters, double height, int spacerFlex) {
    return Row(
      children: [
        if (spacerFlex > 0) Spacer(flex: spacerFlex),
        ...letters.map((letter) {
          return Expanded(
            flex: 2,
            child: KeyboardKey(
              letter: letter,
              state: _getKeyState(letter),
              onTap: () => onKeyPressed(letter),
              height: height,
            ),
          );
        }),
        if (spacerFlex > 0) Spacer(flex: spacerFlex),
      ],
    );
  }
}
