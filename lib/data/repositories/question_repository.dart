import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../question_bank/ciencia_questions.dart';
import '../question_bank/cultura_general_questions.dart';
import '../question_bank/geografia_questions.dart';
import '../question_bank/peliculas_questions.dart';
import '../question_bank/videojuegos_questions.dart';

class QuestionRepository {
  const QuestionRepository();

  List<CategoryModel> getCategories() {
    return const [
      CategoryModel(
        id: 'ciencia',
        name: 'Ciencia',
        description: 'Descubrimientos, teorías y datos curiosos.',
        icon: Icons.science_rounded,
        accentColor: AppColors.cyanGlow,
      ),
      CategoryModel(
        id: 'geografia',
        name: 'Geografía',
        description: 'Países, capitales, mapas y cultura mundial.',
        icon: Icons.public_rounded,
        accentColor: Color.fromARGB(255, 160, 88, 20),
      ),
      CategoryModel(
        id: 'peliculas',
        name: 'Películas',
        description: 'Cine, personajes icónicos y franquicias.',
        icon: Icons.movie_creation_rounded,
        accentColor: AppColors.purpleGlow,
      ),
      CategoryModel(
        id: 'videojuegos',
        name: 'Videojuegos',
        description: 'Consolas, sagas y cultura gamer.',
        icon: Icons.sports_esports_rounded,
        accentColor: AppColors.accentAmber,
      ),
      CategoryModel(
        id: 'cultura_general',
        name: 'Cultura general',
        description: 'Situaciones cotidianas, hábitos y conocimiento general.',
        icon: Icons.lightbulb_rounded,
        accentColor: AppColors.success,
      ),
    ];
  }

  List<QuestionModel> getQuestionsByCategory(String categoryId) {
    switch (categoryId) {
      case 'ciencia':
        return List<QuestionModel>.from(cienciaQuestions);
      case 'geografia':
        return List<QuestionModel>.from(geografiaQuestions);
      case 'peliculas':
        return List<QuestionModel>.from(peliculasQuestions);
      case 'videojuegos':
        return List<QuestionModel>.from(videojuegosQuestions);
      case 'cultura_general':
        return List<QuestionModel>.from(culturaGeneralQuestions);
      default:
        return [];
    }
  }

  List<QuestionModel> getAllQuestions() {
    return [
      ...cienciaQuestions,
      ...geografiaQuestions,
      ...peliculasQuestions,
      ...videojuegosQuestions,
      ...culturaGeneralQuestions,
    ];
  }
}
