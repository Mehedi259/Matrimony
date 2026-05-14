import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create account', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 32),
              const CustomTextField(label: 'Full Name', hint: 'John Doe'),
              const SizedBox(height: 16),
              const CustomTextField(label: 'Email', hint: 'name@example.com', keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const CustomTextField(label: 'Password', hint: '•••••••••', isPassword: true),
              const SizedBox(height: 8),
              // Password strength indicator placeholder
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const CustomTextField(label: 'Confirm Password', hint: '•••••••••', isPassword: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v) {}),
                  const Expanded(child: Text('I agree to the Terms & Conditions')),
                ],
              ),
              const SizedBox(height: 32),
              GradientButton(
                text: 'Sign up',
                onPressed: () => context.push('/verify-email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
