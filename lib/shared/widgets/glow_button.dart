import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/constants/app_radius.dart';
import '../../core/theme/app_text_styles.dart';

class GlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool expanded;
  final double height;

  const GlowButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.expanded = true,
    this.height = 58,
  });

  @override
  State<GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final button = AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: AppDurations.fast,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: const LinearGradient(
            colors: [AppColors.accentGold, AppColors.accentAmber],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withOpacity(0.30),
              blurRadius: _pressed ? 10 : 18,
              spreadRadius: _pressed ? 0 : 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            onTap: widget.onTap,
            onHighlightChanged: (value) {
              if (mounted) {
                setState(() => _pressed = value);
              }
            },
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.black87),
                    const SizedBox(width: 10),
                  ],
                  Text(widget.text, style: AppTextStyles.labelButton),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
