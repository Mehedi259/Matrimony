import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/country_phone_field.dart';
import '../../../../core/utils/animation_helper.dart';
import '../../../../core/constants/dropdown_options.dart';

class BasicInformationScreen extends StatefulWidget {
  final String? profileType; // 'brother', 'sister', or 'wali'
  final String? gender; // 'Male' or 'Female'
  
  const BasicInformationScreen({
    super.key,
    this.profileType,
    this.gender,
  });

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  String? _howDidYouFindUs;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? _selectedCountry;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    super.dispose();
  }

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
              
              // How did you find us? Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'How did you find us?',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _howDidYouFindUs,
                        hint: Text('Select an option', style: TextStyle(color: Colors.grey[400])),
                        isExpanded: true,
                        items: DropdownOptions.howDidYouFindUs.map((item) {
                          return DropdownMenuItem(value: item, child: Text(item));
                        }).toList(),
                        onChanged: (value) => setState(() => _howDidYouFindUs = value),
                      ),
                    ),
                  ),
                ],
              ).animateOnboarding(index: 3),
              const SizedBox(height: 24),
              
              // Display selected gender (read-only)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.gender == 'Male' 
                    ? const Color(0xFF7685C2).withOpacity(0.1) 
                    : const Color(0xFFD48B91).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.gender == 'Male' 
                      ? const Color(0xFF7685C2) 
                      : const Color(0xFFD48B91),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.gender == 'Male' ? Icons.male : Icons.female,
                      color: widget.gender == 'Male' 
                        ? const Color(0xFF7685C2) 
                        : const Color(0xFFD48B91),
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Type: ${widget.profileType == 'wali' ? 'Wali (Guardian)' : widget.gender}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.profileType == 'wali' 
                              ? 'Registering for a female (will see male profiles)'
                              : 'Will see ${widget.gender == 'Male' ? 'female' : 'male'} profiles',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animateOnboarding(index: 4),
              const SizedBox(height: 24),
              
              CustomTextField(
                label: 'First Name',
                hint: 'First Name',
                controller: _firstNameController,
              ).animateOnboarding(index: 5),
              const SizedBox(height: 24),
              
              CustomTextField(
                label: 'Last Name',
                hint: 'Last Name',
                controller: _lastNameController,
              ).animateOnboarding(index: 6),
              const SizedBox(height: 24),
              
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ).animateOnboarding(index: 7),
              const SizedBox(height: 24),
              
              CountryPhoneField(controller: _phoneController),
              const SizedBox(height: 24),
              
              CustomTextField(
                label: 'Date of Birth',
                hint: 'DD/MM/YYYY',
                controller: _dobController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                onChanged: (value) {
                  // Auto-format as DD/MM/YYYY
                  String text = value.replaceAll('/', '');
                  if (text.length > 8) text = text.substring(0, 8);
                  
                  String formatted = '';
                  for (int i = 0; i < text.length; i++) {
                    if (i == 2 || i == 4) formatted += '/';
                    formatted += text[i];
                  }
                  
                  if (formatted != value) {
                    _dobController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }
                },
              ).animateOnboarding(index: 9),
              const SizedBox(height: 32),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'City',
                      hint: 'Enter City',
                      controller: _cityController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Country',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountry,
                              hint: Text('Select Country', style: TextStyle(color: Colors.grey[400])),
                              isExpanded: true,
                              items: DropdownOptions.countries.map((item) {
                                return DropdownMenuItem(value: item, child: Text(item));
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedCountry = value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animateOnboarding(index: 10),
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
                      onPressed: () {
                        // Pass profile type and gender to next screen
                        context.push('/onboarding/personal-details?profileType=${widget.profileType}&gender=${widget.gender}');
                      },
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

