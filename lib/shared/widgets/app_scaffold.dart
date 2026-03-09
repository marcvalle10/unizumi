import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import 'gradient_background.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;

  const AppScaffold({
    super.key,
    required this.child,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.lg,
          ),
      child: child,
    );

    return Scaffold(
      body: GradientBackground(
        child: useSafeArea ? SafeArea(child: content) : content,
      ),
    );
  }
}
