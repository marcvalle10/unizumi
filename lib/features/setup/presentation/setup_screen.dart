import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/game_mode.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../quiz/presentation/quiz_screen.dart';
import 'widgets/category_card.dart';
import 'widgets/continue_button.dart';
import 'widgets/game_mode_chip.dart';

class SetupScreen extends StatefulWidget {
  static const routeName = '/setup';

  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  final QuestionRepository _questionRepository = const QuestionRepository();

  late final List<CategoryModel> _categories;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  CategoryModel? _selectedCategory;
  GameMode _selectedMode = GameMode.normal;

  @override
  void initState() {
    super.initState();
    _categories = _questionRepository.getCategories();
    _selectedCategory = _categories.first;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _modeDescription(GameMode mode) {
    switch (mode) {
      case GameMode.rapido:
        return 'Modo rápido: menos tiempo por pregunta, más presión y una partida más intensa.';
      case GameMode.normal:
        return 'Modo normal: equilibrio entre velocidad y lectura para una experiencia más cómoda.';
      case GameMode.social:
        return 'Modo mixto: mezcla preguntas aleatorias de todas las categorías en una sola partida de 20 preguntas.';
    }
  }

  IconData _modeFeatureIcon(GameMode mode) {
    switch (mode) {
      case GameMode.rapido:
        return Icons.bolt_rounded;
      case GameMode.normal:
        return Icons.tune_rounded;
      case GameMode.social:
        return Icons.shuffle_rounded;
    }
  }

  Color _modeFeatureColor(GameMode mode) {
    switch (mode) {
      case GameMode.rapido:
        return AppColors.accentAmber;
      case GameMode.normal:
        return AppColors.cyanGlow;
      case GameMode.social:
        return AppColors.purpleGlow;
    }
  }

  double _categoryAspectRatio(Size size) {
    final width = size.width;
    final height = size.height;

    if (width < 380) return 0.82;
    if (height < 760) return 0.88;
    if (width > 430) return 0.98;
    return 0.92;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isNarrow = size.width < 385;

    return AppScaffold(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: 12,
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withOpacity(0.18),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Material(
                          color: Colors.transparent,
                          child: Image.asset(
                            'assets/images/logo_unison.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white.withOpacity(0.04),
                                child: const Icon(
                                  Icons.school_rounded,
                                  color: AppColors.white,
                                  size: 32,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selecciona una categoría',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: isNarrow ? 24 : 28,
                                fontWeight: FontWeight.w800,
                                height: 1.05,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Elige el tipo de trivia y define cómo quieres jugar.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.whiteSoft,
                                    height: 1.35,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.section),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categorías',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Builder(
                        builder: (context) {
                          final primaryCategories = _categories.take(4).toList();
                          final extraCategory = _categories.length > 4 ? _categories[4] : null;

                          return Column(
                            children: [
                              GridView.builder(
                                itemCount: primaryCategories.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppSpacing.lg,
                                  mainAxisSpacing: AppSpacing.lg,
                                  childAspectRatio: _categoryAspectRatio(size),
                                ),
                                itemBuilder: (context, index) {
                                  final category = primaryCategories[index];

                                  return CategoryCard(
                                    icon: category.icon,
                                    title: category.name,
                                    description: category.description,
                                    difficulty: '10 preguntas',
                                    accentColor: category.accentColor,
                                    selected: _selectedCategory?.id == category.id,
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    },
                                  );
                                },
                              ),
                              if (extraCategory != null) ...[
                                const SizedBox(height: AppSpacing.lg),
                                Center(
                                  child: SizedBox(
                                    width: size.width < 420 ? size.width * 0.72 : 260,
                                    child: CategoryCard(
                                      icon: extraCategory.icon,
                                      title: extraCategory.name,
                                      description: extraCategory.description,
                                      difficulty: '10 preguntas',
                                      accentColor: extraCategory.accentColor,
                                      selected: _selectedCategory?.id == extraCategory.id,
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = extraCategory;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'Modo de juego',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final totalWidth = constraints.maxWidth;
                          final spacing = AppSpacing.md * 2;
                          final chipWidth = (totalWidth - spacing) / 3;

                          if (chipWidth < 108) {
                            return Wrap(
                              spacing: AppSpacing.md,
                              runSpacing: AppSpacing.md,
                              children: [
                                SizedBox(
                                  width: (totalWidth - AppSpacing.md) / 2,
                                  child: GameModeChip(
                                    icon: Icons.flash_on_rounded,
                                    title: GameMode.rapido.label,
                                    description: GameMode.rapido.description,
                                    selected: _selectedMode == GameMode.rapido,
                                    glowColor: AppColors.accentAmber,
                                    onTap: () {
                                      setState(() {
                                        _selectedMode = GameMode.rapido;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: (totalWidth - AppSpacing.md) / 2,
                                  child: GameModeChip(
                                    icon: Icons.tune_rounded,
                                    title: GameMode.normal.label,
                                    description: GameMode.normal.description,
                                    selected: _selectedMode == GameMode.normal,
                                    glowColor: AppColors.cyanGlow,
                                    onTap: () {
                                      setState(() {
                                        _selectedMode = GameMode.normal;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: totalWidth,
                                  child: GameModeChip(
                                    icon: Icons.shuffle_rounded,
                                    title: GameMode.social.label,
                                    description: GameMode.social.description,
                                    selected: _selectedMode == GameMode.social,
                                    glowColor: AppColors.purpleGlow,
                                    onTap: () {
                                      setState(() {
                                        _selectedMode = GameMode.social;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: GameModeChip(
                                  icon: Icons.flash_on_rounded,
                                  title: GameMode.rapido.label,
                                  description: GameMode.rapido.description,
                                  selected: _selectedMode == GameMode.rapido,
                                  glowColor: AppColors.accentAmber,
                                  onTap: () {
                                    setState(() {
                                      _selectedMode = GameMode.rapido;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: GameModeChip(
                                  icon: Icons.tune_rounded,
                                  title: GameMode.normal.label,
                                  description: GameMode.normal.description,
                                  selected: _selectedMode == GameMode.normal,
                                  glowColor: AppColors.cyanGlow,
                                  onTap: () {
                                    setState(() {
                                      _selectedMode = GameMode.normal;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: GameModeChip(
                                  icon: Icons.shuffle_rounded,
                                  title: GameMode.social.label,
                                  description: GameMode.social.description,
                                  selected: _selectedMode == GameMode.social,
                                  glowColor: AppColors.purpleGlow,
                                  onTap: () {
                                    setState(() {
                                      _selectedMode = GameMode.social;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: _modeFeatureColor(_selectedMode)
                                  .withOpacity(0.08),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _modeFeatureColor(_selectedMode)
                                    .withOpacity(0.14),
                                border: Border.all(
                                  color: _modeFeatureColor(_selectedMode)
                                      .withOpacity(0.35),
                                ),
                              ),
                              child: Icon(
                                _modeFeatureIcon(_selectedMode),
                                color: _modeFeatureColor(_selectedMode),
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedMode.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    _modeDescription(_selectedMode),
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ContinueButton(
                enabled: _selectedCategory != null,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    QuizScreen.routeName,
                    arguments: {
                      'category': _selectedCategory,
                      'mode': _selectedMode,
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
