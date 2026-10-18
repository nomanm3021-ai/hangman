import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../logic/audio_controller.dart';
import '../../data/repositories/settings_repository.dart';

import '../widgets/responsive_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
