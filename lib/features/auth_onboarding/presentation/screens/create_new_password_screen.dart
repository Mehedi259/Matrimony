import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/auth_provider.dart';
import '../widgets/common/custom_text_field.dart';
import 'dart:async';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _otpVerified = false;
  int _resendTimer = 600; // 10 minutes for password reset
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 600;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String get _timerText {
    final minutes = _resendTimer ~/ 60;
    final seconds = _resendTimer % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _handleVerifyOTP() async {
    final otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final email = authProvider.resetEmail;

    if (email == null) {
      _showError('Session expired. Please try again.');
      context.go('/forgot-password');
      return;
    }

    final success = await authProvider.passwordResetVerify(
      email: email,
      otp: otp,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _otpVerified = true;
      });
      _showSuccess('Code verified! Now set your new password.');
    } else {
      _showError(authProvider.errorMessage ?? 'Verification failed');
    }
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final resetToken = authProvider.resetToken;

    if (resetToken == null) {
      _showError('Please verify OTP first');
      return;
    }

    final success = await authProvider.passwordResetConfirm(
      resetToken: resetToken,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (success) {
      _showSuccess('Password reset successful!');
      // Navigate to login
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) context.go('/login');
      });
    } else {
      _showError(authProvider.errorMessage ?? 'Failed to reset password');
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    final authProvider = context.read<AuthProvider>();
    final email = authProvider.resetEmail;

    if (email == null) {
      _showError('Session expired. Please try again.');
      context.go('/forgot-password');
      return;
    }

    final success = await authProvider.passwordResetInitiate(email: email);

    if (!mounted) return;

    if (success) {
      _showSuccess('Reset code resent successfully');
      _startTimer();
      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    } else {
      _showError(authProvider.errorMessage ?? 'Failed to resend code');
    }
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final email = authProvider.resetEmail ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/mainlogo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 32),

                // Title
                Text(
                  _otpVerified ? 'Set new password' : 'Enter verification code',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2D292E),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),

                if (!_otpVerified) ...[
                  // Description
                  Text(
                    'We sent a verification code to\n$email',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms),
                  const SizedBox(height: 32),

                  // OTP Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        height: 50,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          enabled: !isLoading,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1D5DB),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    })
                        .animate(interval: 50.ms)
                        .fadeIn(duration: 400.ms, delay: 400.ms)
                        .slideY(begin: 0.3, end: 0),
                  ),
                  const SizedBox(height: 24),

                  // Timer and Resend
                  Text(
                    _canResend ? '' : 'Resend code in $_timerText',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: _canResend && !isLoading ? _handleResend : null,
                    child: Text(
                      'Resend code',
                      style: TextStyle(
                        color: _canResend
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 550.ms),
                  const SizedBox(height: 32),

                  // Verify OTP Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF7685C2), Color(0xFFD48B91)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : _handleVerifyOTP,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Verify Code',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                ] else ...[
                  // Password fields after OTP verification
                  const Text(
                    'Your new password must be different from previously used passwords.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'New Password',
                    hint: '••••••••••',
                    isPassword: true,
                    controller: _newPasswordController,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
                  const SizedBox(height: 20),

                  CustomTextField(
                    label: 'Confirm Password',
                    hint: '••••••••••',
                    isPassword: true,
                    controller: _confirmPasswordController,
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ).animate().fadeIn(duration: 600.ms, delay: 450.ms),
                  const SizedBox(height: 32),

                  // Reset Password Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF7685C2), Color(0xFFD48B91)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading ? null : _handleResetPassword,
                        borderRadius: BorderRadius.circular(8),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Reset Password',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .slideY(begin: 0.2, end: 0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
