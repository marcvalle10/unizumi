import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_radius.dart';

enum AnswerVisualState {
  normal,
  correct,
  incorrect,
  disabled,
}

class AnswerButton extends StatefulWidget {
  final String text;
  final String label;
  final VoidCallback onTap;
  final AnswerVisualState state;
  final Color accentColor;

  const AnswerButton({
    super.key,
    required this.text,
    required this.label,
    required this.onTap,
    required this.state,
    required this.accentColor,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(covariant AnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == AnswerVisualState.incorrect &&
        oldWidget.state != AnswerVisualState.incorrect) {
      _shakeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle(widget.state, widget.accentColor);

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shakeValue = math.sin(_shakeController.value * math.pi * 6) *
            (1 - _shakeController.value) *
            10;

        return Transform.translate(
          offset: Offset(shakeValue, 0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.985, end: 1),
            duration: AppDurations.normal,
            curve: Curves.easeOutBack,
            builder: (context, scale, innerChild) {
              return Transform.scale(
                scale: scale,
                child: innerChild,
              );
            },
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: style.gradient,
          ),
          border: Border.all(
            color: style.borderColor,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: style.shadowColor,
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.state == AnswerVisualState.disabled
                ? null
                : widget.onTap,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: AppDurations.normal,
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: style.bubbleColor,
                      border: Border.all(
                        color: style.bubbleBorderColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          color: style.bubbleTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: style.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedSwitcher(
                    duration: AppDurations.normal,
                    child: style.icon == null
                        ? const SizedBox(width: 24, height: 24)
                        : Icon(
                            style.icon,
                            key: ValueKey(style.icon),
                            color: style.textColor,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AnswerStyle _resolveStyle(AnswerVisualState state, Color accentColor) {
    switch (state) {
      case AnswerVisualState.correct:
        return _AnswerStyle(
          gradient: const [
            Color(0xFF22C55E),
            Color(0xFF16A34A),
          ],
          borderColor: AppColors.success.withOpacity(0.95),
          shadowColor: AppColors.success.withOpacity(0.26),
          textColor: Colors.white,
          icon: Icons.check_circle_rounded,
          bubbleColor: Colors.white.withOpacity(0.14),
          bubbleBorderColor: Colors.white.withOpacity(0.24),
          bubbleTextColor: Colors.white,
        );
      case AnswerVisualState.incorrect:
        return _AnswerStyle(
          gradient: const [
            Color(0xFFEF4444),
            Color(0xFFDC2626),
          ],
          borderColor: AppColors.error.withOpacity(0.95),
          shadowColor: AppColors.error.withOpacity(0.24),
          textColor: Colors.white,
          icon: Icons.close_rounded,
          bubbleColor: Colors.white.withOpacity(0.14),
          bubbleBorderColor: Colors.white.withOpacity(0.24),
          bubbleTextColor: Colors.white,
        );
      case AnswerVisualState.disabled:
        return _AnswerStyle(
          gradient: [
            Colors.white.withOpacity(0.045),
            Colors.white.withOpacity(0.03),
          ],
          borderColor: AppColors.border,
          shadowColor: Colors.black.withOpacity(0.10),
          textColor: AppColors.whiteSoft,
          icon: null,
          bubbleColor: Colors.white.withOpacity(0.05),
          bubbleBorderColor: Colors.white.withOpacity(0.08),
          bubbleTextColor: AppColors.whiteMuted,
        );
      case AnswerVisualState.normal:
        return _AnswerStyle(
          gradient: [
            accentColor.withOpacity(0.18),
            Colors.white.withOpacity(0.05),
          ],
          borderColor: accentColor.withOpacity(0.28),
          shadowColor: accentColor.withOpacity(0.12),
          textColor: AppColors.white,
          icon: null,
          bubbleColor: accentColor.withOpacity(0.18),
          bubbleBorderColor: accentColor.withOpacity(0.30),
          bubbleTextColor: AppColors.white,
        );
    }
  }
}

class _AnswerStyle {
  final List<Color> gradient;
  final Color borderColor;
  final Color shadowColor;
  final Color textColor;
  final IconData? icon;
  final Color bubbleColor;
  final Color bubbleBorderColor;
  final Color bubbleTextColor;

  const _AnswerStyle({
    required this.gradient,
    required this.borderColor,
    required this.shadowColor,
    required this.textColor,
    required this.icon,
    required this.bubbleColor,
    required this.bubbleBorderColor,
    required this.bubbleTextColor,
  });
}
