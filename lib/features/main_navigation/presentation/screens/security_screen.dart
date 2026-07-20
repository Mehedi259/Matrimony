import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
        title: const Text('Security', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildActionItem(
            title: 'Change Password',
            icon: Icons.chevron_right,
            onTap: () => context.push('/settings/security/change-password'),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            title: 'Change Email',
            icon: Icons.chevron_right,
            onTap: () => context.push('/chat-with-admin'),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            title: 'Deactive Account',
            icon: Icons.do_not_disturb_alt,
            isDestructive: true,
            onTap: () => _showDeactivateDialog(context),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            title: 'Delete Account',
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: () => context.push('/settings/security/delete-account-reason'),
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _DeactivateDialog(),
    );
  }

  Widget _buildActionItem({required String title, required IconData icon, required VoidCallback onTap, bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? const Color(0xFFE54B5E) : Colors.black87,
                fontWeight: isDestructive ? FontWeight.normal : FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Icon(icon, color: isDestructive ? const Color(0xFFE54B5E) : Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DeactivateDialog extends StatefulWidget {
  const _DeactivateDialog();

  @override
  State<_DeactivateDialog> createState() => _DeactivateDialogState();
}

class _DeactivateDialogState extends State<_DeactivateDialog> {
  bool _isLoading = false;

  Future<void> _handleDeactivate() async {
    setState(() => _isLoading = true);
    
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.deactivateAccount();
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    if (success) {
      context.pop(); // Close dialog
      context.go('/login'); // Navigate to login
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Account deactivated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(authProvider.errorMessage ?? 'Failed to deactivate account'),
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
            const Text(
              'Deactivating your account is temporary. You can log back in any time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE54B5E)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Need a break? Deactivating your account will keep your profile hidden temporary. Logging back in will give you access to your account again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleDeactivate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE54B5E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('Deactivate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

