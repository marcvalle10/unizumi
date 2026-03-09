import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

import '../../../core/utils/quiz_helpers.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/game_mode.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/quiz_result_model.dart';
import '../../../data/repositories/question_repository.dart';

class QuizController extends ChangeNotifier {
  static const CategoryModel _mixedCategory = CategoryModel(
    id: 'mixto',
    name: 'Mixto',
    description: 'Partida con preguntas de todas las categorías.',
    icon: Icons.shuffle_rounded,
    accentColor: AppColors.purpleGlow,
  );

  final QuestionRepository _questionRepository;

  QuizController({
    QuestionRepository? questionRepository,
  }) : _questionRepository = questionRepository ?? const QuestionRepository();

  static const Duration _correctDelay = Duration(milliseconds: 850);
  static const Duration _incorrectDelay = Duration(milliseconds: 1150);
  static const Duration _timeoutDelay = Duration(milliseconds: 1250);

  CategoryModel? _category;
  GameMode _mode = GameMode.normal;

  List<QuestionModel> _questions = [];
  List<String> _currentOptions = [];

  int _currentIndex = 0;
  int _score = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;
  int _unansweredAnswers = 0;

  int _secondsLeft = 0;
  int _totalSecondsPerQuestion = 0;

  Timer? _timer;
  Timer? _nextQuestionTimer;

  bool _isAnswerLocked = false;
  bool _isLoading = false;
  bool _isFinished = false;
  bool _isTransitioning = false;

  String? _selectedAnswer;
  String? _correctAnswer;
  String? _feedbackMessage;
  bool? _lastAnswerWasCorrect;

  final List<int> _responseTimes = [];

  CategoryModel? get category => _category;
  GameMode get mode => _mode;
  List<QuestionModel> get questions => _questions;
  List<String> get currentOptions => _currentOptions;

  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _incorrectAnswers;
  int get unansweredAnswers => _unansweredAnswers;

  int get secondsLeft => _secondsLeft;
  int get totalSecondsPerQuestion => _totalSecondsPerQuestion;

  bool get isAnswerLocked => _isAnswerLocked;
  bool get isLoading => _isLoading;
  bool get isFinished => _isFinished;
  bool get isTransitioning => _isTransitioning;

  String? get selectedAnswer => _selectedAnswer;
  String? get correctAnswer => _correctAnswer;
  String? get feedbackMessage => _feedbackMessage;
  bool? get lastAnswerWasCorrect => _lastAnswerWasCorrect;

  QuestionModel? get currentQuestion {
    if (_questions.isEmpty || _currentIndex >= _questions.length) return null;
    return _questions[_currentIndex];
  }

  double get progressValue {
    if (_questions.isEmpty) return 0;
    return (_currentIndex + 1) / _questions.length;
  }

  double get timerProgress {
    if (_totalSecondsPerQuestion == 0) return 0;
    return _secondsLeft / _totalSecondsPerQuestion;
  }

  int get percentage {
    return QuizHelpers.safePercentage(
      score: _correctAnswers,
      total: totalQuestions,
    );
  }

  double get averageResponseTime {
    if (_responseTimes.isEmpty) return 0;
    final total = _responseTimes.reduce((a, b) => a + b);
    return total / _responseTimes.length;
  }

  void initialize({
    required CategoryModel category,
    required GameMode mode,
  }) {
    _disposeAllTimers();

    _category = mode == GameMode.social ? _mixedCategory : category;
    _mode = mode;
    _currentIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _incorrectAnswers = 0;
    _unansweredAnswers = 0;
    _isAnswerLocked = false;
    _isLoading = false;
    _isFinished = false;
    _isTransitioning = false;
    _selectedAnswer = null;
    _correctAnswer = null;
    _feedbackMessage = null;
    _lastAnswerWasCorrect = null;
    _responseTimes.clear();

    final fetchedQuestions = mode == GameMode.social
        ? _questionRepository.getAllQuestions()
        : _questionRepository.getQuestionsByCategory(category.id);

    final requiredQuestions = mode == GameMode.social ? 20 : 10;

    if (fetchedQuestions.length < requiredQuestions) {
      throw Exception(
        'No hay suficientes preguntas para iniciar la partida.',
      );
    }

    final shuffled = QuizHelpers.shuffledQuestions(fetchedQuestions);
    _questions = shuffled.take(requiredQuestions).toList();

    if (_questions.isNotEmpty) {
      _loadCurrentQuestion();
      _startTimer();
    }

    notifyListeners();
  }

  void _loadCurrentQuestion() {
    final question = currentQuestion;
    if (question == null) return;

    _currentOptions = QuizHelpers.shuffledOptions(question);
    _selectedAnswer = null;
    _correctAnswer = question.correctAnswer;
    _feedbackMessage = null;
    _lastAnswerWasCorrect = null;
    _isAnswerLocked = false;
    _isTransitioning = false;
    _totalSecondsPerQuestion = _mode.secondsPerQuestion;
    _secondsLeft = _totalSecondsPerQuestion;
  }

  void _startTimer() {
    _disposeTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isAnswerLocked || _isFinished || _isTransitioning) {
        timer.cancel();
        return;
      }

      if (_secondsLeft > 0) {
        _secondsLeft--;
        notifyListeners();
      }

      if (_secondsLeft <= 0) {
        _handleTimeOut();
      }
    });
  }

  void selectAnswer(String answer) {
    if (_isAnswerLocked || _isFinished || _isTransitioning) return;
    if (currentQuestion == null) return;

    _isAnswerLocked = true;
    _isTransitioning = true;
    _selectedAnswer = answer;
    _disposeTimer();

    final question = currentQuestion!;
    final isCorrect = question.isCorrect(answer);

    final timeSpent = _totalSecondsPerQuestion - _secondsLeft;
    _responseTimes.add(timeSpent.clamp(0, _totalSecondsPerQuestion));

    if (isCorrect) {
      _score += 100;
      _correctAnswers++;
      _feedbackMessage = '¡Correcto!';
      _lastAnswerWasCorrect = true;
      notifyListeners();
      _scheduleNextQuestion(_correctDelay);
      return;
    }

    _incorrectAnswers++;
    _feedbackMessage = 'Incorrecto';
    _lastAnswerWasCorrect = false;

    notifyListeners();
    _scheduleNextQuestion(_incorrectDelay);
  }

  void _handleTimeOut() {
    if (_isAnswerLocked || _isFinished || _isTransitioning) return;
    if (currentQuestion == null) return;

    _disposeTimer();
    _isAnswerLocked = true;
    _isTransitioning = true;
    _selectedAnswer = null;
    _incorrectAnswers++;
    _unansweredAnswers++;
    _feedbackMessage = 'Tiempo agotado';
    _lastAnswerWasCorrect = false;
    _responseTimes.add(_totalSecondsPerQuestion);

    notifyListeners();
    _scheduleNextQuestion(_timeoutDelay);
  }

  void _scheduleNextQuestion(Duration delay) {
    _disposeNextQuestionTimer();

    _nextQuestionTimer = Timer(delay, () {
      if (_isFinished) return;
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (_isFinished) return;

    _disposeNextQuestionTimer();

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _loadCurrentQuestion();
      _startTimer();
      notifyListeners();
    } else {
      finishQuiz();
    }
  }

  void finishQuiz() {
    _disposeAllTimers();
    _isFinished = true;
    _isTransitioning = false;
    notifyListeners();
  }

  void restart() {
    final currentCategory = _category;
    if (currentCategory == null) return;

    initialize(
      category: currentCategory,
      mode: _mode,
    );
  }

  String buildPerformanceMessage() {
    return QuizHelpers.performanceMessage(
      score: _correctAnswers,
      total: totalQuestions,
    );
  }

  String buildStudyRecommendation() {
    final name = _category?.name ?? 'la categoría seleccionada';
    return QuizHelpers.studyRecommendation(
      score: _correctAnswers,
      total: totalQuestions,
      categoryName: name,
    );
  }

  QuizResultModel buildResult() {
    final currentCategory = _category;
    if (currentCategory == null) {
      throw Exception(
        'No hay categoría seleccionada para construir resultados.',
      );
    }

    return QuizResultModel(
      category: currentCategory,
      mode: _mode,
      totalQuestions: totalQuestions,
      correctAnswers: _correctAnswers,
      incorrectAnswers: _incorrectAnswers,
      unansweredAnswers: _unansweredAnswers,
      score: _score,
      percentage: percentage,
      averageResponseTime: averageResponseTime,
      performanceMessage: buildPerformanceMessage(),
      studyRecommendation: buildStudyRecommendation(),
    );
  }

  void _disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _disposeNextQuestionTimer() {
    _nextQuestionTimer?.cancel();
    _nextQuestionTimer = null;
  }

  void _disposeAllTimers() {
    _disposeTimer();
    _disposeNextQuestionTimer();
  }

  @override
  void dispose() {
    _disposeAllTimers();
    super.dispose();
  }
}
