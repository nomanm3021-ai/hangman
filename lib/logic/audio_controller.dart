import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../data/repositories/settings_repository.dart';

/// Controller for managing audio playback and haptics.
class AudioController extends ChangeNotifier {
  AudioController({required this.settingsRepository}) {
    _initAudio();
  }

  final SettingsRepository settingsRepository;
  final AudioPlayer _player = AudioPlayer();
  bool _canVibrate = false;

  Future<void> _initAudio() async {
    // Pre-cache sounds for lower latency
    await _player.setReleaseMode(ReleaseMode.stop);
    
    // HapticFeedback gracefully degrades if not supported
    _canVibrate = true;
  }

  bool get isSoundEnabled => settingsRepository.soundEnabled;
  bool get isVibrationEnabled => settingsRepository.vibrationEnabled;

  void toggleSound() {
    settingsRepository.setSoundEnabled(!isSoundEnabled);
    notifyListeners();
  }

  void toggleVibration() {
    settingsRepository.setVibrationEnabled(!isVibrationEnabled);
    notifyListeners();
  }

  Future<void> playCorrect() async => _playSound(AppConstants.audioCorrect);
  Future<void> playWrong() async {
    _playSound(AppConstants.audioWrong);
    _vibrateError();
  }
  Future<void> playWin() async => _playSound(AppConstants.audioWin);
  Future<void> playLose() async {
    _playSound(AppConstants.audioLose);
    _vibrateError();
  }
  Future<void> playTap() async => _playSound(AppConstants.audioButtonTap);
  Future<void> playHint() async => _playSound(AppConstants.audioHint);

  Future<void> _playSound(String assetPath) async {
    if (!isSoundEnabled) return;
    try {
      // Using a new player instance for overlapping sounds (like fast typing)
      final tempPlayer = AudioPlayer();
      await tempPlayer.play(AssetSource(assetPath));
      // Dispose temp player after a short delay
      Future.delayed(const Duration(seconds: 2), () => tempPlayer.dispose());
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  void _vibrateError() {
    if (isVibrationEnabled && _canVibrate) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
