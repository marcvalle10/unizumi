import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/animated_page.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../home/presentation/welcome_screen.dart';
//import '../../quiz/domain/quiz_controller.dart';
import '../../quiz/presentation/quiz_screen.dart';
import 'widgets/result_actions.dart';
import 'widgets/score_hero.dart';
import 'widgets/stats_row.dart';
import '../../../data/models/quiz_result_model.dart';

class ResultsScreen extends StatelessWidget {
  static const routeName = '/results';

  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! QuizResultModel) {
      throw Exception(
        'ResultsScreen requiere un QuizResultModel como argumento.',
      );
    }

    final result = args;

    return AppScaffold(
      child: AnimatedPage(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    ScoreHero(
                      score: result.correctAnswers,
                      total: result.totalQuestions,
                      percentage: result.percentage,
                      message: result.performanceMessage,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    StatsRow(
                      correct: result.correctAnswers,
                      incorrect: result.incorrectAnswers,
                      averageTime: result.averageResponseTime,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    GlassCard(
                      glowColor: AppColors.purpleGlow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: AppColors.accentGold,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recomendación de estudio',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  result.studyRecommendation,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ResultActions(
              onPlayAgain: () {
                Navigator.pushReplacementNamed(
                  context,
                  QuizScreen.routeName,
                  arguments: {
                    'category': result.category,
                    'mode': result.mode,
                  },
                );
              },
              onGoHome: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  WelcomeScreen.routeName,
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
