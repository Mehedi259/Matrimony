import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/auth_provider.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  String? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show role selection dialog if not selected
    if (_selectedRole == null) {
      final role = await _showRoleSelectionDialog();
      if (role == null) return;
      _selectedRole = role;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole!,
    );

    if (!mounted) return;

    if (success) {
      // Navigate to home screen
      context.go('/home');
    } else {
      _showError(authProvider.errorMessage ?? 'Login failed');
    }
  }

  Future<String?> _showRoleSelectionDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Select Your Profile Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Male'),
              leading: const Icon(Icons.person, color: Color(0xFF7685C2)),
              onTap: () => Navigator.pop(context, 'male'),
            ),
            ListTile(
              title: const Text('Female'),
              leading: const Icon(Icons.person_outline, color: Color(0xFFD48B91)),
              onTap: () => Navigator.pop(context, 'female'),
            ),
            ListTile(
              title: const Text('Wali (Guardian)'),
              leading: const Icon(Icons.people_outline, color: Color(0xFFF2D76E)),
              onTap: () => Navigator.pop(context, 'wali'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Logo with animation
                Image.asset('assets/mainlogo.png', height: 100, width: 100)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 48),

                Text('Log in', style: Theme.of(context).textTheme.displaySmall)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),

                CustomTextField(
                  label: 'Email',
                  hint: 'name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Password',
                  hint: '•••••••••',
                  isPassword: true,
                  controller: _passwordController,
                  enabled: !isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Remember me',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TextButton(
                      onPressed:
                          isLoading ? null : () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 500.ms),
                const SizedBox(height: 32),

                GradientButton(
                  text: isLoading ? 'Logging in...' : 'Continue',
                  onPressed: isLoading ? null : _handleLogin,
                  isLoading: isLoading,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account yet? ',
                        style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () => context.push('/onboarding/profile-type'),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
