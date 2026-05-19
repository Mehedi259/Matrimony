import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/gradient_button.dart';

class WaliProfileInfoScreen extends StatelessWidget {
  const WaliProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/mainlogo.png', height: 48, width: 48),
              const Text('A MUSLIM MATCHMAKER', style: TextStyle(fontSize: 10, letterSpacing: 1.5)),
              const SizedBox(height: 48),
              
              Text('Wali Profile', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),
              
              const Text(
                'Please fill out the following questions on\nbehalf of the person looking to get\nmarried.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              
              Expanded(
                child: Center(
                  // Illustration placeholder
                  child: Image.asset('assets/handswithPhone.png', height: 250, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 40),
              
              GradientButton(
                text: 'Continue & Provide Info',
                onPressed: () {
                  context.push('/onboarding/basic-info');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
