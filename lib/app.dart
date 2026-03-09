import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/home/presentation/welcome_screen.dart';
import 'features/setup/presentation/setup_screen.dart';
import 'features/quiz/presentation/quiz_screen.dart';
import 'features/results/presentation/results_screen.dart';
// import 'features/leaderboard/presentation/leaderboard_screen.dart';

class TriviaApp extends StatelessWidget {
  const TriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafío Unizumi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        WelcomeScreen.routeName: (_) => const WelcomeScreen(),
        SetupScreen.routeName: (_) => const SetupScreen(),
        QuizScreen.routeName: (_) => const QuizScreen(),
        ResultsScreen.routeName: (_) => const ResultsScreen(),
        // Ranking oculto temporalmente hasta implementar persistencia real.
        // LeaderboardScreen.routeName: (_) => const LeaderboardScreen(),
      },
    );
  }
}
