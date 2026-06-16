import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/common/gradient_button.dart';
import '../../../../core/theme/app_colors.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Subscription Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pay as you go
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                      child: const Icon(Icons.wallet, color: Colors.black54),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Pay as you go', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('3 extra connections for £5 to top up any time on monthly', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('+ £5', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Free Plan
              _PlanCard(
                title: 'Free',
                price: '£0',
                subtitle: 'Always free',
                features: [
                  'Receive connection requests',
                  'Accept or decline requests',
                  'View profiles in full',
                  'In-app support',
                  'Send connection requests',
                  'See suggested matches',
                  'See who viewed your profile',
                ],
                disabledFeatures: [4, 5, 6], // indices of disabled features
                buttonText: 'Free',
                borderColor: Theme.of(context).colorScheme.secondary,
                onTap: () => context.push('/home'),
              ),
              const SizedBox(height: 24),
              
              // Monthly Plan
              _PlanCard(
                title: 'Monthly',
                price: '£15',
                subtitle: 'per month',
                features: [
                  'Send 10 requests per month',
                  'See suggested matches',
                  'See who viewed your profile',
                  'Pay as you go top ups available',
                ],
                buttonText: 'Upgrade now',
                borderColor: Theme.of(context).primaryColor,
                iconColor: Theme.of(context).primaryColor,
                onTap: () => context.push('/home'),
              ),
              const SizedBox(height: 24),
              
              // Annual Plan
              _PlanCard(
                title: 'Annual',
                price: '£125',
                subtitle: 'per year',
                discountBadge: '(30% off)',
                features: [
                  'Unlimited connection requests',
                  'Profile listed at the top of suggested matches',
                  'Send connection requests',
                  'See Suggested matches',
                  'Priority support',
                ],
                buttonText: 'Upgrade now',
                borderColor: Colors.amber,
                iconColor: Colors.amber,
                onTap: () => context.push('/home'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final String? discountBadge;
  final List<String> features;
  final List<int> disabledFeatures;
  final String buttonText;
  final Color borderColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    this.discountBadge,
    required this.features,
    this.disabledFeatures = const [],
    required this.buttonText,
    required this.borderColor,
    this.iconColor = const Color(0xFF7685C2), // secondary
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              if (discountBadge != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(discountBadge!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: borderColor)),
                ),
              ],
            ],
          ),
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 24),
          
          ...features.asMap().entries.map((entry) {
            int idx = entry.key;
            String text = entry.value;
            bool isDisabled = disabledFeatures.contains(idx);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: isDisabled ? Colors.grey[300] : iconColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isDisabled ? Colors.grey : Colors.black87,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          GradientButton(
            text: buttonText,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
