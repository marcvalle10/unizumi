import 'package:flutter/material.dart';

import '../../core/constants/app_durations.dart';

class AnimatedPage extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Offset beginOffset;

  const AnimatedPage({
    super.key,
    required this.child,
    this.duration = AppDurations.medium,
    this.beginOffset = const Offset(0, 0.05),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(
              beginOffset.dx * (1 - value) * 100,
              beginOffset.dy * (1 - value) * 100,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
