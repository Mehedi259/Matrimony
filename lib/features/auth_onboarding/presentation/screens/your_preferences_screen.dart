import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/gradient_button.dart';
import '../widgets/onboarding/step_progress_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/common/checkbox_item.dart';
import '../widgets/common/dropdown_field.dart';

class YourPreferencesScreen extends StatefulWidget {
  const YourPreferencesScreen({super.key});

  @override
  State<YourPreferencesScreen> createState() => _YourPreferencesScreenState();
}

class _YourPreferencesScreenState extends State<YourPreferencesScreen> {
  RangeValues _ageRange = const RangeValues(22, 35);

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
              ),
              const SizedBox(height: 8),
              const Text(
                'Let us know what you\'re looking for.',
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
                        'Not required (can skip without filling out)', 
                        style: TextStyle(color: Colors.blue[400]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
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
              
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Preferred Ethnicity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              const SizedBox(height: 16),
              
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search ethnicity',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select (3)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Clear all', style: TextStyle(color: Theme.of(context).primaryColor)),
                ],
              ),
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                children: ['Pakistan', 'Arab', 'Turkish'].map((country) {
                  return Chip(
                    label: Text(country),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {},
                    side: BorderSide.none,
                    labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                    deleteIconColor: Theme.of(context).primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              const CustomDropdownField(label: 'Preference to country of residence (or region)', hint: 'Select residence'),
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

