import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/common/checkbox_item.dart';
import '../widgets/common/dropdown_field.dart';
import '../widgets/common/multi_select_field.dart';
import '../../../../core/utils/animation_helper.dart';
import '../../../../core/constants/dropdown_options.dart';

class YourPreferencesScreen extends StatefulWidget {
  const YourPreferencesScreen({super.key});

  @override
  State<YourPreferencesScreen> createState() => _YourPreferencesScreenState();
}

class _YourPreferencesScreenState extends State<YourPreferencesScreen> {
  RangeValues _ageRange = const RangeValues(22, 35);
  List<String> _selectedEthnicities = ['Pakistan', 'Arab', 'Turkish'];
  List<String> _selectedCountries = ['United Kingdom', 'United States'];

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
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Colors.grey[300],
                onChanged: (values) {
                  setState(() {
                    _ageRange = values;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${_ageRange.start.round()}', style: TextStyle(color: Theme.of(context).primaryColor)),
                  const SizedBox(width: 40),
                  Text('${_ageRange.end.round()}', style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
              const SizedBox(height: 24),
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Preferred Marital Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              CustomCheckboxItem(label: 'Never been married', initialValue: true),
              const CustomCheckboxItem(label: 'Married (Polygyny)'),
              const CustomCheckboxItem(label: 'Annulment (Khula)'),
              const CustomCheckboxItem(label: 'Divorced'),
              const CustomCheckboxItem(label: 'Widowed'),
              const SizedBox(height: 24),
              
              MultiSelectField(
                label: 'Preferred Ethnicity',
                options: DropdownOptions.ethnicities,
                selectedValues: _selectedEthnicities,
                searchHint: 'Search ethnicity',
                onChanged: (values) {
                  setState(() {
                    _selectedEthnicities = values;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              MultiSelectField(
                label: 'Preference to country of residence (or region)',
                options: DropdownOptions.countries,
                selectedValues: _selectedCountries,
                searchHint: 'Search country/region',
                onChanged: (values) {
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
                      text: 'Next',
                      onPressed: () => context.push('/onboarding/about-expectations'),
                    ),
                  ),
                ],
              ),
        ],
      ),
    );
  }
}

