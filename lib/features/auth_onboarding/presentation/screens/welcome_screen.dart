import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              // Logo placeholder
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/mainlogo.png', height: 48, width: 48),
                    const Text('A MUSLIM MATCHMAKER', style: TextStyle(fontSize: 10, letterSpacing: 1.5)),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  // Illustration placeholder (Couple)
                  child: Image.asset('assets/cupleIllustration.png', height: 250, fit: BoxFit.contain),
                ),
              ),
              Column(
                children: [
                  SocialAuthButton(
                    text: 'Sign up with Email',
                    icon: const Icon(Icons.email_outlined, color: Colors.red),
                    onPressed: () {
                      context.push('/signup');
                    },
                  ),
                  const SizedBox(height: 16),
                  SocialAuthButton(
                    text: 'Sign up with Google',
                    icon: Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/240px-Google_%22G%22_logo.svg.png', height: 24, width: 24, errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.blue, size: 24)),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 16),
                  SocialAuthButton(
                    text: 'Sign up with Apple',
                    icon: const Icon(Icons.apple, color: Colors.black),
                    onPressed: () {},
                  ),
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
                  ),
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
