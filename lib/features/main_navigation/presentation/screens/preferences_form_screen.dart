import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/dropdown_options.dart';
import '../../../auth_onboarding/presentation/widgets/common/multi_select_field.dart';

class PreferencesFormScreen extends StatefulWidget {
  const PreferencesFormScreen({super.key});

  @override
  State<PreferencesFormScreen> createState() => _PreferencesFormScreenState();
}

class _PreferencesFormScreenState extends State<PreferencesFormScreen> {
  List<String> _selectedEthnicities = ['Pakistan', 'Arab', 'Turkish'];
  List<String> _selectedCountries = ['United Kingdom', 'United States'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(context, 'Step 1', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 2', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 3', isActive: true),
                _buildStepLine(),
                _buildStep(context, 'Step 4'),
                _buildStepLine(),
                _buildStep(context, 'Step 5'),
              ],
            ),
            const SizedBox(height: 32),
            
            // Title & Subtitle
            const Text('Your Preferences', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Let us know what you\'re looking for.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            
            // Not Required Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[100]!),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.info, color: Color(0xFF5C71CA), size: 14),
                  SizedBox(width: 6),
                  Text('These fields are optional.', style: TextStyle(color: Color(0xFF5C71CA), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Age Range
            _buildDivider('Preferred Age Range'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('18', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('60+', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            RangeSlider(
              values: const RangeValues(22, 35),
              min: 18,
              max: 60,
              activeColor: Theme.of(context).primaryColor.withOpacity(0.6),
              inactiveColor: Colors.grey[300],
              onChanged: (RangeValues values) {},
            ),
            Row(
              children: [
                Expanded(child: Text('22', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
                Expanded(child: Text('35', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Container()), // empty space for alignment
              ],
            ),
            const SizedBox(height: 32),
            
            // Marital Status
            _buildDivider('Preferred Marital Status'),
            const SizedBox(height: 16),
            _buildCheckbox('Never been married', isChecked: true),
            _buildCheckbox('Married (Polygyny)', isChecked: false),
            _buildCheckbox('Annulment (Khula)', isChecked: false),
            _buildCheckbox('Divorced', isChecked: false),
            _buildCheckbox('Widowed', isChecked: false),
            const SizedBox(height: 24),
            
            // Preferred Ethnicity
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
            const SizedBox(height: 32),
            
            // Country of residence
            MultiSelectField(
              label: 'Preference to country of residence (or region)',
              options: DropdownOptions.nationalities,
              selectedValues: _selectedCountries,
              searchHint: 'Search country/region',
              onChanged: (values) {
                setState(() {
                  _selectedCountries = values;
                });
              },
            ),
            
            const SizedBox(height: 32),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            
            // Bottom Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEEF0F2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Back', style: TextStyle(color: Color(0xFF9C91B8), fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor.withOpacity(0.6) : const Color(0xFFF2F4F7),
        shape: BoxShape.circle,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontSize: 10,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStepLine({bool isActive = false}) {
    return Container(
      width: 20,
      height: 2,
      color: isActive ? const Color(0xFFCD868A) : const Color(0xFFF2F4F7),
    );
  }

  Widget _buildDivider(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16)),
        const SizedBox(height: 4),
        Divider(color: Colors.black54, thickness: 1),
      ],
    );
  }

  Widget _buildCheckbox(String label, {required bool isChecked}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isChecked ? const Color(0xFFCD868A) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isChecked ? const Color(0xFFCD868A) : Colors.grey[300]!),
            ),
            child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }
}
