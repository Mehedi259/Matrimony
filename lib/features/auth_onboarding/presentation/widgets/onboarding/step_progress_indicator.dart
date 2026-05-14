import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index % 2 == 0) {
          int stepIndex = index ~/ 2 + 1;
          bool isActive = stepIndex <= currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFD48B91) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black54,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                child: Text('Step $stepIndex'),
              ),
            ),
          );
        } else {
          int stepIndex = index ~/ 2 + 1;
          bool isLineActive = stepIndex < currentStep;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 24,
            height: 2,
            color: isLineActive ? const Color(0xFFD48B91) : const Color(0xFFF0F0F0),
          );
        }
      }),
    );
  }
}
