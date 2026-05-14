import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutExpectationsFormScreen extends StatelessWidget {
  const AboutExpectationsFormScreen({super.key});

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
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 4', isActive: true),
                _buildStepLine(isActive: true),
                _buildStep(context, 'Step 5', isActive: true),
              ],
            ),
            const SizedBox(height: 32),
            
            // Title & Subtitle
            const Text('About you & expectations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text(
              'Help us understand you better.',
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
                  Text('Not required (can skip without filling out)', style: TextStyle(color: Color(0xFF5C71CA), fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Text Areas
            _buildTextArea('Idea of marriage'),
            const SizedBox(height: 24),
            _buildTextArea('Describe your relationship with Islam?'),
            const SizedBox(height: 24),
            _buildTextArea('How do you envision your role as a spouse?'),
            const SizedBox(height: 24),
            _buildTextArea('Tell me a bit about yourself?'),
            const SizedBox(height: 24),
            _buildTextArea('How do you envision your spouse to be?'),
            const SizedBox(height: 24),
            _buildTextArea('How do you envision your marriage to be?'),
            const SizedBox(height: 24),
            _buildTextArea('Preference on spouse\'s religious status?', hintText: 'Ex: Must wear hijab...etc.'),
            const SizedBox(height: 24),
            _buildTextArea('Are you open to relocating?'),
            const SizedBox(height: 24),
            _buildTextArea('Any other preferences?'),
            
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

  Widget _buildTextArea(String label, {String hintText = 'Type here...'}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hintText,
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
}
