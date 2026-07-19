import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/matches_provider.dart';

class PrivateMatchmakingScreen extends StatefulWidget {
  const PrivateMatchmakingScreen({super.key});

  @override
  State<PrivateMatchmakingScreen> createState() => _PrivateMatchmakingScreenState();
}

class _PrivateMatchmakingScreenState extends State<PrivateMatchmakingScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _matchmakingRequest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRequestStatus();
    });
  }

  Future<void> _loadRequestStatus() async {
    final provider = context.read<MatchesProvider>();
    final request = await provider.getMyMatchmakingRequest();
    if (mounted) {
      setState(() {
        _matchmakingRequest = request;
        _isLoading = false;
      });
    }
  }

  Future<void> _bookConsultation() async {
    final provider = context.read<MatchesProvider>();
    setState(() => _isLoading = true);
    
    final success = await provider.createMatchmakingRequest();
    
    if (!mounted) return;
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consultation request sent successfully!'), backgroundColor: Colors.green),
      );
      await _loadRequestStatus();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Failed to send request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildActionButton() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_matchmakingRequest != null) {
      final status = _matchmakingRequest!['status'] as String? ?? 'pending';
      Color statusColor;
      IconData statusIcon;
      String statusText;

      switch (status.toLowerCase()) {
        case 'approved':
          statusColor = Colors.green;
          statusIcon = Icons.check_circle_outline;
          statusText = 'Request Approved';
          break;
        case 'completed':
          statusColor = Colors.blue;
          statusIcon = Icons.done_all;
          statusText = 'Service Completed';
          break;
        case 'rejected':
          statusColor = Colors.red;
          statusIcon = Icons.cancel_outlined;
          statusText = 'Request Rejected';
          break;
        case 'pending':
        default:
          statusColor = Colors.orange;
          statusIcon = Icons.hourglass_bottom;
          statusText = 'Request Pending Review';
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(statusIcon, color: statusColor, size: 24),
            const SizedBox(width: 12),
            Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E3),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: TextButton.icon(
        onPressed: _bookConsultation,
        icon: Icon(Icons.calendar_month, color: Colors.amber[700]),
        label: Text(
          'Book Consultation',
          style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7FA),
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Private Matchmaking',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.2, end: 0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Headline ────────────────────────────────────────────────
            const Text(
              'Tired of\nEndless\nSearching?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
            ).animate()
                .fadeIn(duration: 700.ms, delay: 100.ms)
                .slideY(begin: -0.3, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 16),

            // ── Sub-headline ─────────────────────────────────────────────
            const Text(
              'Our private matchmaking service helps you find meaningful connections without endless searching.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ).animate()
                .fadeIn(duration: 600.ms, delay: 250.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 32),

            // ── Illustration ─────────────────────────────────────────────
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
            ).animate()
                .fadeIn(duration: 700.ms, delay: 400.ms)
                .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack),
            const SizedBox(height: 24),

            // ── Dynamic Action Button ─────────────────────────────────────
            _buildActionButton().animate()
                .fadeIn(duration: 600.ms, delay: 550.ms)
                .shimmer(duration: 1800.ms, delay: 1200.ms, color: Colors.amber[100]),
            const SizedBox(height: 24),

            // ── Privacy Banner ────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
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
                      const Text(
                        'Your Privacy Comes First',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'We understand the importance of discretion and privacy in your search for love.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
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
            ).animate()
                .fadeIn(duration: 600.ms, delay: 700.ms)
                .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 40),

            // ── How it Works Title ────────────────────────────────────────
            const Text(
              'How Private Matchmaking Works',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ).animate()
                .fadeIn(duration: 600.ms, delay: 800.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // ── How it Works Grid ─────────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _FeatureItem(
                  icon: Icons.person_outline,
                  iconBgColor: Color(0xFFFDE8E9),
                  iconColor: Colors.redAccent,
                  title: 'Book Consultation',
                  subtitle: 'Explain what you\'re looking for in detail',
                  delay: 900,
                ),
                _FeatureItem(
                  icon: Icons.people_outline,
                  iconBgColor: Color(0xFFE8EAF6),
                  iconColor: Colors.blueAccent,
                  title: 'Personal Matchmaker',
                  subtitle: 'Expert finds your matches',
                  delay: 1000,
                ),
                _FeatureItem(
                  icon: Icons.check_circle_outline,
                  iconBgColor: Color(0xFFFDE8E9),
                  iconColor: Colors.redAccent,
                  title: 'Mutual Approval',
                  subtitle: 'Both parties agree first',
                  delay: 1100,
                ),
                _FeatureItem(
                  icon: Icons.chat_bubble_outline,
                  iconBgColor: Color(0xFFE8EAF6),
                  iconColor: Colors.blueAccent,
                  title: 'Virtual Introduction',
                  subtitle: 'Have a chance to speak in a halal environment',
                  delay: 1200,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // ── Why Choose Title ──────────────────────────────────────────
            const Text(
              'Why Choose Private\nMatchmaking?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ).animate()
                .fadeIn(duration: 600.ms, delay: 1300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

            // ── Why Choose Grid ───────────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                _FeatureItem(
                  icon: Icons.access_time,
                  iconBgColor: Color(0xFFFDE8E9),
                  iconColor: Colors.redAccent,
                  title: 'Save Time',
                  subtitle: 'No endless searching required',
                  delay: 1400,
                ),
                _FeatureItem(
                  icon: Icons.favorite_border,
                  iconBgColor: Color(0xFFE8EAF6),
                  iconColor: Colors.blueAccent,
                  title: 'Better Matches',
                  subtitle: 'Curated just for you',
                  delay: 1500,
                ),
                _FeatureItem(
                  icon: Icons.lock_outline,
                  iconBgColor: Color(0xFFFDE8E9),
                  iconColor: Colors.redAccent,
                  title: 'Safe & Private',
                  subtitle: 'Your data is protected',
                  delay: 1600,
                ),
                _FeatureItem(
                  icon: Icons.support_agent,
                  iconBgColor: Color(0xFFF3E5F5),
                  iconColor: Colors.purpleAccent,
                  title: 'Trusted Support',
                  subtitle: 'Expert guidance always',
                  delay: 1700,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // ── Matchmaker Card ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/profileImage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal\nMatchmaker Support',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Work one-on-one with a dedicated matchmaker who understands your unique needs and personally finds compatible matches for you.',
                          style: TextStyle(fontSize: 10, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate()
                .fadeIn(duration: 700.ms, delay: 1800.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            const SizedBox(height: 40),

            // ── Bottom CTA (Hide if request exists) ───────────────────────
            if (_matchmakingRequest == null && !_isLoading)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF6E3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Ready to Start Your Journey?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Book a free consultation today',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
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
                        onPressed: _bookConsultation,
                        icon: Icon(Icons.calendar_month, color: Colors.amber[700], size: 20),
                        label: Text(
                          'Book Consultation',
                          style: TextStyle(color: Colors.amber[800], fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate()
                  .fadeIn(duration: 700.ms, delay: 1900.ms)
                  .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Feature Item ──────────────────────────────────────────────────────────────
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int delay;

  const _FeatureItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.delay,
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
    ).animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay))
        .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
  }
}

