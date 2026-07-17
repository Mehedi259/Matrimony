import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalDetailsFormScreen extends StatelessWidget {
  const PersonalDetailsFormScreen({super.key});

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
            FittedBox(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStep(context, 'Step 1', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 2', isActive: true),
                _buildStepLine(),
                _buildStep(context, 'Step 3'),
                _buildStepLine(),
                _buildStep(context, 'Step 4'),
                _buildStepLine(),
                _buildStep(context, 'Step 5'),
              ],
            ),
            ),
            const SizedBox(height: 32),
            
            // Title & Subtitle
            const Text('Personal Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Tell us more about yourself.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            
            // Required Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red[100]!),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emergency, color: Color(0xFFE54B5E), size: 12),
                  SizedBox(width: 4),
                  Text('These fields are required', style: TextStyle(color: Color(0xFFE54B5E), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Form Fields
            _buildDropdownField('Sect', 'Select sect'),
            const SizedBox(height: 24),
            _buildDropdownField('Marital Status', 'Select marital status'),
            const SizedBox(height: 24),
            _buildDropdownField('Ethnicity', 'Select ethnicity'),
            const SizedBox(height: 24),
            _buildDropdownField('Nationality/ Citizenship', 'Select nationality'),
            const SizedBox(height: 24),
            
            _buildDivider('Family & Physical'),
            const SizedBox(height: 16),
            
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Do you have children?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioOption('Yes', isSelected: false),
                const SizedBox(width: 24),
                _buildRadioOption('No', isSelected: true, activeColor: Theme.of(context).primaryColor),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildDropdownField('How many children do you have?', 'Select number'),
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(child: _buildDropdownField('Height', 'Select height')),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdownField('Weight', 'Select weight')),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildDivider('Family & Physical'), // Kept exactly as in screenshot
            const SizedBox(height: 16),
            
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Prayer 5x a day?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioOption('Yes', isSelected: false),
                const SizedBox(width: 16),
                _buildRadioOption('Mostly', isSelected: true, activeColor: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                _buildRadioOption('No', isSelected: false),
              ],
            ),
            const SizedBox(height: 24),
            
            Align(
              alignment: Alignment.centerLeft,
              child: const Text('Are you open to relocating?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRadioOption('Yes', isSelected: false),
                const SizedBox(width: 16),
                _buildRadioOption('Maybe', isSelected: true, activeColor: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                _buildRadioOption('No', isSelected: false),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildDivider('For sisters only'),
            const SizedBox(height: 16),
            
            _buildDropdownField('How do you dress?', 'Select an option'),
            const SizedBox(height: 24),
            
            _buildTextField('Wali Name', 'Enter wali name'),
            const SizedBox(height: 24),
            
            _buildTextField('Wali Relation', 'Enter relation'),
            const SizedBox(height: 24),
            
            _buildTextField('Wali Contact', 'Enter wali number'),
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Divider(color: Colors.black54, thickness: 1),
      ],
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text(hint, style: const TextStyle(color: Colors.black38, fontSize: 14)),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: [],
              onChanged: (val) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String label, {required bool isSelected, Color? activeColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? (activeColor ?? Colors.blue) : Colors.grey[400]!, width: isSelected ? 6 : 1),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.black87, fontSize: 14)),
      ],
    );
  }
}
