import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../data/models/leaderboard_user_model.dart';
import '../../../../shared/widgets/glass_card.dart';

class LeaderboardTile extends StatelessWidget {
  final LeaderboardUserModel user;

  const LeaderboardTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: user.rank <= 3 ? AppColors.accentGold : AppColors.cyanGlow,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                '${user.rank}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.purpleGlow.withOpacity(0.22),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Precisión ${user.accuracy.toStringAsFixed(1)}% · ${user.wins} victorias',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.whiteSoft),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${user.score}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}
