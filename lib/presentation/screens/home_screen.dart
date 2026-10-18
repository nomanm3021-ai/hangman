import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/routes.dart';
import '../../core/utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 650;

            final logoWidget = Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/icons/icon-3d-512.png',
                    width: isWide ? 96 : 80,
                    height: isWide ? 96 : 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontSize: isWide ? 56 : 48,
                  ),
                ),
              ],
            );

            final buttonsWidget = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MenuButton(
                  title: AppStrings.play,
                  icon: Icons.play_arrow_rounded,
                  isPrimary: true,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.categorySelect),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  title: AppStrings.howToPlay,
                  icon: Icons.help_outline_rounded,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.howToPlay),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  title: AppStrings.statistics,
                  icon: Icons.bar_chart_rounded,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.statistics),
                ),
                const SizedBox(height: 14),
                _MenuButton(
                  title: AppStrings.settings,
                  icon: Icons.settings_rounded,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                ),
              ],
            );

            if (isWide) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: logoWidget),
                        const SizedBox(width: 32),
                        Expanded(child: buttonsWidget),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      logoWidget,
                      const SizedBox(height: 36),
                      buttonsWidget,
                    ],
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

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 26),
          label: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
