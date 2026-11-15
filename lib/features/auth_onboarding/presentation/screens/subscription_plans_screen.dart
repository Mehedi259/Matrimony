import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../subscription/subscription_plans_view.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Subscription Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SubscriptionPlansView(
            onContinueFree: () => context.canPop() ? context.pop() : context.go('/home'),
            onSubscribed: () {
              if (context.mounted) context.canPop() ? context.pop() : context.go('/home');
            },
          ),
        ),
      ),
    );
  }
}
