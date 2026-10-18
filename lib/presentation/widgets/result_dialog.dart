import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

class ResultDialog extends StatelessWidget {
  const ResultDialog({
    super.key,
    required this.won,
    required this.word,
    required this.score,
    required this.isNewRecord,
    required this.onPlayAgain,
    required this.onChangeCategory,
    required this.onHome,
  });

  final bool won;
  final String word;
  final int score;
  final bool isNewRecord;
  final VoidCallback onPlayAgain;
  final VoidCallback onChangeCategory;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
      ),
      elevation: 8,
      backgroundColor: context.theme.cardTheme.color,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text(
              won ? AppStrings.youWin : AppStrings.youLose,
              style: context.textTheme.displayMedium?.copyWith(
                color: won 
                    ? (context.isDark ? const Color(0xFF66BB6A) : Colors.green)
                    : (context.isDark ? const Color(0xFFEF5350) : Colors.red),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.theWordWas,
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              word,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (won) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: context.isDark ? 0.15 : 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.isDark ? Colors.amber.shade400 : Colors.amber,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.scoreEarned,
                      style: context.textTheme.titleMedium,
                    ),
                    Text(
                      '+$score',
                      style: context.textTheme.displayMedium?.copyWith(
                        color: context.isDark ? Colors.amber.shade300 : Colors.amber.shade700,
                      ),
                    ),
                    if (isNewRecord)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          AppStrings.newRecord,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.isDark ? Colors.amber.shade200 : Colors.amber.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text(AppStrings.playAgain),
                onPressed: onPlayAgain,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.category),
                label: const Text(AppStrings.changeCategory),
                onPressed: onChangeCategory,
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              icon: const Icon(Icons.home),
              label: const Text(AppStrings.home),
              onPressed: onHome,
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
