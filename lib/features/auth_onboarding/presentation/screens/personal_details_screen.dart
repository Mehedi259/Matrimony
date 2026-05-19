import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/radio_group.dart';
import '../../../../core/utils/animation_helper.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
              
              const Text(
                'Personal Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).animateOnboarding(index: 0),
              const SizedBox(height: 8),
              const Text(
                'Tell us more about yourself.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ).animateOnboarding(index: 1),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.emergency, color: Colors.red[300], size: 16),
                    const SizedBox(width: 8),
                    Text('These fields are required', style: TextStyle(color: Colors.red[300])),
                  ],
                ),
              ).animateOnboarding(index: 2),
              const SizedBox(height: 32),
              
              const CustomDropdownField(label: 'Sect', hint: 'Select sect').animateOnboarding(index: 3),
              const SizedBox(height: 24),
              const CustomDropdownField(label: 'Marital Status', hint: 'Select marital status').animateOnboarding(index: 4),
              const SizedBox(height: 24),
              const CustomDropdownField(label: 'Ethnicity', hint: 'Select ethnicity').animateOnboarding(index: 5),
              const SizedBox(height: 24),
              const CustomDropdownField(label: 'Nationality/ Citizenship', hint: 'Select nationality').animateOnboarding(index: 6),
              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Family & Physical', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              CustomRadioGroup(label: 'Do you have children?', options: const ['Yes', 'No'], selected: 'No'),
              const SizedBox(height: 24),
              const CustomDropdownField(label: 'How many children do you have?', hint: 'Select number'),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  const Expanded(child: CustomDropdownField(label: 'Height', hint: 'Select height')),
                  const SizedBox(width: 16),
                  const Expanded(child: CustomDropdownField(label: 'Weight', hint: 'Select weight')),
                ],
              ),
              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Family & Physical', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              CustomRadioGroup(label: 'Prayer 5x a day?', options: const ['Yes', 'Mostly', 'No'], selected: 'Mostly'),
              const SizedBox(height: 24),
              
              CustomRadioGroup(label: 'Are you open to relocating?', options: const ['Yes', 'Maybe', 'No'], selected: 'Maybe'),
              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('For sisters only', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              const CustomDropdownField(label: 'How do you dress?', hint: 'Select an option'),
              const SizedBox(height: 24),
              
              const CustomTextField(label: 'Wali Name', hint: 'Enter wali name'),
              const SizedBox(height: 24),
              const CustomTextField(label: 'Wali Relation', hint: 'Enter relation'),
              const SizedBox(height: 24),
              const CustomTextField(label: 'Wali Contact', hint: 'Enter wali number'),
              const SizedBox(height: 48),
              
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
                      onPressed: () => context.push('/onboarding/preferences'), // Skip AboutExpectations for now based on images
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

