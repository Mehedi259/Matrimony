import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../widgets/common/dropdown_field.dart';
import '../../../../core/utils/animation_helper.dart';

class BasicInformationScreen extends StatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  String _selectedGender = 'Female';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
              
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ).animateOnboarding(index: 0),
              const SizedBox(height: 8),
              const Text(
                'Your privacy is important. Your name,\ncontact details and photos are hidden.',
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
              
              const CustomDropdownField(label: 'How did you find us?*', hint: 'Select an option').animateOnboarding(index: 3),
              const SizedBox(height: 24),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGender = 'Male'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedGender == 'Male' 
                                  ? Theme.of(context).colorScheme.secondary 
                                  : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Image.asset('assets/male.png', height: 60, width: 60),
                                const SizedBox(height: 8),
                                const Text('Male', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedGender = 'Female'),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedGender == 'Female' 
                                  ? Theme.of(context).primaryColor 
                                  : Colors.grey[300]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Image.asset('assets/female.png', height: 60, width: 60),
                                const SizedBox(height: 8),
                                const Text('Female', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(label: 'First Name', hint: 'First Name'),
              const SizedBox(height: 24),
              
              const CustomTextField(label: 'Last Name', hint: 'Last Name'),
              const SizedBox(height: 24),
              
              const CustomTextField(label: 'Email', hint: 'Enter your email address'),
              const SizedBox(height: 24),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        ),
                        child: const Text('+44', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: '1234567',
                            border: const OutlineInputBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(label: 'Date of Birth', hint: 'DD / MM / YYYY'), // Needs icon update in a real scenario
              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: CustomTextField(label: 'City', hint: 'Enter City')),
                  const SizedBox(width: 16),
                  const Expanded(child: CustomDropdownField(label: 'Country', hint: 'Select Country')),
                ],
              ),
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
                      onPressed: () => context.push('/onboarding/personal-details'),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

