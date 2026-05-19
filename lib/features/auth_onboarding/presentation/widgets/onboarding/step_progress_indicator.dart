import 'package:flutter/material.dart';

class StepProgressIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  State<StepProgressIndicator> createState() => _StepProgressIndicatorState();
}

class _StepProgressIndicatorState extends State<StepProgressIndicator> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.totalSteps,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
    
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    _animateSteps();
  }

  void _animateSteps() {
    for (int i = 0; i < widget.currentStep; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted && i < _controllers.length) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(StepProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _animateSteps();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps * 2 - 1, (index) {
        if (index % 2 == 0) {
          int stepIndex = index ~/ 2 + 1;
          bool isActive = stepIndex <= widget.currentStep;
          return ScaleTransition(
            scale: _scaleAnimations[stepIndex - 1],
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFD48B91) : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
                boxShadow: isActive ? [
                  BoxShadow(
                    color: const Color(0xFFD48B91).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : [],
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOutCubic,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black54,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: Text('Step $stepIndex'),
                ),
              ),
            ),
          );
        } else {
          int stepIndex = index ~/ 2 + 1;
          bool isLineActive = stepIndex < widget.currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
            width: 24,
            height: 2,
            decoration: BoxDecoration(
              color: isLineActive ? const Color(0xFFD48B91) : const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(1),
            ),
          );
        }
      }),
    );
  }
}
