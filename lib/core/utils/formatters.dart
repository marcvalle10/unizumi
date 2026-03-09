class Formatters {
  Formatters._();

  static String scoreLabel({required int score, required int total}) {
    return '$score / $total';
  }

  static String percentageLabel({required int score, required int total}) {
    if (total == 0) return '0%';
    final percentage = ((score / total) * 100).round();
    return '$percentage%';
  }

  static String questionProgress({required int current, required int total}) {
    return 'Pregunta $current de $total';
  }

  static String secondsLabel(int seconds) {
    return '${seconds}s';
  }

  static String timeAverageLabel(double avgSeconds) {
    return '${avgSeconds.toStringAsFixed(1)}s';
  }
}
