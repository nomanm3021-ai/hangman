import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hangman/presentation/widgets/virtual_keyboard.dart';
import 'package:hangman/core/theme.dart';

void main() {
  testWidgets('VirtualKeyboard renders keys A-Z', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: VirtualKeyboard(
            guessedLetters: const <String>{},
            targetWord: 'TEST',
            onKeyPressed: (letter) {},
          ),
        ),
      ),
    );

    // Verify some specific letters are present
    expect(find.text('A'), findsOneWidget);
    expect(find.text('Z'), findsOneWidget);
    expect(find.text('Q'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);

    // Tap a key and verify it can be found
    await tester.tap(find.text('A'));
    await tester.pump();
  });
}
