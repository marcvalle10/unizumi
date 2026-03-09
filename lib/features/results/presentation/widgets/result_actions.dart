import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/glow_button.dart';

class ResultActions extends StatelessWidget {
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;

  const ResultActions({
    super.key,
    required this.onPlayAgain,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlowButton(
          text: 'Jugar de nuevo',
          icon: Icons.refresh_rounded,
          onTap: onPlayAgain,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onGoHome,
            child: const Text('Volver al inicio'),
          ),
        ),
      ],
    );
  }
}
