import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/match_card.dart';
import '../widgets/privacy_banner.dart';

class PrivateMatchesScreen extends StatelessWidget {
  const PrivateMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Private Matches', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.secondary, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Handpicked matches recommended by your matchmaker for you',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Tabs
            Row(
              children: [
                Expanded(child: _TabButton(label: 'Personalised Match', isSelected: true, color: const Color(0xFFF1DEB9))),
                Expanded(child: _TabButton(label: 'Approved', isSelected: false)),
                Expanded(child: _TabButton(label: 'Declined', isSelected: false)),
              ],
            ),
            const SizedBox(height: 24),
            
            const PrivacyBanner(
              subtitle: 'Photos are hidden and contact details are shared only after mutual approval',
            ),
            const SizedBox(height: 24),
            
            const Text('New Matches recommended for you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Cards
            MatchCard(
              username: 'mm0025',
              age: '28 Years',
              height: '5\'6"',
              profession: 'Software Engineer',
              lockMessage: 'Photos will be revealed after mutual interest',
              isExclusive: true,
              onDecline: () {},
              onAccept: () {},
            ),
            const SizedBox(height: 16),
            MatchCard(
              username: 'Mk0032',
              age: '22 Years',
              height: '5\'4"',
              profession: 'Student',
              lockMessage: 'Photos will be revealed after mutual interest',
              isExclusive: true,
              exclusiveOverlayText: 'This match was personally recommended by our matchmakers for a premium member. If you\'re interested, our team will reach out to arrange the next steps.',
              onDecline: () {},
              onAccept: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;

  const _TabButton({required this.label, required this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? color : Colors.white,
        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black87 : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
