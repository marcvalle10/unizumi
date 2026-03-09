import 'category_model.dart';
import 'game_mode.dart';

class QuizResultModel {
  final CategoryModel category;
  final GameMode mode;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int unansweredAnswers;
  final int score;
  final int percentage;
  final double averageResponseTime;
  final String performanceMessage;
  final String studyRecommendation;

  const QuizResultModel({
    required this.category,
    required this.mode,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.unansweredAnswers,
    required this.score,
    required this.percentage,
    required this.averageResponseTime,
    required this.performanceMessage,
    required this.studyRecommendation,
  });
}
