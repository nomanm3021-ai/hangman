import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants.dart';
import '../../logic/audio_controller.dart';
import '../../data/repositories/settings_repository.dart';

import '../widgets/responsive_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchPrivacyUrl(BuildContext context) async {
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open browser. Please check your internet connection.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open privacy policy link.'),
          ),
        );
      }
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.privacy_tip_rounded,
                color: Theme.of(ctx).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.privacyPolicy,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${AppConstants.appName} • ${AppConstants.companyName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPolicyItem(
                  ctx,
                  Icons.person_off_outlined,
                  'Zero Personal Data Collection',
                  'We do not collect, request, or share any personal identifiable information (names, emails, contacts, or locations).',
                ),
                const SizedBox(height: 12),
                _buildPolicyItem(
                  ctx,
                  Icons.save_outlined,
                  '100% Local Storage',
                  'All game progress, scores, statistics, and sound preferences stay strictly on your physical device.',
                ),
                const SizedBox(height: 12),
                _buildPolicyItem(
                  ctx,
                  Icons.child_care_rounded,
                  'Child & Family Safe (COPPA)',
                  'Hangman is family-friendly and fully complies with child privacy protection regulations.',
                ),
                const SizedBox(height: 12),
                _buildPolicyItem(
                  ctx,
                  Icons.track_changes_outlined,
                  'No Ad Tracking or Profiling',
                  'The application contains zero advertising networks, tracking pixels, or third-party behavioral profiling.',
                ),
                const SizedBox(height: 12),
                _buildPolicyItem(
                  ctx,
                  Icons.email_outlined,
                  'Developer Contact',
                  '${AppConstants.companyName}\n${AppConstants.developerEmail}',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _launchPrivacyUrl(context);
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: const Text('Online Policy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Widget _buildPolicyItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[700],
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioController>();
    final settingsRepo = context.watch<SettingsRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ResponsiveContainer(
        maxWidth: 800,
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text(AppStrings.sound),
              secondary: const Icon(Icons.volume_up),
              value: audio.isSoundEnabled,
              onChanged: (val) => audio.toggleSound(),
            ),
            SwitchListTile(
              title: const Text(AppStrings.vibration),
              secondary: const Icon(Icons.vibration),
              value: audio.isVibrationEnabled,
              onChanged: (val) => audio.toggleVibration(),
            ),
            ListTile(
              title: const Text(AppStrings.theme),
              leading: const Icon(Icons.palette),
              trailing: DropdownButton<ThemeMode>(
                value: settingsRepo.themeMode,
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E2A35)
                    : Colors.white,
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    settingsRepo.setThemeMode(newMode);
                  }
                },
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text(AppStrings.systemTheme)),
                  DropdownMenuItem(value: ThemeMode.light, child: Text(AppStrings.lightTheme)),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text(AppStrings.darkTheme)),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text(AppStrings.privacyPolicy),
              subtitle: const Text(AppStrings.privacyPolicySubtitle),
              leading: const Icon(Icons.privacy_tip_outlined),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => _showPrivacyPolicy(context),
            ),
            const Divider(),
            ListTile(
              title: const Text(AppStrings.resetStats, style: TextStyle(color: Colors.red)),
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Statistics?'),
                    content: const Text(AppStrings.resetConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(AppStrings.confirm, style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await settingsRepo.resetStatistics();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Statistics reset successfully.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
