import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/gradient_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                // Logo with animation
                Image.asset('assets/mainlogo.png', height: 100, width: 100)
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 48),
                
                Text('Log in', style: Theme.of(context).textTheme.displaySmall)
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),
                
                CustomTextField(
                  label: 'Email',
                  hint: 'name@example.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ).animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 24),
                
                CustomTextField(
                  label: 'Password',
                  hint: '•••••••••',
                  isPassword: true,
                  controller: _passwordController,
                ).animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Remember me', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ).animate()
                    .fadeIn(duration: 600.ms, delay: 500.ms),
                const SizedBox(height: 32),
                
                GradientButton(
                  text: 'Continue',
                  onPressed: () {
                    // Temporary navigation for UI demonstration
                    context.push('/onboarding/profile-type');
                  },
                ).animate()
                    .fadeIn(duration: 600.ms, delay: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account yet? ', style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () => context.push('/welcome'),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ).animate()
                    .fadeIn(duration: 600.ms, delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
