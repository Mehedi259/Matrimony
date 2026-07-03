import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeleteAccountFeedbackScreen extends StatelessWidget {
  const DeleteAccountFeedbackScreen({super.key});

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
            const Text(
              'Want to tell us more?\nYour opinion matters.',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you found your match through us, let us know. We would like to send you a wedding gift.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            TextField(
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write a message',
                hintStyle: const TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black87),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE54B5E).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Please note:',
                    style: TextStyle(
                      color: Color(0xFFE54B5E),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Deleting your account will prevent you from receiving future matches through our private matchmaking service. If you\'d still like to receive matches, deactivate instead.',
                    style: TextStyle(
                      color: Color(0xFFE54B5E),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2. Your account will be permanently deleted and all your data will be erased.',
                    style: TextStyle(
                      color: Color(0xFFE54B5E),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
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
                onPressed: () => _showDeleteDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Confirm deletion', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE54B5E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 24),
              const Text('Delete Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE54B5E))),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.pop(); // Close dialog
                    // Add actual deletion logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE54B5E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
