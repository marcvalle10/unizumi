import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class TimerRing extends StatefulWidget {
  final int secondsLeft;
  final double progress;
  final Color accentColor;

  const TimerRing({
    super.key,
    required this.secondsLeft,
    required this.progress,
    this.accentColor = AppColors.accentGold,
  });

  @override
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didUpdateWidget(covariant TimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.secondsLeft <= 3 && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (widget.secondsLeft > 3 && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = widget.progress.clamp(0.0, 1.0);
    final bool isDanger = widget.secondsLeft <= 3;
    final Color activeColor = isDanger ? AppColors.error : widget.accentColor;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseScale = isDanger ? 1 + (_pulseController.value * 0.08) : 1.0;

        return Transform.scale(
          scale: pulseScale,
          child: SizedBox(
            width: 84,
            height: 84,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(isDanger ? 0.24 : 0.14),
                        blurRadius: isDanger ? 24 : 16,
                        spreadRadius: isDanger ? 4 : 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 84,
                  height: 84,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: safeProgress),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOut,
                    builder: (context, value, _) {
                      return CustomPaint(
                        painter: _RingPainter(
                          progress: value,
                          color: activeColor,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.white.withOpacity(0.04),
                      ],
                    ),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${widget.secondsLeft}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _RingPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2 - 6);

    final basePaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: (math.pi * 2) - (math.pi / 2),
        colors: [
          color.withOpacity(0.55),
          color,
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final innerPaint = Paint()
      ..color = color.withOpacity(0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(rect, 0, math.pi * 2, false, basePaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      (math.pi * 2) * progress,
      false,
      progressPaint,
    );

    final innerRect =
        Rect.fromCircle(center: center, radius: size.width / 2 - 16);
    canvas.drawArc(innerRect, 0, math.pi * 2, false, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
