import 'package:flutter/material.dart';

import '../../../../shared/widgets/glow_button.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool enabled;

  const ContinueButton({super.key, required this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: null, child: const Text('Continuar')),
      );
    }

    return GlowButton(
      text: 'Continuar',
      icon: Icons.arrow_forward_rounded,
      onTap: onTap,
    );
  }
}
