import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundBottom, AppColors.backgroundDark],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: _GlowOrb(
              size: 220,
              color: AppColors.cyanGlow.withOpacity(0.14),
            ),
          ),
          Positioned(
            top: 120,
            left: -60,
            child: _GlowOrb(
              size: 160,
              color: AppColors.purpleGlow.withOpacity(0.10),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: _GlowOrb(
              size: 240,
              color: AppColors.accentGold.withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: 140,
            right: -40,
            child: _GlowOrb(
              size: 120,
              color: AppColors.cyanGlow.withOpacity(0.06),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _GridGlowPainter()),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 80, spreadRadius: 20)],
      ),
    );
  }
}

class _GridGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.018)
      ..strokeWidth = 1;

    const step = 42.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
