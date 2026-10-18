import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';

/// A custom painter that draws the hangman based on the number of wrong guesses.
class HangmanPainter extends CustomPainter {
  HangmanPainter({
    required this.wrongGuesses,
    required this.maxWrongGuesses,
    required this.themeExt,
  });

  final int wrongGuesses;
  final int maxWrongGuesses;
  final HangmanThemeExtension themeExt;

  @override
  void paint(Canvas canvas, Size size) {
    final gallowsPaint = Paint()
      ..color = themeExt.gallowsColor
      ..strokeWidth = AppConstants.hangmanStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final hangmanPaint = Paint()
      ..color = themeExt.hangmanColor
      ..strokeWidth = AppConstants.hangmanStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dimensions
    final double w = size.width;
    final double h = size.height;
    
    // 1. Draw Gallows (Always visible)
    // Base
    canvas.drawLine(Offset(w * 0.1, h * 0.95), Offset(w * 0.9, h * 0.95), gallowsPaint);
    // Pole
    canvas.drawLine(Offset(w * 0.3, h * 0.95), Offset(w * 0.3, h * 0.05), gallowsPaint);
    // Top beam
    canvas.drawLine(Offset(w * 0.3, h * 0.05), Offset(w * 0.7, h * 0.05), gallowsPaint);
    // Rope
    canvas.drawLine(Offset(w * 0.7, h * 0.05), Offset(w * 0.7, h * 0.2), gallowsPaint);

    // Stop if no wrong guesses
    if (wrongGuesses == 0) return;

    // Define parts based on max wrong guesses to scale the drawing steps
    // For classic 6 parts: 1: Head, 2: Body, 3: L-Arm, 4: R-Arm, 5: L-Leg, 6: R-Leg
    // We adjust threshold based on maxWrongGuesses (5, 6, or 8)
    
    // Normalize progress (0.0 to 1.0)
    final double progress = wrongGuesses / maxWrongGuesses;
    
    // Head (always first)
    if (progress >= (1 / maxWrongGuesses)) {
      canvas.drawCircle(Offset(w * 0.7, h * 0.28), h * 0.08, hangmanPaint);
    }
    
    // Body
    if (progress >= (2 / maxWrongGuesses)) {
      canvas.drawLine(Offset(w * 0.7, h * 0.36), Offset(w * 0.7, h * 0.65), hangmanPaint);
    }

    // Left Arm (or partial arms depending on difficulty)
    if (progress >= (3 / maxWrongGuesses)) {
      canvas.drawLine(Offset(w * 0.7, h * 0.45), Offset(w * 0.55, h * 0.55), hangmanPaint);
    }

    // Right Arm
    if (progress >= (4 / maxWrongGuesses)) {
      canvas.drawLine(Offset(w * 0.7, h * 0.45), Offset(w * 0.85, h * 0.55), hangmanPaint);
    }

    // Left Leg
    if (progress >= (5 / maxWrongGuesses)) {
      canvas.drawLine(Offset(w * 0.7, h * 0.65), Offset(w * 0.55, h * 0.85), hangmanPaint);
    }

    // Right Leg (Final state for Medium/Hard)
    if (progress >= (6 / maxWrongGuesses) && maxWrongGuesses <= 6) {
      canvas.drawLine(Offset(w * 0.7, h * 0.65), Offset(w * 0.85, h * 0.85), hangmanPaint);
    }
    
    // Extra details for Easy (8 max guesses)
    if (maxWrongGuesses == 8) {
      if (wrongGuesses >= 6) {
        canvas.drawLine(Offset(w * 0.7, h * 0.65), Offset(w * 0.85, h * 0.85), hangmanPaint); // R-Leg
      }
      if (wrongGuesses >= 7) {
        // Left Eye (X)
        canvas.drawLine(Offset(w * 0.67, h * 0.26), Offset(w * 0.69, h * 0.28), hangmanPaint);
        canvas.drawLine(Offset(w * 0.69, h * 0.26), Offset(w * 0.67, h * 0.28), hangmanPaint);
      }
      if (wrongGuesses >= 8) {
        // Right Eye (X)
        canvas.drawLine(Offset(w * 0.71, h * 0.26), Offset(w * 0.73, h * 0.28), hangmanPaint);
        canvas.drawLine(Offset(w * 0.73, h * 0.26), Offset(w * 0.71, h * 0.28), hangmanPaint);
        // Frown
        canvas.drawArc(
          Rect.fromCircle(center: Offset(w * 0.7, h * 0.33), radius: h * 0.03),
          3.14 + 0.5, 2.14, false, hangmanPaint,
        );
      }
    } else if (wrongGuesses == maxWrongGuesses) {
      // Dead eyes for Medium/Hard when maxed out
      final double eyeSize = h * 0.015;
      // L Eye
      canvas.drawLine(Offset(w * 0.67 - eyeSize, h * 0.26 - eyeSize), Offset(w * 0.67 + eyeSize, h * 0.26 + eyeSize), hangmanPaint);
      canvas.drawLine(Offset(w * 0.67 + eyeSize, h * 0.26 - eyeSize), Offset(w * 0.67 - eyeSize, h * 0.26 + eyeSize), hangmanPaint);
      // R Eye
      canvas.drawLine(Offset(w * 0.73 - eyeSize, h * 0.26 - eyeSize), Offset(w * 0.73 + eyeSize, h * 0.26 + eyeSize), hangmanPaint);
      canvas.drawLine(Offset(w * 0.73 + eyeSize, h * 0.26 - eyeSize), Offset(w * 0.73 - eyeSize, h * 0.26 + eyeSize), hangmanPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HangmanPainter oldDelegate) {
    return oldDelegate.wrongGuesses != wrongGuesses || 
           oldDelegate.maxWrongGuesses != maxWrongGuesses ||
           oldDelegate.themeExt != themeExt;
  }
}
