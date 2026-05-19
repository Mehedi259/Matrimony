import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivateMatchmakingScreen extends StatelessWidget {
  const PrivateMatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FA), // Very light pink/white
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Private Matchmaking', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Tired of\nEndless\nSearching?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our private matchmaking service helps you find meaningful connections without endless searching.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            
            // Big Heart Icon
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[100]!, Colors.pink[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Image.asset('assets/cupleIllustration.png', height: 150, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 24),
            
            // Book Consultation Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF6E3),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.calendar_month, color: Colors.amber[700]),
                label: Text('Book Consultation', style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 24),
            
            // Privacy Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                        child: const Icon(Icons.security, color: Colors.redAccent, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Your Privacy Comes First', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('We understand the importance of discretion and privacy in your search for love.', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Icon(Icons.lock_outline, size: 14, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('100% secure & confidential', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // How it works
            const Text('How Private Matchmaking Works', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _FeatureItem(icon: Icons.person_outline, iconBgColor: Color(0xFFFDE8E9), iconColor: Colors.redAccent, title: 'Book Consultation', subtitle: 'Explain what you\'re looking for in detail'),
                _FeatureItem(icon: Icons.people_outline, iconBgColor: Color(0xFFE8EAF6), iconColor: Colors.blueAccent, title: 'Human Matcher', subtitle: 'Expert finds your matches'),
                _FeatureItem(icon: Icons.check_circle_outline, iconBgColor: Color(0xFFFDE8E9), iconColor: Colors.redAccent, title: 'Mutual Approval', subtitle: 'Both parties agree first'),
                _FeatureItem(icon: Icons.chat_bubble_outline, iconBgColor: Color(0xFFE8EAF6), iconColor: Colors.blueAccent, title: 'Virtual Introduction', subtitle: 'Have a chance to speak in a held environment'),
              ],
            ),
            const SizedBox(height: 40),
            
            // Why choose
            const Text('Why Choose Private\nMatchmaking?', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _FeatureItem(icon: Icons.access_time, iconBgColor: Color(0xFFFDE8E9), iconColor: Colors.redAccent, title: 'Save Time', subtitle: 'No endless searching required'),
                _FeatureItem(icon: Icons.favorite_border, iconBgColor: Color(0xFFE8EAF6), iconColor: Colors.blueAccent, title: 'Better Matches', subtitle: 'Curated just for you'),
                _FeatureItem(icon: Icons.lock_outline, iconBgColor: Color(0xFFFDE8E9), iconColor: Colors.redAccent, title: 'Safe & Private', subtitle: 'Your data is protected'),
                _FeatureItem(icon: Icons.support_agent, iconBgColor: Color(0xFFF3E5F5), iconColor: Colors.purpleAccent, title: 'Trusted Support', subtitle: 'Expert guidance always'),
              ],
            ),
            const SizedBox(height: 40),
            
            // Personal Matchmaker Support Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/profileImage.png'), // Matchmaker profile image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Personal\nMatchmaker Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Work one-on-one with a dedicated matchmaker who understands your unique needs and personally finds compatible matches for you.', style: TextStyle(fontSize: 10, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Bottom CTA
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF6E3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                children: [
                  const Text('Ready to Start Your Journey?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Book a free consultation today', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.amber[400]!),
                    ),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_month, color: Colors.amber[700], size: 20),
                      label: Text('Book Consultation', style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54)),
      ],
    );
  }
}
