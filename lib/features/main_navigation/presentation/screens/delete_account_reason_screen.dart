import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountReasonScreen extends StatelessWidget {
  const DeleteAccountReasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Why are you leaving?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            const Text('My selection : 3/3', style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: [
                _buildChip('Getting married', isSelected: true),
                _buildChip('Need a break', isSelected: true),
                _buildChip('Ghosting', isSelected: true),
                _buildChip('Create a new account'),
                _buildChip('False profiles'),
                _buildChip('Couldn\'t find a match'),
                _buildChip('Too many notifications'),
                _buildChip('Profiles don\'t meet my peferences'),
                _buildChip('Subscription too expensive'),
                _buildChip('Other'),
                _buildChip('Got married elsewhere'),
              ],
            ),
            const Spacer(),
            const Text(
              'Your account will be permanently deleted and all your data will be erased.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () => context.push('/settings/security/delete-account-feedback'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFCD868A) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black87 : Colors.black87,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
