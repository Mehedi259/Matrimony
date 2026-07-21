import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/searchable_dropdown.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/multi_select_field.dart';
import '../../../../core/constants/dropdown_options.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../providers/profile_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../core/constants/choice_mappings.dart';

/// Step 2: About You - Personal Details Screen
/// This screen collects detailed demographic and personal information
/// Different fields shown based on user type (Brother/Sister/Wali)
class PersonalDetailsScreenNew extends StatefulWidget {
  final String? userType; // 'brother', 'sister', or 'wali'
  final String? gender; // 'Male' or 'Female'
  final bool isEditing;

  const PersonalDetailsScreenNew({
    super.key,
    this.userType,
    this.gender,
    this.isEditing = false,
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

  // New fields
  String? _education;
  final TextEditingController _employmentController = TextEditingController();
  String? _income;
  String? _frame;
  List<String> _languagesSpoken = [];
  final TextEditingController _healthConcernsController = TextEditingController();
  
  // Sister-specific fields
  String? _dressStyle;
  final TextEditingController _waliNameController = TextEditingController();
  final TextEditingController _waliRelationController = TextEditingController();
  final TextEditingController _waliNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final info = Provider.of<ProfileProvider>(context, listen: false).basicInfo;
    if (info != null) {
      _religionSect = info.sect != null ? ChoiceMappings.keyToDisplay(info.sect!, ChoiceMappings.sectKeyToDisplay) : null;
      _maritalStatus = info.maritalStatus != null ? ChoiceMappings.keyToDisplay(info.maritalStatus!, ChoiceMappings.maritalStatusKeyToDisplay) : null;
      if (info.ethnicity.isNotEmpty) {
        _ethnicity = ChoiceMappings.keyToDisplay(info.ethnicity.first, ChoiceMappings.ethnicityKeyToDisplay);
      }
      if (info.nationality.isNotEmpty) {
        _nationality = ChoiceMappings.keyToDisplay(info.nationality.first, ChoiceMappings.nationalityKeyToDisplay);
      }
      if (info.hasChildren != null) {
        _hasChildren = info.hasChildren! ? 'Yes' : 'No';
      }
      _numberOfChildren = info.childrenCount != null ? ChoiceMappings.keyToDisplay(info.childrenCount!, ChoiceMappings.childrenCountKeyToDisplay) : null;
      _height = info.height;
      _weight = info.weight;
      _prayerFrequency = info.pray5x != null ? ChoiceMappings.keyToDisplay(info.pray5x!, ChoiceMappings.prayerKeyToDisplay) : null;
      _openToRelocating = info.openToRelocate != null ? ChoiceMappings.keyToDisplay(info.openToRelocate!, ChoiceMappings.relocationKeyToDisplay) : null;
      
      _education = info.education != null ? ChoiceMappings.keyToDisplay(info.education!, ChoiceMappings.educationKeyToDisplay) : null;
      _employmentController.text = info.employment ?? '';
      _income = info.income != null ? ChoiceMappings.keyToDisplay(info.income!, ChoiceMappings.incomeKeyToDisplay) : null;
      _frame = info.frame != null ? ChoiceMappings.keyToDisplay(info.frame!, ChoiceMappings.frameKeyToDisplay) : null;
      _healthConcernsController.text = info.healthConcerns ?? '';
      if (info.languagesSpoken.isNotEmpty) {
        _languagesSpoken = ChoiceMappings.keysToDisplays(info.languagesSpoken, ChoiceMappings.languageKeyToDisplay);
      }
    }
  }

  @override
  void dispose() {
    _waliNameController.dispose();
    _waliRelationController.dispose();
    _waliNumberController.dispose();
    _employmentController.dispose();
    _healthConcernsController.dispose();
    super.dispose();
  }

  bool get isSister {
    if (widget.gender == 'Female' || widget.userType == 'sister') return true;
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    return user?.role == 'female' || user?.gender == 'female';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
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
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Education',
            value: _education,
            items: ChoiceMappings.educationDisplayToKey.keys.toList(),
            onChanged: (value) => setState(() => _education = value),
            isRequired: false,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Employment / Profession',
            hint: 'What do you do for work?',
            controller: _employmentController,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Income',
            value: _income,
            items: ChoiceMappings.incomeDisplayToKey.keys.toList(),
            onChanged: (value) => setState(() => _income = value),
            isRequired: false,
          ),
          const SizedBox(height: 16),
          _buildDropdown(
            label: 'Frame / Build',
            value: _frame,
            items: ChoiceMappings.frameDisplayToKey.keys.toList(),
            onChanged: (value) => setState(() => _frame = value),
            isRequired: false,
          ),
          const SizedBox(height: 16),
          MultiSelectField(
            label: 'Languages Spoken',
            options: ChoiceMappings.languageDisplayToKey.keys.toList(),
            selectedValues: _languagesSpoken,
            onChanged: (values) => setState(() => _languagesSpoken = values),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Health Concerns',
            hint: 'Any health concerns? (Optional, write None if NA)',
            controller: _healthConcernsController,
          ),
          const SizedBox(height: 16),
          
          _buildDropdown(
            label: 'Religion/Sect',
            value: _religionSect,
            items: DropdownOptions.religionSect,
            onChanged: (value) => setState(() => _religionSect = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
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
          
          SearchableDropdown(
            label: 'Ethnicity',
            value: _ethnicity,
            items: DropdownOptions.ethnicities,
            onChanged: (value) => setState(() => _ethnicity = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          SearchableDropdown(
            label: 'Nationality / Citizenship',
            value: _nationality,
            items: DropdownOptions.nationalities,
            onChanged: (value) => setState(() => _nationality = value),
            hint: 'This is referring to the Passport(s) you hold',
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
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
          
          _buildDropdown(
            label: 'Height',
            value: _height,
            items: isSister ? DropdownOptions.sisterHeights : DropdownOptions.brotherHeights,
            onChanged: (value) => setState(() => _height = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          _buildDropdown(
            label: 'Weight',
            value: _weight,
            items: isSister ? DropdownOptions.sisterWeights : DropdownOptions.brotherWeights,
            onChanged: (value) => setState(() => _weight = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          _buildDropdown(
            label: 'Pray 5x a day?',
            value: _prayerFrequency,
            items: DropdownOptions.prayerFrequency,
            onChanged: (value) => setState(() => _prayerFrequency = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          _buildDropdown(
            label: 'Are you open to relocating?',
            value: _openToRelocating,
            items: DropdownOptions.relocationOptions,
            onChanged: (value) => setState(() => _openToRelocating = value),
            isRequired: true,
          ),
          const SizedBox(height: 24),
          
          if (isSister) ...[
            _buildDropdown(
              label: 'How do you dress?',
              value: _dressStyle,
              items: DropdownOptions.dressStyle,
              onChanged: (value) => setState(() => _dressStyle = value),
              isRequired: true,
            ),
            const SizedBox(height: 32),
            
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
                  text: widget.isEditing ? 'Save Changes' : 'Continue',
                  onPressed: _saveAndContinue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

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

  void _saveAndContinue() async {
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
      SnackBarHelper.showError(context, 'Please fill all required fields');
      return;
    }

    if (isSister) {
      if (_dressStyle == null ||
          _waliNameController.text.isEmpty ||
          _waliRelationController.text.isEmpty ||
          _waliNumberController.text.isEmpty) {
        SnackBarHelper.showError(context, 'Please fill all required fields including Wali information');
        return;
      }
    }

    // If children selected, validate number
    if (_hasChildren == 'Yes' && _numberOfChildren == null) {
      SnackBarHelper.showError(context, 'Please specify the number of children');
      return;
    }

    Map<String, dynamic> data = {
      'sect': ChoiceMappings.displayToKey(_religionSect!, ChoiceMappings.sectDisplayToKey),
      'marital_status': ChoiceMappings.displayToKey(_maritalStatus!, ChoiceMappings.maritalStatusDisplayToKey),
      'ethnicity': [ChoiceMappings.displayToKey(_ethnicity!, ChoiceMappings.ethnicityDisplayToKey)],
      'nationality': [ChoiceMappings.displayToKey(_nationality!, ChoiceMappings.nationalityDisplayToKey)],
      'has_children': _hasChildren == 'Yes',
      'children_count': _hasChildren == 'Yes' ? ChoiceMappings.displayToKey(_numberOfChildren!, ChoiceMappings.childrenCountDisplayToKey) : null,
      'height': _height,
      'weight': _weight,
      'pray_5x': ChoiceMappings.displayToKey(_prayerFrequency!, ChoiceMappings.prayerDisplayToKey),
      'open_to_relocate': ChoiceMappings.displayToKey(_openToRelocating!, ChoiceMappings.relocationDisplayToKey),
    };

    if (_education != null) data['education'] = ChoiceMappings.displayToKey(_education!, ChoiceMappings.educationDisplayToKey);
    if (_employmentController.text.isNotEmpty) data['employment'] = _employmentController.text;
    if (_income != null) data['income'] = ChoiceMappings.displayToKey(_income!, ChoiceMappings.incomeDisplayToKey);
    if (_frame != null) data['frame'] = ChoiceMappings.displayToKey(_frame!, ChoiceMappings.frameDisplayToKey);
    if (_healthConcernsController.text.isNotEmpty) data['health_concerns'] = _healthConcernsController.text;
    if (_languagesSpoken.isNotEmpty) {
      data['languages_spoken'] = ChoiceMappings.displaysToKeys(_languagesSpoken, ChoiceMappings.languageDisplayToKey);
    }

    if (isSister) {
      data['dress'] = ChoiceMappings.displayToKey(_dressStyle!, ChoiceMappings.dressDisplayToKey);
      data['wali_name'] = _waliNameController.text;
      data['wali_relation'] = _waliRelationController.text;
      data['wali_number'] = _waliNumberController.text;
    }

    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final success = await profileProvider.updateBasicInfo(data);
    
    if (success && mounted) {
      SnackBarHelper.showSuccess(context, 'Personal Details saved successfully');
      if (widget.isEditing) {
        context.pop();
      } else {
        context.push('/onboarding/preferences');
      }
    } else if (mounted) {
      SnackBarHelper.showError(context, profileProvider.errorMessage ?? 'Failed to save Personal Details');
    }
  }
}
