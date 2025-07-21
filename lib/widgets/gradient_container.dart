import 'package:flutter/material.dart';
import 'package:pulseforge/theme.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  final bool isFullScreen;
  final List<Color>? customColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientContainer({
    super.key,
    required this.child,
    this.isFullScreen = true,
    this.customColors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    List<Color> gradientColors = customColors ?? (isDark
        ? [
            DarkModeColors.darkGradientStart.withValues(alpha: 0.1),
            DarkModeColors.darkGradientEnd.withValues(alpha: 0.05),
          ]
        : [
            LightModeColors.lightGradientStart.withValues(alpha: 0.1),
            LightModeColors.lightGradientEnd.withValues(alpha: 0.05),
          ]);

    return Container(
      width: isFullScreen ? double.infinity : null,
      height: isFullScreen ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: begin,
          end: end,
        ),
      ),
      child: child,
    );
  }
}