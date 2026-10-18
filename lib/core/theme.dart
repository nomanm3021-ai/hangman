import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines Material 3 light and dark themes with a chalkboard/playful aesthetic.
class AppTheme {
  AppTheme._();

  // ── Brand palette ──────────────────────────────────────────────────────────
  static const Color _primaryGreen = Color(0xFF4CAF7D);
  static const Color _accentAmber = Color(0xFFFFC107);
  static const Color _errorRed = Color(0xFFE53935);
  static const Color _successGreen = Color(0xFF43A047);
  static const Color _chalkWhite = Color(0xFFF5F5F0);
  static const Color _chalkboardDark = Color(0xFF1C2833);
  static const Color _chalkboardMid = Color(0xFF263238);
  static const Color _surfaceDark = Color(0xFF1E2A35);

  // Key-state colours used on the keyboard (shared by both themes)
  static const Color keyCorrect = Color(0xFF4CAF7D);
  static const Color keyWrong = Color(0xFFE53935);
  static const Color keyUnused = Color(0xFF607D8B); // blue-grey
  static const Color keyUnusedLight = Color(0xFFBDBDBD);

  // ── Text Styles ────────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Brightness brightness, Color textColor) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;

    final base = GoogleFonts.outfitTextTheme(baseTextTheme).apply(
      bodyColor: textColor,
      displayColor: textColor,
    );

    final caveatFont = GoogleFonts.caveat().fontFamily;

    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: caveatFont,
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 48,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: caveatFont,
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 36,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: textColor,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 22,
        letterSpacing: 0.5,
        color: textColor,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 17,
        color: textColor,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: textColor,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        color: textColor,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        color: textColor,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: textColor,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 15,
        letterSpacing: 1,
        color: textColor,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: textColor,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: textColor,
      ),
    );
  }

  // ── Light Theme ────────────────────────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryGreen,
      brightness: Brightness.light,
      primary: _primaryGreen,
      onPrimary: Colors.white,
      secondary: _accentAmber,
      onSecondary: Colors.black87,
      error: _errorRed,
      surface: _chalkWhite,
      onSurface: Colors.black87,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(Brightness.light, Colors.black87),
      scaffoldBackgroundColor: const Color(0xFFF0EDE6),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        shadowColor: Colors.black26,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryGreen,
          side: const BorderSide(color: _primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryGreen.withValues(alpha: 0.12),
        selectedColor: _primaryGreen,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      extensions: const [HangmanThemeExtension.light],
    );
  }

  // ── Dark (Chalkboard) Theme ────────────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryGreen,
      brightness: Brightness.dark,
      primary: _primaryGreen,
      onPrimary: Colors.white,
      secondary: _accentAmber,
      onSecondary: Colors.black87,
      error: _errorRed,
      surface: _chalkboardMid,
      onSurface: _chalkWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(Brightness.dark, _chalkWhite),
      scaffoldBackgroundColor: _chalkboardDark,
      appBarTheme: AppBarTheme(
        backgroundColor: _chalkboardMid,
        foregroundColor: _chalkWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _chalkWhite,
          letterSpacing: 1,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF2E3E4E),
            width: 1,
          ),
        ),
        color: _surfaceDark,
        shadowColor: Colors.black54,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: _chalkWhite,
        iconColor: _chalkWhite,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: _surfaceDark,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: _chalkWhite,
        ),
        contentTextStyle: GoogleFonts.outfit(
          fontSize: 16,
          color: _chalkWhite,
        ),
      ),
      iconTheme: const IconThemeData(
        color: _chalkWhite,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryGreen,
          side: const BorderSide(color: _primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryGreen.withValues(alpha: 0.2),
        selectedColor: _primaryGreen,
        labelStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: _chalkWhite,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      extensions: const [HangmanThemeExtension.dark],
    );
  }
}

/// Custom theme extension for Hangman-specific design tokens.
@immutable
class HangmanThemeExtension extends ThemeExtension<HangmanThemeExtension> {
  const HangmanThemeExtension({
    required this.hangmanColor,
    required this.gallowsColor,
    required this.wordLetterBorderColor,
    required this.wordLetterColor,
    required this.keyUnusedColor,
    required this.successColor,
    required this.errorColor,
    required this.hintColor,
    required this.cardGradientStart,
    required this.cardGradientEnd,
  });

  final Color hangmanColor;
  final Color gallowsColor;
  final Color wordLetterBorderColor;
  final Color wordLetterColor;
  final Color keyUnusedColor;
  final Color successColor;
  final Color errorColor;
  final Color hintColor;
  final Color cardGradientStart;
  final Color cardGradientEnd;

  static const light = HangmanThemeExtension(
    hangmanColor: Color(0xFF263238),
    gallowsColor: Color(0xFF5D4037),
    wordLetterBorderColor: Color(0xFF4CAF7D),
    wordLetterColor: Color(0xFF1A237E),
    keyUnusedColor: Color(0xFF90A4AE),
    successColor: AppTheme._successGreen,
    errorColor: AppTheme._errorRed,
    hintColor: Color(0xFFFF9800),
    cardGradientStart: Color(0xFFFFFFFF),
    cardGradientEnd: Color(0xFFF5F5F5),
  );

  static const dark = HangmanThemeExtension(
    hangmanColor: Color(0xFFF5F5F0),
    gallowsColor: Color(0xFFBCAAA4),
    wordLetterBorderColor: Color(0xFF4CAF7D),
    wordLetterColor: Color(0xFFF5F5F0),
    keyUnusedColor: Color(0xFF455A64),
    successColor: Color(0xFF66BB6A),
    errorColor: Color(0xFFEF5350),
    hintColor: Color(0xFFFFB74D),
    cardGradientStart: Color(0xFF1E2A35),
    cardGradientEnd: Color(0xFF263238),
  );

  @override
  HangmanThemeExtension copyWith({
    Color? hangmanColor,
    Color? gallowsColor,
    Color? wordLetterBorderColor,
    Color? wordLetterColor,
    Color? keyUnusedColor,
    Color? successColor,
    Color? errorColor,
    Color? hintColor,
    Color? cardGradientStart,
    Color? cardGradientEnd,
  }) {
    return HangmanThemeExtension(
      hangmanColor: hangmanColor ?? this.hangmanColor,
      gallowsColor: gallowsColor ?? this.gallowsColor,
      wordLetterBorderColor:
          wordLetterBorderColor ?? this.wordLetterBorderColor,
      wordLetterColor: wordLetterColor ?? this.wordLetterColor,
      keyUnusedColor: keyUnusedColor ?? this.keyUnusedColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      hintColor: hintColor ?? this.hintColor,
      cardGradientStart: cardGradientStart ?? this.cardGradientStart,
      cardGradientEnd: cardGradientEnd ?? this.cardGradientEnd,
    );
  }

  @override
  HangmanThemeExtension lerp(HangmanThemeExtension? other, double t) {
    if (other is! HangmanThemeExtension) return this;
    return HangmanThemeExtension(
      hangmanColor: Color.lerp(hangmanColor, other.hangmanColor, t)!,
      gallowsColor: Color.lerp(gallowsColor, other.gallowsColor, t)!,
      wordLetterBorderColor: Color.lerp(
        wordLetterBorderColor,
        other.wordLetterBorderColor,
        t,
      )!,
      wordLetterColor:
          Color.lerp(wordLetterColor, other.wordLetterColor, t)!,
      keyUnusedColor:
          Color.lerp(keyUnusedColor, other.keyUnusedColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      hintColor: Color.lerp(hintColor, other.hintColor, t)!,
      cardGradientStart:
          Color.lerp(cardGradientStart, other.cardGradientStart, t)!,
      cardGradientEnd:
          Color.lerp(cardGradientEnd, other.cardGradientEnd, t)!,
    );
  }
}
