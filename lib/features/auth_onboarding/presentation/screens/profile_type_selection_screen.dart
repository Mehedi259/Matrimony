import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileTypeSelectionScreen extends StatelessWidget {
  const ProfileTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Logo
              Image.asset('assets/mainlogo.png', height: 100, width: 100),
              const SizedBox(height: 24),
              
              Text('Select Profile', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: _ProfileCard(
                      title: 'Male',
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () => context.push('/onboarding/basic-info'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ProfileCard(
                      title: 'Female',
                      color: Theme.of(context).colorScheme.primary,
                      onTap: () => context.push('/onboarding/basic-info'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ProfileCard(
                title: 'Wali Profile',
                color: const Color(0xFFF3C654), // Yellowish color from design
                isWide: true,
                onTap: () => context.push('/onboarding/wali-info'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final Color color;
  final bool isWide;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.title,
    required this.color,
    this.isWide = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D5CD), // Placeholder illustration background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: title == 'Male' 
                    ? Image.asset('assets/male.png', height: 100, width: 100, fit: BoxFit.contain)
                    : title == 'Female'
                      ? Image.asset('assets/female.png', height: 100, width: 100, fit: BoxFit.contain)
                      : Image.asset('assets/waliProfile.png', height: 100, width: 100, fit: BoxFit.contain),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
