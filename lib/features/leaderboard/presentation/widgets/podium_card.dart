import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glass_card.dart';

class PodiumCard extends StatelessWidget {
  final String name;
  final int score;
  final int rank;
  final double heightFactor;
  final Color glow;

  const PodiumCard({
    super.key,
    required this.name,
    required this.score,
    required this.rank,
    required this.heightFactor,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    final double height = 120 * heightFactor;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: rank == 1 ? 28 : 24,
            backgroundColor: glow.withOpacity(0.22),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$score pts',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteSoft,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: height,
            child: GlassCard(
              glowColor: glow,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_rounded,
                    color: glow,
                    size: rank == 1 ? 30 : 24,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '#$rank',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
