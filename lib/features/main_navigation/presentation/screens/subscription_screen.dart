import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Subscription Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 24),
            
            // Pay as you go
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Icon(Icons.receipt_long_outlined, size: 20, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pay as you go', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        const Text('3 extra connections for £5 to\ntop up any time on monthly', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text('+ £5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Free Plan
            _buildPlanCard(
              context: context,
              title: 'Free',
              price: '£0',
              subtitle: 'Always free',
              borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
              buttonLabel: 'Free',
              isButtonGradient: false,
              features: [
                _buildFeatureItem('Receive connection requests', true, Theme.of(context).primaryColor),
                _buildFeatureItem('Accept or decline requests', true, Theme.of(context).primaryColor),
                _buildFeatureItem('View profiles in full', true, Theme.of(context).primaryColor),
                _buildFeatureItem('In- app support', true, Theme.of(context).primaryColor),
                _buildFeatureItem('Send connection requests', false, Theme.of(context).primaryColor.withOpacity(0.5)),
                _buildFeatureItem('See suggested matches', false, Theme.of(context).primaryColor.withOpacity(0.5)),
                _buildFeatureItem('See who viewed yor profile', false, Theme.of(context).primaryColor.withOpacity(0.5)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Monthly Plan
            _buildPlanCard(
              context: context,
              title: 'Monthly',
              price: '£15',
              subtitle: 'per month',
              borderColor: const Color(0xFFCD868A), // Light red/pink border
              buttonLabel: 'Upgrade now',
              isButtonGradient: true,
              features: [
                _buildFeatureItem('Send 10 requests per month', true, const Color(0xFFCD868A)),
                _buildFeatureItem('See suggested matches', true, const Color(0xFFCD868A)),
                _buildFeatureItem('See who viewed your profile', true, const Color(0xFFCD868A)),
                _buildFeatureItem('Pay as you go top ups available', true, const Color(0xFFCD868A)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Annual Plan
            _buildPlanCard(
              context: context,
              title: 'Annual',
              price: '£125',
              priceSuffix: ' (30% off)',
              priceSuffixColor: const Color(0xFFF7D154),
              subtitle: 'per year',
              borderColor: const Color(0xFFF7D154), // Yellow border
              buttonLabel: 'Upgrade now',
              isButtonGradient: true,
              features: [
                _buildFeatureItem('Unlimited connection requests', true, const Color(0xFFF7D154)),
                _buildFeatureItem('Profile listed at top of directory', true, const Color(0xFFF7D154)),
                _buildFeatureItem('Send connection requests', true, const Color(0xFFF7D154)),
                _buildFeatureItem('See Suggested matches', true, const Color(0xFFF7D154)),
                _buildFeatureItem('Priority support', true, const Color(0xFFF7D154)),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    String? priceSuffix,
    Color? priceSuffixColor,
    required String subtitle,
    required Color borderColor,
    required String buttonLabel,
    required bool isButtonGradient,
    required List<Widget> features,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.black87, height: 1.0)),
              if (priceSuffix != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(priceSuffix, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: priceSuffixColor)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 24),
          ...features,
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isButtonGradient ? null : const Color(0xFF9C91B8),
              gradient: isButtonGradient
                  ? const LinearGradient(
                      colors: [Color(0xFF8C9EFF), Color(0xFFE5A8B6)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(buttonLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isSolid, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle, size: 14, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isSolid ? Colors.black87 : Colors.black45,
                fontSize: 13,
                decoration: isSolid ? TextDecoration.none : TextDecoration.lineThrough,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
