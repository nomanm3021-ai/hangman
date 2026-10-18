import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

/// Repository for managing persistent settings and statistics.
class SettingsRepository with ChangeNotifier {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  // --- Settings ---

  bool get soundEnabled => _prefs.getBool(AppConstants.prefSoundEnabled) ?? true;
  Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefSoundEnabled, value);
    notifyListeners();
  }

  bool get vibrationEnabled => _prefs.getBool(AppConstants.prefVibrationEnabled) ?? true;
  Future<void> setVibrationEnabled(bool value) async {
    await _prefs.setBool(AppConstants.prefVibrationEnabled, value);
    notifyListeners();
  }

  ThemeMode get themeMode {
    final int? index = _prefs.getInt(AppConstants.prefThemeMode);
    if (index == null) return ThemeMode.system;
    return ThemeMode.values[index];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(AppConstants.prefThemeMode, mode.index);
    notifyListeners();
  }

  // --- Statistics ---

  int get gamesPlayed => _prefs.getInt(AppConstants.prefGamesPlayed) ?? 0;
  int get gamesWon => _prefs.getInt(AppConstants.prefGamesWon) ?? 0;
  int get gamesLost => _prefs.getInt(AppConstants.prefGamesLost) ?? 0;
  int get currentStreak => _prefs.getInt(AppConstants.prefCurrentStreak) ?? 0;
  int get bestStreak => _prefs.getInt(AppConstants.prefBestStreak) ?? 0;
  int get totalScore => _prefs.getInt(AppConstants.prefTotalScore) ?? 0;

  Future<void> recordGameResult({required bool won, required int score}) async {
    await _prefs.setInt(AppConstants.prefGamesPlayed, gamesPlayed + 1);
    await _prefs.setInt(AppConstants.prefTotalScore, totalScore + score);

    if (won) {
      await _prefs.setInt(AppConstants.prefGamesWon, gamesWon + 1);
      final newStreak = currentStreak + 1;
      await _prefs.setInt(AppConstants.prefCurrentStreak, newStreak);
      if (newStreak > bestStreak) {
        await _prefs.setInt(AppConstants.prefBestStreak, newStreak);
      }
    } else {
      await _prefs.setInt(AppConstants.prefGamesLost, gamesLost + 1);
      await _prefs.setInt(AppConstants.prefCurrentStreak, 0);
    }
    notifyListeners();
  }

  Future<void> resetStatistics() async {
    await _prefs.remove(AppConstants.prefGamesPlayed);
    await _prefs.remove(AppConstants.prefGamesWon);
    await _prefs.remove(AppConstants.prefGamesLost);
    await _prefs.remove(AppConstants.prefCurrentStreak);
    await _prefs.remove(AppConstants.prefBestStreak);
    await _prefs.remove(AppConstants.prefTotalScore);
    notifyListeners();
  }
}
