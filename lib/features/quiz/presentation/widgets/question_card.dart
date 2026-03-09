import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../data/models/category_model.dart';
import '../../../../shared/widgets/glass_card.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final String? difficulty;
  final CategoryModel category;

  const QuestionCard({
    super.key,
    required this.question,
    required this.category,
    this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: category.accentColor,
      padding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Icon(
              category.icon,
              size: 90,
              color: category.accentColor.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          category.accentColor.withOpacity(0.95),
                          AppColors.accentGold.withOpacity(0.92),
                        ],
                      ),
                    ),
                    child: Icon(
                      category.icon,
                      color: Colors.black87,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                    ),
                  ),
                  if (difficulty != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        difficulty!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                question,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      height: 1.18,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
