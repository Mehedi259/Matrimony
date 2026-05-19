import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/match_card.dart';
import '../widgets/privacy_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profileImage.png'), // Profile avatar
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text('Welcome Back', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ).animate()
            .fadeIn(duration: 600.ms)
            .slideX(begin: -0.2, end: 0),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () => context.push('/settings'),
          ).animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .scale(begin: const Offset(0.8, 0.8)),
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
            onPressed: () => context.push('/notifications'),
          ).animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120), // Padding bottom for nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by your preferences',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400], size: 22),
                suffixIcon: Icon(Icons.tune_rounded, color: Colors.grey[400], size: 20),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.4), width: 1.5),
                ),
              ),
            ).animate()
                .fadeIn(duration: 600.ms, delay: 100.ms)
                .slideY(begin: -0.2, end: 0),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: const _StatCard(
                    icon: Icons.visibility_outlined, 
                    iconColor: Colors.blue, 
                    count: '12', 
                    label: 'Profile View'
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: const _StatCard(
                    icon: Icons.favorite_border, 
                    iconColor: Colors.red, 
                    count: '03', 
                    label: 'Saved'
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 300.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: const _StatCard(
                    icon: Icons.mail_outline, 
                    iconColor: Colors.amber, 
                    count: '01', 
                    label: 'Pending'
                  ).animate()
                      .fadeIn(duration: 600.ms, delay: 400.ms)
                      .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Private MatchMaking Button
            GestureDetector(
              onTap: () => context.push('/private-matchmaking'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF6E3), // Light yellow
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: const Center(
                  child: Text('Private MatchMaking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ).animate()
                .fadeIn(duration: 600.ms, delay: 500.ms)
                .shimmer(duration: 2000.ms, delay: 1000.ms, color: Colors.amber[100]),
            const SizedBox(height: 24),
            
            const Text('Suggested for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                .animate()
                .fadeIn(duration: 600.ms, delay: 600.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 16),
            
            // Cards
            MatchCard(
              username: 'mm0058',
              age: '28 Years old',
              height: '5\'6"',
              profession: 'Software Engineer',
              photoCount: 5,
              lockMessage: 'Photos will be revealed after mutual interest',
              onViewProfile: () => context.push('/profile-view-details'),
              onSendInterest: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Interest Sent!')));
              },
            ).animate()
                .fadeIn(duration: 700.ms, delay: 700.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 16),
            MatchCard(
              username: 'jm0052',
              age: '22 Years old',
              height: '5\'4"',
              profession: 'Student',
              photoCount: 4,
              lockMessage: 'Photos will be revealed after mutual interest',
              onViewProfile: () => context.push('/profile-view-details'),
              onSendInterest: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Interest Sent!')));
              },
            ).animate()
                .fadeIn(duration: 700.ms, delay: 900.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 24),
            
            const PrivacyBanner()
                .animate()
                .fadeIn(duration: 600.ms, delay: 1100.ms),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String count;
  final String label;

  const _StatCard({required this.icon, required this.iconColor, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
