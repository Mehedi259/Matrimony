import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/gradient_button.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

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
                    Image.asset('assets/mainlogo.png', height: 48, width: 48),
                    const Text('A MUSLIM MATCHMAKER', style: TextStyle(fontSize: 10, letterSpacing: 1.5)),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              const Text(
                'Verify your email address',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  children: [
                    TextSpan(text: 'We emailed you a six-digit code to\n'),
                    TextSpan(text: 'name@company.com', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    TextSpan(text: '. Enter the code below to\nconfirm your email address.'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return Container(
                    width: 50,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        ['3', '5', '7', '3', '2', '9'][index], // Placeholder text based on design
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'Please keep this window open while you check\nyour inbox.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 32),
              
              GradientButton(
                text: 'Verify',
                onPressed: () => context.push('/verified-success'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
