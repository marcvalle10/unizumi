enum GameMode { rapido, normal, social }

extension GameModeX on GameMode {
  String get label {
    switch (this) {
      case GameMode.rapido:
        return 'Rápido';
      case GameMode.normal:
        return 'Normal';
      case GameMode.social:
        return 'Mixto';
    }
  }

  String get description {
    switch (this) {
      case GameMode.rapido:
        return 'Menos tiempo por pregunta';
      case GameMode.normal:
        return 'Ritmo equilibrado';
      case GameMode.social:
        return 'Todas las categorías en una partida';
    }
  }

  int get secondsPerQuestion {
    switch (this) {
      case GameMode.rapido:
        return 8;
      case GameMode.normal:
        return 15;
      case GameMode.social:
        return 12;
    }
  }
}
