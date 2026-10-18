import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';
import '../../core/utils.dart';
import '../../data/models/word_category.dart';
import '../../logic/game_controller.dart';

import '../widgets/responsive_container.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Difficulty _selectedDifficulty = Difficulty.medium;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categories),
      ),
      body: ResponsiveContainer(
        maxWidth: 1000,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _DifficultySelector(
                selected: _selectedDifficulty,
                onChanged: (diff) => setState(() => _selectedDifficulty = diff),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                itemCount: WordCategory.all.length,
                itemBuilder: (context, index) {
                  final category = WordCategory.all[index];
                  return _CategoryCard(
                    category: category,
                    onTap: () {
                      context.read<GameController>().initGame(category, _selectedDifficulty);
                      Navigator.pushReplacementNamed(context, AppRoutes.game);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  const _DifficultySelector({
    required this.selected,
    required this.onChanged,
  });

  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Text('Select Difficulty', style: context.textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: Difficulty.values.map((diff) {
                final isSelected = selected == diff;
                return ChoiceChip(
                  label: Text(diff.label),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) onChanged(diff);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final WordCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              category.displayName,
              style: context.textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
