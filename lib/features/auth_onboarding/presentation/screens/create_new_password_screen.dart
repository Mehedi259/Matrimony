import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Column(
                  children: [
                    Icon(Icons.favorite_border, size: 48, color: Theme.of(context).primaryColor),
                    const Text('A MUSLIM MATCHMAKER', style: TextStyle(fontSize: 10, letterSpacing: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              const Text(
                'Create new password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your new password must be different from\nprevious used passwords.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              
              const CustomTextField(
                label: 'New Password',
                hint: '••••••••••',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              
              const CustomTextField(
                label: 'Confirm Password',
                hint: '••••••••••',
                isPassword: true,
              ),
              const SizedBox(height: 24),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: false,
                      onChanged: (v) {},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
                        children: [
                          const TextSpan(text: 'I agree to A Muslim Matchmaker\'s '),
                          TextSpan(
                            text: 'Privacy\nPolicy',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              GradientButton(
                text: 'Forget Password', // Using literal text from image
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 24),
              
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                  children: [
                    const TextSpan(text: 'If you still need help, contact '),
                    TextSpan(
                      text: 'Support.',
                      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
