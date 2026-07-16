import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/radio_group.dart';
import '../../../../core/utils/animation_helper.dart';
import '../../../../core/constants/dropdown_options.dart';
import '../../../../providers/profile_provider.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final String? profileType;
  final String? gender;
  
  const PersonalDetailsScreen({
    super.key,
    this.profileType,
    this.gender,
  });

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  String? _selectedSect;
  String? _selectedMaritalStatus;
  List<String> _selectedEthnicities = [];
  List<String> _selectedNationalities = [];
  String? _hasChildren = 'No';
  String? _childrenCount;
  String? _selectedHeight;
  String? _selectedWeight;
  String? _pray5x = 'Mostly';
  String? _openToRelocate = 'Maybe';
  String? _preferredDress;
  
  final TextEditingController _waliNameController = TextEditingController();
  final TextEditingController _waliRelationController = TextEditingController();
  final TextEditingController _waliContactController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  @override
  void dispose() {
    _waliNameController.dispose();
    _waliRelationController.dispose();
    _waliContactController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadBasicInfo();
    
    if (profileProvider.basicInfo != null) {
      final info = profileProvider.basicInfo!;
      setState(() {
        _selectedSect = info.sect;
        _selectedMaritalStatus = info.maritalStatus;
        _selectedEthnicities = info.ethnicity;
        _selectedNationalities = info.nationality;
        _hasChildren = info.hasChildren == true ? 'Yes' : 'No';
        _childrenCount = info.childrenCount;
        _selectedHeight = info.height;
        _selectedWeight = info.weight;
        _pray5x = info.pray5x ?? 'Mostly';
        _openToRelocate = info.openToRelocate ?? 'Maybe';
        _preferredDress = info.preferredDress;
      });
    }
  }

  Future<void> _saveAndContinue() async {
    // Validate required fields
    if (_selectedSect == null || _selectedMaritalStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final data = {
      'sect': _selectedSect,
      'marital_status': _selectedMaritalStatus,
      'ethnicity': _selectedEthnicities,
      'nationality': _selectedNationalities,
      'has_children': _hasChildren == 'Yes',
      'children_count': _hasChildren == 'Yes' ? _childrenCount : null,
      'height': _selectedHeight,
      'weight': _selectedWeight,
      'pray_5x': _pray5x,
      'open_to_relocate': _openToRelocate,
      'preferred_dress': widget.gender == 'Female' || widget.profileType == 'wali' ? _preferredDress : null,
    };

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.updateBasicInfo(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      context.push('/onboarding/preferences');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(profileProvider.errorMessage ?? 'Failed to save data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final showWaliSection = widget.gender == 'Female' || widget.profileType == 'wali';
    
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
          
          _buildDropdown('Sect', _selectedSect, DropdownOptions.religionSect, (value) {
            setState(() => _selectedSect = value);
          }, isRequired: true).animateOnboarding(index: 3),
          const SizedBox(height: 24),
          
          _buildDropdown('Marital Status', _selectedMaritalStatus, DropdownOptions.maritalStatus, (value) {
            setState(() => _selectedMaritalStatus = value);
          }, isRequired: true).animateOnboarding(index: 4),
          const SizedBox(height: 24),
          
          _buildMultiSelect('Ethnicity', _selectedEthnicities, DropdownOptions.ethnicities, (values) {
            setState(() => _selectedEthnicities = values);
          }).animateOnboarding(index: 5),
          const SizedBox(height: 24),
          
          _buildMultiSelect('Nationality / Citizenship', _selectedNationalities, DropdownOptions.nationalities, (values) {
            setState(() => _selectedNationalities = values);
          }).animateOnboarding(index: 6),
          const SizedBox(height: 32),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Family & Physical', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          _buildRadioGroup('Do you have children?', ['Yes', 'No'], _hasChildren!, (value) {
            setState(() {
              _hasChildren = value;
              if (value == 'No') _childrenCount = null;
            });
          }),
          const SizedBox(height: 24),
          
          if (_hasChildren == 'Yes') ...[
            _buildDropdown('How many children do you have?', _childrenCount, 
              ['1', '2', '3', '4', '5', '6+'], (value) {
              setState(() => _childrenCount = value);
            }),
            const SizedBox(height: 24),
          ],
          
          Row(
            children: [
              Expanded(
                child: _buildDropdown('Height', _selectedHeight, widget.gender == 'Female' ? DropdownOptions.sisterHeights : DropdownOptions.brotherHeights, (value) {
                  setState(() => _selectedHeight = value);
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Weight', _selectedWeight, widget.gender == 'Female' ? DropdownOptions.sisterWeights : DropdownOptions.brotherWeights, (value) {
                  setState(() => _selectedWeight = value);
                }),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Religious Practice', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          _buildRadioGroup('Prayer 5x a day?', ['Yes', 'Mostly', 'No'], _pray5x!, (value) {
            setState(() => _pray5x = value);
          }),
          const SizedBox(height: 24),
          
          _buildRadioGroup('Are you open to relocating?', ['Yes', 'Maybe', 'No'], _openToRelocate!, (value) {
            setState(() => _openToRelocate = value);
          }),
          const SizedBox(height: 32),
          
          if (showWaliSection) ...[
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('For sisters only', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            const SizedBox(height: 16),
            
            _buildDropdown('How do you dress?', _preferredDress, DropdownOptions.dressStyle, (value) {
              setState(() => _preferredDress = value);
            }),
            const SizedBox(height: 24),
            
            CustomTextField(
              label: 'Wali Name',
              hint: 'Enter wali name',
              controller: _waliNameController,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Wali Relation',
              hint: 'Enter relation',
              controller: _waliRelationController,
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Wali Contact',
              hint: 'Enter wali number',
              controller: _waliContactController,
            ),
            const SizedBox(height: 32),
          ],
          
          const SizedBox(height: 16),
          
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
                  text: _isLoading ? 'Saving...' : 'Next',
                  onPressed: _isLoading ? null : _saveAndContinue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> options, Function(String?) onChanged, {bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
            children: isRequired ? [
              const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ] : [],
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
              hint: Text('Select $label', style: TextStyle(color: Colors.grey[400])),
              isExpanded: true,
              items: options.map((item) {
                return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelect(String label, List<String> selected, List<String> options, Function(List<String>) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final result = await showDialog<List<String>>(
              context: context,
              builder: (context) => _MultiSelectDialog(
                title: 'Select $label',
                options: options,
                selectedValues: selected,
              ),
            );
            if (result != null) {
              onChanged(result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected.isEmpty ? 'Select $label' : '${selected.length} selected',
                    style: TextStyle(color: selected.isEmpty ? Colors.grey[400] : Colors.black87, fontSize: 14),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup(String label, List<String> options, String selected, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: options.map((option) {
            final isSelected = selected == option;
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(option),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Theme.of(context).primaryColor : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: Text(
                    option,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Multi-select dialog
class _MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> selectedValues;

  const _MultiSelectDialog({
    required this.title,
    required this.options,
    required this.selectedValues,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final option = widget.options[index];
            final isSelected = _tempSelected.contains(option);
            return CheckboxListTile(
              title: Text(option),
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _tempSelected.add(option);
                  } else {
                    _tempSelected.remove(option);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _tempSelected),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
