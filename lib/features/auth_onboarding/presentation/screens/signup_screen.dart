import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              // Logo
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/mainlogo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8)),
              const SizedBox(height: 16),
              
              // Title
              const Text(
                'Create your free account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF2D292E),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              
              // Email Field
              const CustomTextField(
                label: 'Email',
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 300.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              
              // Full Name Field
              const CustomTextField(
                label: 'Full Name',
                hint: 'Bonnie Green',
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 350.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              
              // Password Field
              const CustomTextField(
                label: 'Password',
                hint: '••••••••••',
                isPassword: true,
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              
              // Confirm Password Field
              const CustomTextField(
                label: 'Confirm Password',
                hint: '••••••••••',
                isPassword: true,
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 450.ms)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 12),
              
              // Terms and Conditions Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 2),
                    child: Checkbox(
                      value: _acceptTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(
                        width: 0.5,
                        color: Color(0xFFD1D5DB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'I accept the ',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 500.ms),
              const SizedBox(height: 16),
              
              // Create Account Button
              Container(
                width: double.infinity,
                height: 41,
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
                    onTap: () => context.push('/verify-email'),
                    borderRadius: BorderRadius.circular(8),
                    child: const Center(
                      child: Text(
                        'Create account',
                        textAlign: TextAlign.center,
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
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              
              // Already have account
              GestureDetector(
                onTap: () => context.push('/login'),
                child: Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 700.ms),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
