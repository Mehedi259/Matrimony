import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';

class DeleteAccountFeedbackScreen extends StatefulWidget {
  final String reason;
  
  const DeleteAccountFeedbackScreen({super.key, this.reason = ''});

  @override
  State<DeleteAccountFeedbackScreen> createState() => _DeleteAccountFeedbackScreenState();
}

class _DeleteAccountFeedbackScreenState extends State<DeleteAccountFeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

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
              controller: _feedbackController,
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
      barrierDismissible: false,
      builder: (dialogContext) => _DeleteConfirmDialog(
        reason: widget.reason,
        feedback: _feedbackController.text,
      ),
    );
  }
}

class _DeleteConfirmDialog extends StatefulWidget {
  final String reason;
  final String feedback;

  const _DeleteConfirmDialog({required this.reason, required this.feedback});

  @override
  State<_DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<_DeleteConfirmDialog> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() => _isLoading = true);
    
    final authProvider = context.read<AuthProvider>();
    
    // First submit why leaving
    final whyLeavingSuccess = await authProvider.submitWhyLeaving(
      reason: widget.reason,
      feedback: widget.feedback,
    );
    
    if (!whyLeavingSuccess) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to submit feedback'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Then delete account
    final deleteSuccess = await authProvider.deleteAccount();
    
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (deleteSuccess) {
      context.pop(); // Close dialog
      context.go('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deleted successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to delete account'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _isLoading ? null : () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFE54B5E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Delete Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE54B5E))),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE54B5E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
