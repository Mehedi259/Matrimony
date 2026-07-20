import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/common/checkbox_item.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/multi_select_field.dart';
import '../../../../core/utils/animation_helper.dart';
import '../../../../core/constants/dropdown_options.dart';
import '../../../../core/constants/choice_mappings.dart';
import '../../../../providers/profile_provider.dart';
import 'package:get/get.dart';

class YourPreferencesScreen extends StatefulWidget {
  const YourPreferencesScreen({super.key});

  @override
  State<YourPreferencesScreen> createState() => _YourPreferencesScreenState();
}

class _YourPreferencesScreenState extends State<YourPreferencesScreen> {
  RangeValues _ageRange = const RangeValues(22, 35);
  List<String> _selectedEthnicities = [];
  List<String> _selectedCountries = [];
  Map<String, bool> _maritalStatusPrefs = {
    'Never been married': true,
    'Married (Polygyny)': false,
    'Annulment (Khula)': false,
    'Divorced': false,
    'Widowed': false,
  };
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingData();
    });
  }

  Future<void> _loadExistingData() async {
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadBasicInfo();
    
    if (profileProvider.basicInfo != null) {
      final info = profileProvider.basicInfo!;
      setState(() {
        _ageRange = RangeValues(
          (info.prefAgeMin ?? 22).toDouble(),
          (info.prefAgeMax ?? 35).toDouble(),
        );
        // Convert backend keys to display labels
        _selectedEthnicities = ChoiceMappings.keysToDisplays(
          info.prefEthnicity, ChoiceMappings.ethnicityKeyToDisplay,
        );
        _selectedCountries = ChoiceMappings.keysToDisplays(
          info.prefCountryOfResidence, ChoiceMappings.nationalityKeyToDisplay,
        );
        
        // Update marital status preferences (convert keys to display labels)
        for (var statusKey in info.prefMaritalStatus) {
          final display = ChoiceMappings.keyToDisplay(
            statusKey, ChoiceMappings.maritalStatusKeyToDisplay,
          );
          if (_maritalStatusPrefs.containsKey(display)) {
            _maritalStatusPrefs[display] = true;
          }
        }
      });
    }
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);

    // Get selected marital statuses and convert display labels to backend keys
    final selectedMaritalStatuses = _maritalStatusPrefs.entries
        .where((entry) => entry.value)
        .map((entry) => ChoiceMappings.displayToKey(
              entry.key, ChoiceMappings.maritalStatusDisplayToKey))
        .toList();

    final data = {
      'pref_age_min': _ageRange.start.round(),
      'pref_age_max': _ageRange.end.round(),
      'pref_marital_status': selectedMaritalStatuses,
      'pref_ethnicity': ChoiceMappings.displaysToKeys(
        _selectedEthnicities, ChoiceMappings.ethnicityDisplayToKey,
      ),
      'pref_country_of_residence': ChoiceMappings.displaysToKeys(
        _selectedCountries, ChoiceMappings.nationalityDisplayToKey,
      ),
    };

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.updateBasicInfo(data);

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      context.push('/onboarding/about-expectations');
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(profileProvider.errorMessage ?? 'Failed to save data'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            'Your Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ).animateOnboarding(index: 0),
          const SizedBox(height: 8),
          const Text(
            'Let us know what you\'re looking for.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ).animateOnboarding(index: 1),
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
          ).animateOnboarding(index: 2),
          const SizedBox(height: 32),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Preferred Age Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('18', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('60+', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          RangeSlider(
            values: _ageRange,
            min: 18,
            max: 60,
            divisions: 42,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              _ageRange.start.round().toString(),
              _ageRange.end.round().toString(),
            ),
            onChanged: (values) {
              setState(() {
                _ageRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${_ageRange.start.round()}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 40),
              Text('${_ageRange.end.round()}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 24),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Preferred Marital Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(),
          const SizedBox(height: 16),
          
          ..._maritalStatusPrefs.keys.map((status) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _maritalStatusPrefs[status] = !_maritalStatusPrefs[status]!;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _maritalStatusPrefs[status],
                      onChanged: (value) {
                        setState(() {
                          _maritalStatusPrefs[status] = value ?? false;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(status, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          
          _buildMultiSelect(
            'Preferred Ethnicity',
            _selectedEthnicities,
            DropdownOptions.ethnicities,
            (values) {
              setState(() {
                _selectedEthnicities = values;
              });
            },
          ),
          const SizedBox(height: 24),
          
          _buildMultiSelect(
            'Preference to country of residence (or region)',
            _selectedCountries,
            DropdownOptions.nationalities,
            (values) {
              setState(() {
                _selectedCountries = values;
              });
            },
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
                title: label,
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
                    style: TextStyle(
                      color: selected.isEmpty ? Colors.grey[400] : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (selected.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selected.map((item) {
              return Chip(
                label: Text(item, style: const TextStyle(fontSize: 12)),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  final newList = List<String>.from(selected);
                  newList.remove(item);
                  onChanged(newList);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// Multi-select dialog with search
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
  late List<String> _filteredOptions;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedValues);
    _filteredOptions = List.from(widget.options);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOptions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = List.from(widget.options);
      } else {
        _filteredOptions = widget.options
            .where((option) => option.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _filterOptions,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
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
          ],
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
