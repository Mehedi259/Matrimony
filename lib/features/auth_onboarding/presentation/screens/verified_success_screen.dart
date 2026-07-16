import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/common/gradient_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/storage_service.dart';

class VerifiedSuccessScreen extends StatelessWidget {
  const VerifiedSuccessScreen({super.key});

  void _navigateToProfile(BuildContext context) {
    final storageService = context.read<StorageService>();
    final role = storageService.getUserRole();
    
    // Navigate to basic information screen based on role
    String gender;
    String profileType;
    
    switch (role?.toLowerCase()) {
      case 'male':
        gender = 'Male';
        profileType = 'brother';
        break;
      case 'female':
        gender = 'Female';
        profileType = 'sister';
        break;
      case 'wali':
        gender = 'Female';
        profileType = 'wali';
        break;
      default:
        // If role not found, go to welcome screen
        context.go('/welcome');
        return;
    }
    
    context.go('/onboarding/basic-info?gender=$gender&profileType=$profileType');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/mainlogo.png', height: 100, width: 100),
              const SizedBox(height: 64),
              
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.check, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Verified!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              const Text(
                'You have successfully verified your account.\nLet\'s complete your profile!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 48),
              
              GradientButton(
                text: 'Complete Profile',
                onPressed: () => _navigateToProfile(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
