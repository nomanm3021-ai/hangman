import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../../core/routes.dart';
import '../../logic/game_controller.dart';
import '../../logic/audio_controller.dart';
import '../widgets/hangman_painter.dart';
import '../widgets/virtual_keyboard.dart';
import '../widgets/word_display.dart';
import '../widgets/result_dialog.dart';
import '../widgets/responsive_container.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppConstants.shakeAnimDuration),
    );

    // Listen to game status changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameController>().addListener(_onGameStateChanged);
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    final game = context.read<GameController>();
    final audio = context.read<AudioController>();

    if (game.status == GameStatus.won) {
      audio.playWin();
      _confettiController.play();
      _showResultDialog(game);
    } else if (game.status == GameStatus.lost) {
      audio.playLose();
      _showResultDialog(game);
    }
  }

  void _showResultDialog(GameController game) {
    Future.delayed(const Duration(milliseconds: AppConstants.resultDialogDelay), () {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ResultDialog(
          won: game.status == GameStatus.won,
          word: game.targetWord,
          score: game.score,
          isNewRecord: game.isNewRecord,
          onPlayAgain: () {
            Navigator.of(context).pop();
            game.restartGame();
          },
          onChangeCategory: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, AppRoutes.categorySelect);
          },
          onHome: () {
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          },
        ),
      );
    });
  }

  void _handleKeyPress(String letter) {
    final game = context.read<GameController>();
    final audio = context.read<AudioController>();

    final wasWrongBefore = game.wrongGuesses;
    game.guessLetter(letter);

    if (game.wrongGuesses > wasWrongBefore) {
      audio.playWrong();
      _shakeController.forward(from: 0.0);
    } else {
      audio.playCorrect();
    }
  }

  void _handleHint() {
    final game = context.read<GameController>();
    final audio = context.read<AudioController>();

    if (game.canUseHint) {
      audio.playHint();
      game.useHint();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GameController>(
          builder: (context, game, child) {
            return Text('${game.category?.displayName ?? ""} - ${game.difficulty.label}');
          },
        ),
        actions: [
          Consumer<GameController>(
            builder: (context, game, child) {
              return IconButton(
                icon: const Icon(Icons.lightbulb),
                onPressed: game.canUseHint ? _handleHint : null,
                tooltip: 'Hint (Costs ${AppConstants.hintLifeCost} life)',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Consumer<GameController>(
              builder: (context, game, child) {
                if (game.status == GameStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final hangmanDrawing = AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        final dx = _shakeController.isAnimating 
                          ? (4 * (0.5 - (0.5 - _shakeController.value).abs()) * 10 * math.sin(_shakeController.value * 3.14))
                          : 0.0;
                        return Transform.translate(
                          offset: Offset(dx, 0),
                          child: child,
                        );
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: 280,
                              height: 280,
                              child: CustomPaint(
                                painter: HangmanPainter(
                                  wrongGuesses: game.wrongGuesses,
                                  maxWrongGuesses: game.maxWrongGuesses,
                                  themeExt: context.theme.extension<HangmanThemeExtension>()!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                    final wordDisplay = Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: WordDisplay(
                            word: game.targetWord,
                            guessedLetters: game.guessedLetters,
                            isGameOver: game.status == GameStatus.lost,
                          ),
                        ),
                      ),
                    );

                    final virtualKeyboard = Center(
                      child: VirtualKeyboard(
                        guessedLetters: game.guessedLetters,
                        targetWord: game.targetWord,
                        onKeyPressed: _handleKeyPress,
                      ),
                    );

                    if (constraints.maxWidth > 600) {
                      return ResponsiveContainer(
                        maxWidth: 900,
                        child: Column(
                          children: [
                            _buildStatsBar(game),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: hangmanDrawing),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Expanded(flex: 2, child: wordDisplay),
                                        Expanded(flex: 3, child: virtualKeyboard),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ResponsiveContainer(
                      maxWidth: 500,
                      child: Column(
                        children: [
                          _buildStatsBar(game),
                          Expanded(flex: 4, child: hangmanDrawing),
                          Expanded(flex: 2, child: wordDisplay),
                          Expanded(flex: 3, child: virtualKeyboard),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(GameController game) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.theme.extension<HangmanThemeExtension>()!.cardGradientStart.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 20),
              const SizedBox(width: 4),
              Text(
                '${game.livesRemaining}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${game.score}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
