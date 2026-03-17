import 'package:flutter/material.dart';

class GradientProgressBarViewModel {
  final double progress;
  final double height;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final List<Color> gradientColors;

  const GradientProgressBarViewModel({
    required this.progress,
    required this.height,
    required this.borderRadius,
    required this.backgroundColor,
    required this.gradientColors,
  });

  double get normalizedProgress {
    if (progress.isNaN) return 0;
    return progress.clamp(0.0, 1.0);
  }
}
