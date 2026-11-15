import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/iap_products.dart';
import '../../providers/auth_provider.dart';
import '../../providers/matches_provider.dart';
import '../auth_onboarding/presentation/widgets/common/gradient_button.dart';
import 'purchase_provider.dart';

/// The plans list with working purchase buttons. Used by the onboarding
/// paywall (/subscription-plans) and Settings → Subscription.
class SubscriptionPlansView extends StatefulWidget {
  /// Tapped on the Free card. Null means the Free card shows no action.
  final VoidCallback? onContinueFree;

  /// Called after a subscription purchase is confirmed by the server.
  final VoidCallback? onSubscribed;

  const SubscriptionPlansView({super.key, this.onContinueFree, this.onSubscribed});

  @override
  State<SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<SubscriptionPlansView> {
  late final PurchaseProvider _purchases;
  String? _lastShownError;
  String? _lastShownSuccess;
  String _lastPlan = 'free';

  @override
  void initState() {
    super.initState();
    _purchases = context.read<PurchaseProvider>();
    _lastPlan = _purchases.currentPlan;
    _purchases.addListener(_onPurchaseChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _purchases.init());
  }

  @override
  void dispose() {
    _purchases.removeListener(_onPurchaseChange);
    super.dispose();
  }

  void _onPurchaseChange() {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final err = _purchases.errorMessage;
    final ok = _purchases.successMessage;
    if (err != null && err != _lastShownError) {
      _lastShownError = err;
      messenger.showSnackBar(SnackBar(content: Text(err), backgroundColor: Colors.red[700]));
    }
    if (ok != null && ok != _lastShownSuccess) {
      _lastShownSuccess = ok;
      messenger.showSnackBar(SnackBar(content: Text(ok), backgroundColor: Colors.green[700]));
    }
    final plan = _purchases.currentPlan;
    if (plan != _lastPlan) {
      final becamePaid = plan != 'free' && _lastPlan == 'free';
      _lastPlan = plan;
      context.read<AuthProvider>().refreshProfile();
      context.read<MatchesProvider>().fetchConnectionUsage();
      if (becamePaid) widget.onSubscribed?.call();
    }
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _manageSubscription(SubscriptionStatus? status) {
    final onApple = status?.storePlatform == 'apple' || (status?.storePlatform == null && Platform.isIOS);
    _open(onApple ? IapProducts.appleManageUrl : IapProducts.googleManageUrl(status?.productId));
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<PurchaseProvider>();
    final status = p.status;
    final plan = p.currentPlan;
    final primary = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (status != null && status.isPaid) _currentPlanBanner(status),
        _payAsYouGoCard(p, plan),
        const SizedBox(height: 16),
        _PlanCard(
          title: 'Free',
          price: '£0',
          subtitle: 'Always free',
          features: const [
            'Receive connection requests',
            'Accept or decline requests',
            'View profiles in full',
            'In-app support',
            'Send connection requests',
            'See suggested matches',
            'See who viewed your profile',
          ],
          disabledFeatures: const [4, 5, 6],
          borderColor: Theme.of(context).colorScheme.secondary,
          buttonText: plan == 'free'
              ? (widget.onContinueFree != null ? 'Continue with Free' : 'Current plan')
              : 'Included',
          onTap: plan == 'free' ? widget.onContinueFree : null,
        ),
        const SizedBox(height: 16),
        _PlanCard(
          title: 'Monthly',
          price: p.priceFor(IapProducts.monthly),
          subtitle: 'per month · auto-renews',
          features: const [
            'Send 10 requests per month',
            'See suggested matches',
            'See who viewed your profile',
            'Pay as you go top ups available',
          ],
          borderColor: primary,
          iconColor: primary,
          isCurrent: plan == 'monthly',
          buttonText: plan == 'monthly'
              ? 'Current plan'
              : plan == 'annual'
                  ? 'Switch to Monthly'
                  : 'Upgrade now',
          isLoading: p.busyProductId == IapProducts.monthly,
          onTap: plan == 'monthly' || p.isBusy ? null : () => p.buy(IapProducts.monthly),
        ),
        const SizedBox(height: 16),
        _PlanCard(
          title: 'Annual',
          price: p.priceFor(IapProducts.annual),
          subtitle: 'per year · auto-renews',
          discountBadge: '(30% off)',
          features: const [
            'Unlimited connection requests',
            'Profile listed at the top of suggested matches',
            'Send connection requests',
            'See Suggested matches',
            'Priority support',
          ],
          borderColor: Colors.amber,
          iconColor: Colors.amber,
          isCurrent: plan == 'annual',
          buttonText: plan == 'annual'
              ? 'Current plan'
              : plan == 'monthly'
                  ? 'Upgrade to Annual'
                  : 'Upgrade now',
          isLoading: p.busyProductId == IapProducts.annual,
          onTap: plan == 'annual' || p.isBusy ? null : () => p.buy(IapProducts.annual),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: p.isBusy ? null : p.restore,
              child: p.restoring
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Restore purchases'),
            ),
            if (status != null && status.isPaid) ...[
              const Text('·', style: TextStyle(color: Colors.black38)),
              TextButton(
                onPressed: () => _manageSubscription(status),
                child: const Text('Manage subscription'),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Payment is charged to your ${Platform.isIOS ? 'Apple ID' : 'Google Play'} account at '
          'confirmation of purchase. Subscriptions renew automatically unless cancelled at least '
          '24 hours before the end of the current period. Your account is charged for renewal '
          'within 24 hours before the end of the period. You can manage or cancel your '
          'subscription in your ${Platform.isIOS ? 'App Store account settings' : 'Google Play subscriptions'} '
          'after purchase.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, color: Colors.black45, height: 1.4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _open(IapProducts.termsOfUseUrl),
              child: const Text('Terms of Use', style: TextStyle(fontSize: 12)),
            ),
            const Text('·', style: TextStyle(color: Colors.black38)),
            TextButton(
              onPressed: () => _open(IapProducts.privacyPolicyUrl),
              child: const Text('Privacy Policy', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _currentPlanBanner(SubscriptionStatus s) {
    final date = s.end != null ? DateFormat('d MMM yyyy').format(s.end!.toLocal()) : null;
    final planName = s.plan == 'annual' ? 'Annual' : 'Monthly';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              date == null
                  ? 'You are on the $planName plan.'
                  : s.autoRenewing
                      ? 'You are on the $planName plan. Renews on $date.'
                      : 'You are on the $planName plan until $date (will not renew).',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _payAsYouGoCard(PurchaseProvider p, String plan) {
    final canBuy = plan == 'monthly';
    final busy = p.busyProductId == IapProducts.topUp;
    final bonus = p.status?.bonusRequests ?? 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: const Icon(Icons.wallet, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pay as you go', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(
                  canBuy
                      ? '3 extra connections for ${p.priceFor(IapProducts.topUp)}, top up any time'
                      : '3 extra connections for ${p.priceFor(IapProducts.topUp)} — available on the Monthly plan',
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                ),
                if (bonus > 0) ...[
                  const SizedBox(height: 4),
                  Text('$bonus extra request${bonus == 1 ? '' : 's'} left',
                      style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          OutlinedButton(
            onPressed: canBuy && !p.isBusy ? () => p.buy(IapProducts.topUp) : null,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: busy
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text('+ ${p.priceFor(IapProducts.topUp)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
        ],
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
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isCurrent;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.subtitle,
    this.discountBadge,
    required this.features,
    this.disabledFeatures = const [],
    required this.buttonText,
    required this.borderColor,
    this.iconColor = const Color(0xFF7685C2),
    this.onTap,
    this.isLoading = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isCurrent ? 3 : 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (isCurrent) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(10)),
                  child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              if (discountBadge != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(discountBadge!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: borderColor)),
                ),
              ],
            ],
          ),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          ...features.asMap().entries.map((entry) {
            final isDisabled = disabledFeatures.contains(entry.key);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 14, color: isDisabled ? Colors.grey[300] : iconColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDisabled ? Colors.grey : Colors.black87,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Opacity(
            opacity: onTap == null && !isLoading ? 0.55 : 1,
            child: GradientButton(text: buttonText, onPressed: onTap, isLoading: isLoading),
          ),
        ],
      ),
    );
  }
}
