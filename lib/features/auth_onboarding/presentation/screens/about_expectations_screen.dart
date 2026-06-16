import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../../../../core/utils/animation_helper.dart';

class AboutExpectationsScreen extends StatelessWidget {
  const AboutExpectationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
              
              const Text(
                'About you & expectations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).animateOnboarding(index: 0),
              const SizedBox(height: 8),
              const Text(
                'Help us understand you better.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info, color: Colors.blue[400], size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'These fields are optional.', 
                        style: TextStyle(color: Colors.blue[400]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const _MultilineTextField(label: 'Idea of marriage', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'Describe your relationship with Islam?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'How do you envision your role as a spouse?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'Tell me a bit about yourself?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'How do you envision your spouse to be?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'How do you envision your marriage to be?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'Preference on spouse\'s religious status?', hint: 'Ex: Must wear hijab...etc.'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'Are you open to relocating?', hint: 'Type here...'),
              const SizedBox(height: 24),
              const _MultilineTextField(label: 'Any other preferences?', hint: 'Type here...'),
              const SizedBox(height: 48),
              
              const Divider(),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Back', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: 'Next',
                      onPressed: () => context.push('/onboarding/upload-photos'),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

class _MultilineTextField extends StatelessWidget {
  final String label;
  final String hint;

  const _MultilineTextField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}
