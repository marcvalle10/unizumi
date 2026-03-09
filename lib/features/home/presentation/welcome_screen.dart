import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/animated_page.dart';
import '../../../shared/widgets/glow_button.dart';
// import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../setup/presentation/setup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: 10,
      ),
      child: AnimatedPage(
        beginOffset: const Offset(0, 0.04),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: _WelcomeEffectsPainter(
                        progress: _controller.value,
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _MiniBadge(
                      icon: Icons.bolt_rounded,
                      label: 'Trivia',
                    ),
                    _MiniBadge(
                      icon: Icons.auto_awesome_rounded,
                      label: 'UNISON',
                    ),
                  ],
                ),
                const Spacer(),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final scale =
                        1 + (math.sin(_controller.value * 2 * math.pi) * 0.02);
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 270,
                        height: 270,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accentGold.withOpacity(0.22),
                              AppColors.cyanGlow.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withOpacity(0.18),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                            BoxShadow(
                              color: AppColors.cyanGlow.withOpacity(0.10),
                              blurRadius: 90,
                              spreadRadius: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 212,
                        height: 212,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.10),
                            width: 1.5,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.02),
                            ],
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'app_logo',
                        child: Container(
                          width: 182,
                          height: 182,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 25,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                color: Colors.white.withOpacity(0.02),
                                child: Image.asset(
                                  'assets/images/logo_unison.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image_rounded,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        right: 30,
                        child: _FloatingIcon(
                          icon: Icons.emoji_events_rounded,
                          color: AppColors.accentGold,
                          progress: _controller.value,
                          phase: 0.2,
                        ),
                      ),
                      Positioned(
                        left: 24,
                        bottom: 34,
                        child: _FloatingIcon(
                          icon: Icons.bolt_rounded,
                          color: AppColors.cyanGlow,
                          progress: _controller.value,
                          phase: 0.55,
                        ),
                      ),
                      Positioned(
                        right: 18,
                        bottom: 52,
                        child: _FloatingIcon(
                          icon: Icons.psychology_alt_rounded,
                          color: AppColors.purpleGlow,
                          progress: _controller.value,
                          phase: 0.85,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 34),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Colors.white,
                        AppColors.accentGold,
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    'Desafío\nUnizumi',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 40,
                          height: 1.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    'Compite, responde bajo presión y demuestra quién domina la trivia universitaria.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteSoft,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Desarrollado por',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Cecilia Casas\nMarcos Vallejo\nJoshua Monge',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.white,
                              height: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GlowButton(
                  text: 'Comenzar desafío',
                  icon: Icons.play_arrow_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 650),
                        reverseTransitionDuration:
                            const Duration(milliseconds: 500),
                        pageBuilder: (_, animation, secondaryAnimation) =>
                            const SetupScreen(),
                        transitionsBuilder:
                            (_, animation, secondaryAnimation, child) {
                          final fade = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          );

                          final slide = Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          );

                          return FadeTransition(
                            opacity: fade,
                            child: SlideTransition(
                              position: slide,
                              child: child,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Ranking oculto temporalmente hasta implementar la versión funcional.
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accentGold),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double progress;
  final double phase;

  const _FloatingIcon({
    required this.icon,
    required this.color,
    required this.progress,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final dy = math.sin((progress + phase) * 2 * math.pi) * 6;
    return Transform.translate(
      offset: Offset(0, dy),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.14),
          border: Border.all(color: color.withOpacity(0.45)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _WelcomeEffectsPainter extends CustomPainter {
  final double progress;

  const _WelcomeEffectsPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;

    const step = 44.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final particlePaint = Paint()..style = PaintingStyle.fill;

    final particles = <_Particle>[
      _Particle(0.18, 0.20, 2.6, AppColors.accentGold.withOpacity(0.25)),
      _Particle(0.74, 0.16, 2.2, AppColors.cyanGlow.withOpacity(0.20)),
      _Particle(0.82, 0.34, 1.8, AppColors.purpleGlow.withOpacity(0.18)),
      _Particle(0.24, 0.68, 2.1, AppColors.white.withOpacity(0.10)),
      _Particle(0.62, 0.78, 2.8, AppColors.accentGold.withOpacity(0.18)),
      _Particle(0.12, 0.52, 1.9, AppColors.cyanGlow.withOpacity(0.15)),
    ];

    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final wobbleX = math.sin((progress + i * 0.17) * 2 * math.pi) * 6;
      final wobbleY = math.cos((progress + i * 0.13) * 2 * math.pi) * 8;

      particlePaint.color = p.color;
      canvas.drawCircle(
        Offset(size.width * p.x + wobbleX, size.height * p.y + wobbleY),
        p.radius,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeEffectsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final Color color;

  const _Particle(this.x, this.y, this.radius, this.color);
}
