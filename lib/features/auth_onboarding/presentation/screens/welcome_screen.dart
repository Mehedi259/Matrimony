import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/social_auth_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo with fade and scale animation
              Center(
                child: Image.asset('assets/mainlogo.png', height: 100, width: 100)
                    .animate()
                    .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                    .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0)),
              ),
              Expanded(
                child: Center(
                  // Illustration with slide and fade animation
                  child: Image.asset('assets/cupleIllustration.png', height: 250, fit: BoxFit.contain)
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 200.ms)
                      .slideY(begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutCubic),
                ),
              ),
              Column(
                children: [
                  SocialAuthButton(
                    text: 'Sign up with Email',
                    icon: const Icon(Icons.email_outlined, color: Colors.red),
                    onPressed: () {
                      context.push('/onboarding/profile-type');
                    },
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 16),
                  SocialAuthButton(
                    text: 'Sign up with Google',
                    icon: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/240px-Google_%22G%22_logo.svg.png', height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 24)),
                    onPressed: () {},
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 500.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 16),
                  SocialAuthButton(
                    text: 'Sign up with Apple',
                    icon: const Icon(Icons.apple, color: Colors.black),
                    onPressed: () {},
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 600.ms)
                      .slideX(begin: -0.2, end: 0, curve: Curves.easeOut),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have account? ', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => context.push('/login'),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 700.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
