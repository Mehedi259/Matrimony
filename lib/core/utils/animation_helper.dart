import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Helper extension to add staggered animations to widgets
extension AnimationHelper on Widget {
  Widget animateOnboarding({int index = 0}) {
    final delay = (index * 50 + 200).ms;
    return animate()
        .fadeIn(duration: 500.ms, delay: delay)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: delay, curve: Curves.easeOutCubic);
  }
}
