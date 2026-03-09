import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glass_card.dart';

class StatsRow extends StatelessWidget {
  final int correct;
  final int incorrect;
  final double averageTime;

  const StatsRow({
    super.key,
    required this.correct,
    required this.incorrect,
    required this.averageTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Aciertos',
            value: '$correct',
            icon: Icons.check_circle_rounded,
            glow: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            title: 'Errores',
            value: '$incorrect',
            icon: Icons.cancel_rounded,
            glow: AppColors.error,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            title: 'Tiempo prom.',
            value: '${averageTime.toStringAsFixed(1)}s',
            icon: Icons.timer_rounded,
            glow: AppColors.cyanGlow,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color glow;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glowColor: glow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: glow, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.whiteSoft,
                  fontWeight: FontWeight.w700,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
