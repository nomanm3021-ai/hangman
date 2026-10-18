import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants.dart';
import 'core/routes.dart';
import 'core/theme.dart';
import 'data/repositories/settings_repository.dart';
import 'data/repositories/word_repository.dart';
import 'logic/audio_controller.dart';
import 'logic/game_controller.dart';

import 'presentation/screens/category_screen.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/how_to_play_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Support all orientations for responsive tablets, foldables, and landscape
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  final prefs = await SharedPreferences.getInstance();
  final settingsRepo = SettingsRepository(prefs);
  final wordRepo = WordRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsRepository>.value(value: settingsRepo),
        Provider<WordRepository>.value(value: wordRepo),
        ChangeNotifierProvider<AudioController>(
          create: (_) => AudioController(settingsRepository: settingsRepo),
        ),
        ChangeNotifierProvider<GameController>(
          create: (_) => GameController(
            wordRepository: wordRepo,
            settingsRepository: settingsRepo,
          ),
        ),
      ],
      child: const HangmanApp(),
    ),
  );
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepo = context.watch<SettingsRepository>();
    
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settingsRepo.themeMode,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.categorySelect: (context) => const CategoryScreen(),
        AppRoutes.game: (context) => const GameScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
        AppRoutes.statistics: (context) => const StatisticsScreen(),
        AppRoutes.howToPlay: (context) => const HowToPlayScreen(),
      },
    );
  }
}
