import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';

import '../widgets/responsive_container.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.howToPlayTitle),
      ),
      body: ResponsiveContainer(
        maxWidth: 700,
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: AppStrings.howToPlaySteps.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primary,
                    foregroundColor: context.colorScheme.onPrimary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    AppStrings.howToPlaySteps[index],
                    style: context.textTheme.bodyLarge?.copyWith(
                      height: 1.4,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
