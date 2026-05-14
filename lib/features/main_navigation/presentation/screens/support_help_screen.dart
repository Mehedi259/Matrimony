import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Support & Help', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildActionItem('FAQs'),
          const SizedBox(height: 16),
          _buildActionItem('Contact Support'),
          const SizedBox(height: 16),
          _buildActionItem('Submit Feedback'),
          const SizedBox(height: 16),
          _buildActionItem('Privacy Policy'),
          const SizedBox(height: 16),
          _buildActionItem('Terms & Conditions'),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(color: Colors.black87, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
