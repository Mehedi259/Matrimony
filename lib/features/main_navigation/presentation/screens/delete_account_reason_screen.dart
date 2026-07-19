import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountReasonScreen extends StatefulWidget {
  const DeleteAccountReasonScreen({super.key});

  @override
  State<DeleteAccountReasonScreen> createState() => _DeleteAccountReasonScreenState();
}

class _DeleteAccountReasonScreenState extends State<DeleteAccountReasonScreen> {
  String? _selectedReason;

  final List<String> _reasons = [
    'Getting married',
    'Need a break',
    'Ghosting',
    'Create a new account',
    'False profiles',
    'Couldn\'t find a match',
    'Too many notifications',
    'Profiles don\'t meet my preferences',
    'Subscription too expensive',
    'Got married elsewhere',
    'Other',
  ];

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
            const Text('Please select a reason', style: TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _reasons.map((reason) => _buildChip(reason)).toList(),
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
                color: _selectedReason == null ? Colors.grey[400] : null,
                gradient: _selectedReason == null ? null : const LinearGradient(
                  colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: _selectedReason == null ? null : () {
                  context.push('/settings/security/delete-account-feedback?reason=${Uri.encodeComponent(_selectedReason!)}');
                },
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

  Widget _buildChip(String label) {
    final isSelected = _selectedReason == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCD868A) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
