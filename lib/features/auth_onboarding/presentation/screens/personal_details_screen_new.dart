import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/searchable_dropdown.dart';
import '../widgets/common/custom_text_field.dart';
import '../../../../core/constants/dropdown_options.dart';

/// Step 2: About You - Personal Details Screen
/// This screen collects detailed demographic and personal information
/// Different fields shown based on user type (Brother/Sister/Wali)
class PersonalDetailsScreenNew extends StatefulWidget {
  final String? userType; // 'brother', 'sister', or 'wali'
  final String? gender; // 'Male' or 'Female'

  const PersonalDetailsScreenNew({
    super.key,
    this.userType,
    this.gender,
  });

  @override
  State<PersonalDetailsScreenNew> createState() => _PersonalDetailsScreenNewState();
}

class _PersonalDetailsScreenNewState extends State<PersonalDetailsScreenNew> {
  // Form controllers and values
  String? _religionSect;
  String? _maritalStatus;
  String? _ethnicity;
  String? _nationality;
  String? _hasChildren;
  String? _numberOfChildren;
  String? _height;
  String? _weight;
  String? _prayerFrequency;
  String? _openToRelocating;
  
  // Sister-specific fields
  String? _dressStyle;
  final TextEditingController _waliNameController = TextEditingController();
  final TextEditingController _waliRelationController = TextEditingController();
  final TextEditingController _waliNumberController = TextEditingController();

  @override
  void dispose() {
    _waliNameController.dispose();
    _waliRelationController.dispose();
    _waliNumberController.dispose();
    super.dispose();
  }

  bool get isSister => widget.gender == 'Female' || widget.userType == 'sister';
  bool get isBrother => widget.gender == 'Male' || widget.userType == 'brother';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Header
          const Center(
            child: Text(
              'About You',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Help us understand you better',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 32),
          
          // Religion/Sect
          _buildDropdown(
            label: 'Religion/Sect',
            value: _religionSect,
            items: DropdownOptions.religionSect,
            onChanged: (value) => setState(() => _religionSect = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Marital Status
          _buildDropdown(
            label: 'Marital Status',
            value: _maritalStatus,
            items: widget.gender == 'Male' 
              ? DropdownOptions.maritalStatusBrother 
              : DropdownOptions.maritalStatusSister,
            onChanged: (value) => setState(() => _maritalStatus = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Ethnicity (Searchable)
          SearchableDropdown(
            label: 'Ethnicity',
            value: _ethnicity,
            items: DropdownOptions.ethnicities,
            onChanged: (value) => setState(() => _ethnicity = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Nationality/Citizenship (Searchable)
          SearchableDropdown(
            label: 'Nationality / Citizenship',
            value: _nationality,
            items: DropdownOptions.nationalities,
            onChanged: (value) => setState(() => _nationality = value),
            hint: 'This is referring to the Passport(s) you hold',
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Do you have children?
          _buildDropdown(
            label: 'Do you have children?',
            value: _hasChildren,
            items: DropdownOptions.yesNo,
            onChanged: (value) {
              setState(() {
                _hasChildren = value;
                if (value == 'No') {
                  _numberOfChildren = null;
                }
              });
            },
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // How many children? (conditional)
          if (_hasChildren == 'Yes') ...[
            _buildDropdown(
              label: 'How many children do you have?',
              value: _numberOfChildren,
              items: DropdownOptions.childrenCount,
              onChanged: (value) => setState(() => _numberOfChildren = value),
              isRequired: true,
            ),
            const SizedBox(height: 24),
          ],
          
          // Height
          _buildDropdown(
            label: 'Height',
            value: _height,
            items: isSister ? DropdownOptions.sisterHeights : DropdownOptions.brotherHeights,
            onChanged: (value) => setState(() => _height = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Weight
          _buildDropdown(
            label: 'Weight',
            value: _weight,
            items: isSister ? DropdownOptions.sisterWeights : DropdownOptions.brotherWeights,
            onChanged: (value) => setState(() => _weight = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Pray 5x a day?
          _buildDropdown(
            label: 'Pray 5x a day?',
            value: _prayerFrequency,
            items: DropdownOptions.prayerFrequency,
            onChanged: (value) => setState(() => _prayerFrequency = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Are you open to relocating?
          _buildDropdown(
            label: 'Are you open to relocating?',
            value: _openToRelocating,
            items: DropdownOptions.relocationOptions,
            onChanged: (value) => setState(() => _openToRelocating = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          // Sister-specific fields
          if (isSister) ...[
            // How do you dress?
            _buildDropdown(
              label: 'How do you dress?',
              value: _dressStyle,
              items: DropdownOptions.dressStyle,
              onChanged: (value) => setState(() => _dressStyle = value),
              isRequired: true,
            ),
            const SizedBox(height: 32),
            
            // Wali Information Section
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            const Text(
              'Wali (Guardian) Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your guardian\'s contact information',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            
            CustomTextField(
              label: 'Wali Name',
              hint: 'Full name',
              controller: _waliNameController,
            ),
            const SizedBox(height: 24),
            
            CustomTextField(
              label: 'Wali Relation',
              hint: 'e.g., Father, Brother, Uncle',
              controller: _waliRelationController,
            ),
            const SizedBox(height: 24),
            
            CustomTextField(
              label: 'Wali Number',
              hint: 'Phone number',
              controller: _waliNumberController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
          ],
          
          const SizedBox(height: 32),
          
          // Navigation Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GradientButton(
                  text: 'Next',
                  onPressed: _validateAndProceed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // Helper method to build dropdown fields
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            children: [
              if (isRequired)
                const TextSpan(
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
              value: value,
              hint: Text(
                'Select $label',
                style: TextStyle(color: Colors.grey[400]),
              ),
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _validateAndProceed() {
    // Validate required fields
    if (_religionSect == null ||
        _maritalStatus == null ||
        _ethnicity == null ||
        _nationality == null ||
        _hasChildren == null ||
        _height == null ||
        _weight == null ||
        _prayerFrequency == null ||
        _openToRelocating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Sister-specific validation
    if (isSister) {
      if (_dressStyle == null ||
          _waliNameController.text.isEmpty ||
          _waliRelationController.text.isEmpty ||
          _waliNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields including Wali information'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // If children selected, validate number
    if (_hasChildren == 'Yes' && _numberOfChildren == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please specify the number of children'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Save data to state management
    // Navigate to next step
    context.push('/onboarding/preferences');
  }
}
