import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../data/models/category_model.dart';

class QuizTopBar extends StatelessWidget {
  final CategoryModel category;
  final int score;
  final VoidCallback onBack;

  const QuizTopBar({
    super.key,
    required this.category,
    required this.score,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.white,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.accentColor.withOpacity(0.20),
                  border: Border.all(
                    color: category.accentColor.withOpacity(0.55),
                  ),
                ),
                child: Icon(category.icon, size: 18, color: AppColors.white),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.stars_rounded,
                size: 16,
                color: AppColors.accentGold,
              ),
              const SizedBox(width: 6),
              Text(
                '$score pts',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
