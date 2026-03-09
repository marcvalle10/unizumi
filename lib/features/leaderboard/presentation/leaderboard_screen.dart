import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../data/models/leaderboard_user_model.dart';
import '../../../data/repositories/leaderboard_repository.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/animated_page.dart';
import '../../../shared/widgets/section_title.dart';
import 'widgets/leaderboard_tile.dart';
import 'widgets/podium_card.dart';

class LeaderboardScreen extends StatelessWidget {
  static const routeName = '/leaderboard';

  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = const LeaderboardRepository().getLeaderboard();

    final sorted = [...users]..sort((a, b) => a.rank.compareTo(b.rank));

    final topThree = sorted.take(3).toList();
    final rest = sorted.skip(3).toList();

    final LeaderboardUserModel? first =
        topThree.where((u) => u.rank == 1).isNotEmpty
            ? topThree.firstWhere((u) => u.rank == 1)
            : null;

    final LeaderboardUserModel? second =
        topThree.where((u) => u.rank == 2).isNotEmpty
            ? topThree.firstWhere((u) => u.rank == 2)
            : null;

    final LeaderboardUserModel? third =
        topThree.where((u) => u.rank == 3).isNotEmpty
            ? topThree.firstWhere((u) => u.rank == 3)
            : null;

    return AppScaffold(
      child: AnimatedPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            const SectionTitle(
              title: 'Ranking global',
              subtitle:
                  'Compara puntajes, precisión y victorias en el tablero competitivo.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: const [
                  Expanded(child: _RankingTab(label: 'Hoy', selected: false)),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: _RankingTab(label: 'Semana', selected: true)),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _RankingTab(label: 'Global', selected: false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              height: 270,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (second != null)
                    PodiumCard(
                      name: second.name,
                      score: second.score,
                      rank: second.rank,
                      heightFactor: 0.82,
                      glow: AppColors.cyanGlow,
                    ),
                  const SizedBox(width: AppSpacing.md),
                  if (first != null)
                    PodiumCard(
                      name: first.name,
                      score: first.score,
                      rank: first.rank,
                      heightFactor: 1.0,
                      glow: AppColors.accentGold,
                    ),
                  const SizedBox(width: AppSpacing.md),
                  if (third != null)
                    PodiumCard(
                      name: third.name,
                      score: third.score,
                      rank: third.rank,
                      heightFactor: 0.72,
                      glow: AppColors.purpleGlow,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Más jugadores',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView.separated(
                itemCount: rest.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  return LeaderboardTile(user: rest[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingTab extends StatelessWidget {
  final String label;
  final bool selected;

  const _RankingTab({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: selected
            ? const LinearGradient(
                colors: [AppColors.accentGold, AppColors.accentAmber],
              )
            : null,
        color: selected ? null : Colors.transparent,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: selected ? Colors.black87 : AppColors.white,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}
