import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/game_mode.dart';
import '../../../features/results/presentation/results_screen.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/animated_page.dart';
import '../domain/quiz_controller.dart';
import 'widgets/answer_button.dart';
import 'widgets/feedback_banner.dart';
import 'widgets/progress_section.dart';
import 'widgets/question_card.dart';
import 'widgets/quiz_top_bar.dart';
import 'widgets/timer_ring.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = '/quiz';

  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizController _controller;
  bool _initialized = false;
  bool _navigatedToResults = false;

  @override
  void initState() {
    super.initState();
    _controller = QuizController()..addListener(_handleControllerUpdates);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null ||
        args['category'] is! CategoryModel ||
        args['mode'] is! GameMode) {
      throw Exception(
        'QuizScreen requiere argumentos válidos: category (CategoryModel) y mode (GameMode).',
      );
    }

    _controller.initialize(
      category: args['category'] as CategoryModel,
      mode: args['mode'] as GameMode,
    );

    _initialized = true;
  }

  void _handleControllerUpdates() {
    if (!mounted) return;

    setState(() {});

    if (_controller.isFinished && !_navigatedToResults) {
      _navigatedToResults = true;

      final result = _controller.buildResult();

      Navigator.pushReplacementNamed(
        context,
        ResultsScreen.routeName,
        arguments: result,
      );
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerUpdates)
      ..dispose();
    super.dispose();
  }

  Color _feedbackOverlayColor(CategoryModel category) {
    if (_controller.feedbackMessage == null ||
        _controller.lastAnswerWasCorrect == null) {
      return Colors.transparent;
    }

    if (_controller.lastAnswerWasCorrect == true) {
      return AppColors.success.withOpacity(0.06);
    }

    return category.accentColor.withOpacity(0.03);
  }

  @override
  Widget build(BuildContext context) {
    final category = _controller.category;
    final question = _controller.currentQuestion;

    if (category == null || question == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AppScaffold(
      child: AnimatedPage(
        child: Stack(
          children: [
            Positioned(
              top: 110,
              right: -40,
              child: _CategoryGlow(
                color: category.accentColor,
                size: 170,
              ),
            ),
            Positioned(
              bottom: 120,
              left: -60,
              child: _CategoryGlow(
                color: category.accentColor.withOpacity(0.75),
                size: 200,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: _feedbackOverlayColor(category),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizTopBar(
                  category: category,
                  score: _controller.score,
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ProgressSection(
                        currentQuestion: _controller.currentIndex + 1,
                        totalQuestions: _controller.totalQuestions,
                        progress: _controller.progressValue,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    TimerRing(
                      secondsLeft: _controller.secondsLeft,
                      progress: _controller.timerProgress,
                      accentColor: category.accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 420),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );

                      final slide = Tween<Offset>(
                        begin: const Offset(0.08, 0),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      );

                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slide,
                          child: child,
                        ),
                      );
                    },
                    child: _QuestionStage(
                      key: ValueKey(_controller.currentQuestion?.id ?? 'empty'),
                      category: category,
                      question: question.question,
                      difficulty: question.difficulty,
                      options: _controller.currentOptions,
                      isAnswerLocked: _controller.isAnswerLocked,
                      correctAnswer: _controller.correctAnswer,
                      selectedAnswer: _controller.selectedAnswer,
                      onTapOption: (option) {
                        _controller.selectAnswer(option);
                      },
                    ),
                  ),
                ),
                if (_controller.feedbackMessage != null &&
                    _controller.lastAnswerWasCorrect != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  FeedbackBanner(
                    message: _controller.feedbackMessage!,
                    isCorrect: _controller.lastAnswerWasCorrect!,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionStage extends StatelessWidget {
  final CategoryModel category;
  final String question;
  final String? difficulty;
  final List<String> options;
  final bool isAnswerLocked;
  final String? correctAnswer;
  final String? selectedAnswer;
  final ValueChanged<String> onTapOption;

  const _QuestionStage({
    super.key,
    required this.category,
    required this.question,
    required this.difficulty,
    required this.options,
    required this.isAnswerLocked,
    required this.correctAnswer,
    required this.selectedAnswer,
    required this.onTapOption,
  });

  static const List<String> _labels = ['A', 'B', 'C', 'D'];

  AnswerVisualState _resolveAnswerState(String option) {
    if (!isAnswerLocked) {
      return AnswerVisualState.normal;
    }

    if (option == correctAnswer) {
      return AnswerVisualState.correct;
    }

    if (option == selectedAnswer && option != correctAnswer) {
      return AnswerVisualState.incorrect;
    }

    return AnswerVisualState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        QuestionCard(
          question: question,
          difficulty: difficulty,
          category: category,
        ),
        const SizedBox(height: AppSpacing.xl),
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final option = options[index];

              return AnswerButton(
                label: _labels[index % _labels.length],
                text: option,
                state: _resolveAnswerState(option),
                accentColor: category.accentColor,
                onTap: () {
                  onTapOption(option);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryGlow extends StatelessWidget {
  final Color color;
  final double size;

  const _CategoryGlow({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 80,
              spreadRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
