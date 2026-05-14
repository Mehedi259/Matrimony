import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              backgroundImage: NetworkImage('https://placehold.co/150/png'), // Placeholder avatar
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text('Welcome Back', style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).primaryColor),
            onPressed: () => context.push('/settings'),
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
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120), // Padding bottom for nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by your preferences',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: const [
                Expanded(child: _StatCard(icon: Icons.visibility_outlined, iconColor: Colors.blue, count: '12', label: 'Profile View')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(icon: Icons.favorite_border, iconColor: Colors.red, count: '03', label: 'Saved')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(icon: Icons.mail_outline, iconColor: Colors.amber, count: '01', label: 'Pending')),
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
            ),
            const SizedBox(height: 24),
            
            const Text('Suggested for you', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            ),
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
            ),
            const SizedBox(height: 24),
            
            const PrivacyBanner(),
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
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
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
