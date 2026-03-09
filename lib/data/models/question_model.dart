class QuestionModel {
  final String id;
  final String categoryId;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String difficulty;

  const QuestionModel({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.difficulty,
  });

  bool isCorrect(String answer) => answer == correctAnswer;

  QuestionModel copyWith({
    String? id,
    String? categoryId,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    String? difficulty,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
