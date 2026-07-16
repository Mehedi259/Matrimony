import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasicInformationFormScreen extends StatelessWidget {
  const BasicInformationFormScreen({super.key});

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
                _buildStepLine(),
                _buildStep(context, 'Step 2'),
                _buildStepLine(),
                _buildStep(context, 'Step 3'),
                _buildStepLine(),
                _buildStep(context, 'Step 4'),
                _buildStepLine(),
                _buildStep(context, 'Step 5'),
              ],
            ),
            const SizedBox(height: 32),
            
            // Title & Subtitle
            const Text('Basic Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Your privacy is important. Your name,\ncontact details and photos are hidden.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFFE57C04)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Name, Date of Birth, Phone Number, and Gender cannot be changed after registration. Please contact support if you would like to make any changes.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFE57C04)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Form Fields
            _buildDropdownField('How did you find us?*', 'Select an option'),
            const SizedBox(height: 24),
            
            // Gender Radio (Locked)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(width: 6),
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            IgnorePointer(
              child: Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    _buildRadioOption('Male', isSelected: false),
                    const SizedBox(width: 24),
                    _buildRadioOption('Female', isSelected: true, activeColor: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildLockedTextField('First Name', 'First Name'),
            const SizedBox(height: 24),
            
            _buildLockedTextField('Last Name', 'Last Name'),
            const SizedBox(height: 24),
            
            _buildTextField('Email', 'Enter your email address'),
            const SizedBox(height: 24),
            
            // Phone Number (Locked)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(width: 6),
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            IgnorePointer(
              child: Opacity(
                opacity: 0.6,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                      ),
                      child: const Text('+44', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: '1234567',
                          hintStyle: const TextStyle(color: Colors.black38),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Date of Birth (Locked)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: const [
                  Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(width: 6),
                  Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'DD / MM / YYYY',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: const Color(0xFFEEEEEE),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
              ),
            ),
            const SizedBox(height: 24),
            
            // Location Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('City', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter City',
                          hintStyle: const TextStyle(color: Colors.black38),
                          filled: true,
                          fillColor: const Color(0xFFF9F9F9),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.grey, size: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Country', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
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
                            hint: const Text('Select Country', style: TextStyle(color: Colors.black38, fontSize: 14)),
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            items: [],
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                        colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)], // Purple to pink gradient
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

  Widget _buildStepLine() {
    return Container(
      width: 20,
      height: 2,
      color: const Color(0xFFF2F4F7),
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
  Widget _buildLockedTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38),
            filled: true,
            fillColor: const Color(0xFFEEEEEE),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
            disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey[300]!)),
          ),
        ),
      ],
    );
  }
}
