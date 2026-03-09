import 'dart:math';

import '../../data/models/question_model.dart';

class QuizHelpers {
  QuizHelpers._();

  static final Random _random = Random();

  static List<QuestionModel> shuffledQuestions(List<QuestionModel> questions) {
    final copy = List<QuestionModel>.from(questions);
    copy.shuffle(_random);
    return copy;
  }

  static List<String> shuffledOptions(QuestionModel question) {
    final options = List<String>.from(question.options);
    options.shuffle(_random);
    return options;
  }

  static String performanceMessage({required int score, required int total}) {
    if (total == 0) return 'Sin resultados';
    final ratio = score / total;

    if (ratio >= 0.9) return 'Excelente trabajo';
    if (ratio >= 0.7) return 'Muy buen desempeño';
    if (ratio >= 0.5) return 'Buen intento, sigue practicando';
    return 'Necesitas repasar más este tema';
  }

  static String studyRecommendation({
    required int score,
    required int total,
    required String categoryName,
  }) {
    if (total == 0) return 'No hay suficientes datos para recomendar estudio.';
    final ratio = score / total;

    if (ratio >= 0.8) {
      return 'Dominas bastante bien la categoría de $categoryName.';
    }
    if (ratio >= 0.5) {
      return 'Conviene reforzar algunos conceptos de $categoryName.';
    }
    return 'Se recomienda estudiar más los temas de $categoryName.';
  }

  static int safePercentage({required int score, required int total}) {
    if (total == 0) return 0;
    return ((score / total) * 100).round();
  }
}
