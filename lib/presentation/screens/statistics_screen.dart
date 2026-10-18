import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/utils.dart';
import '../../data/repositories/settings_repository.dart';

import '../widgets/responsive_container.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.read<SettingsRepository>();
    
    final int played = stats.gamesPlayed;
    final int won = stats.gamesWon;
    final int lost = stats.gamesLost;
    final double winRate = played > 0 ? won / played : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statistics),
      ),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              sliver: SliverToBoxAdapter(
                child: _StatCard(
                  title: AppStrings.totalScore,
                  value: stats.totalScore.toString(),
                  icon: Icons.stars,
                  color: Colors.amber,
                  isLarge: true,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.35,
                ),
                delegate: SliverChildListDelegate([
                  _StatCard(
                    title: AppStrings.gamesPlayed,
                    value: played.toString(),
                    icon: Icons.tag,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: AppStrings.winRate,
                    value: AppUtils.formatPercent(winRate),
                    icon: Icons.pie_chart,
                    color: Colors.purple,
                  ),
                  _StatCard(
                    title: AppStrings.wins,
                    value: won.toString(),
                    icon: Icons.emoji_events,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: AppStrings.losses,
                    value: lost.toString(),
                    icon: Icons.cancel,
                    color: Colors.red,
                  ),
                  _StatCard(
                    title: AppStrings.currentStreak,
                    value: stats.currentStreak.toString(),
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: AppStrings.bestStreak,
                    value: stats.bestStreak.toString(),
                    icon: Icons.military_tech,
                    color: Colors.teal,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isLarge = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isLarge ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: isLarge ? 48 : 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: isLarge 
                  ? context.textTheme.displayMedium?.copyWith(color: color)
                  : context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.isDark ? const Color(0xFFB0BEC5) : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
