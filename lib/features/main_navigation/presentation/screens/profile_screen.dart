import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: CustomScrollView(
        slivers: [
          // ── Premium SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              background: _ProfileHeader(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/my-profile-view'),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 15, color: Colors.white),
                  label: const Text(
                    'View As',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
            ],
          ),

          // ── Stats Row ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  _StatPill(icon: Icons.visibility_outlined, label: 'Profile Views', value: '24', color: Colors.blue),
                  const SizedBox(width: 10),
                  _StatPill(icon: Icons.favorite_border, label: 'Saved', value: '03', color: Colors.pink),
                  const SizedBox(width: 10),
                  _StatPill(icon: Icons.mail_outline, label: 'Pending', value: '01', color: Colors.amber),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.3, end: 0),
            ),
          ),

          // ── Section Title ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                children: [
                  Container(width: 4, height: 18, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 8),
                  const Text('Profile Completion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms),
            ),
          ),

          // ── Profile List ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildProfileCard(context, primaryColor, secondaryColor),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Color primaryColor, Color secondaryColor) {
    final items = [
      _ItemData(
        icon: Icons.verified_outlined, 
        iconColor: Colors.green, 
        title: 'Verify Profile', 
        subtitle: 'Identity verified', 
        isCompleted: false, // Set to false if not verified
        onTap: () => context.push('/chat-with-admin'),
      ),
      _ItemData(icon: Icons.person_outline, iconColor: Colors.blue, title: 'Basic Information', subtitle: 'Name, age, height, location, education', isCompleted: true, onTap: () => context.push('/basic-information-form')),
      _ItemData(icon: Icons.location_on_outlined, iconColor: Colors.orange, title: 'Personal Information', subtitle: 'Lifestyle, values, hobbies, about you', isCompleted: true, onTap: () => context.push('/personal-details-form')),
      _ItemData(icon: Icons.favorite_border, iconColor: Colors.pink, title: 'Preferences', subtitle: 'Partner preferences and expectations', isCompleted: true, onTap: () => context.push('/preferences-form')),
      _ItemData(icon: Icons.camera_alt_outlined, iconColor: primaryColor, title: 'Photos', subtitle: '3 of 6 photos added', isCompleted: false, statusText: '3/6', onTap: () => context.push('/upload-photo-form')),
      _ItemData(icon: Icons.people_outline, iconColor: Colors.purple, title: 'About You & Expectations', subtitle: 'What you are looking for', isCompleted: true, onTap: () => context.push('/about-expectations-form')),
      _ItemData(icon: Icons.settings_outlined, iconColor: Colors.grey, title: 'Settings', subtitle: 'Privacy, notifications, security', isCompleted: null, onTap: () => context.push('/settings')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              _ProfileListTile(data: item, primaryColor: primaryColor, secondaryColor: secondaryColor)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: Duration(milliseconds: 500 + i * 80))
                  .slideX(begin: 0.1, end: 0),
              if (i < items.length - 1)
                Divider(height: 1, thickness: 1, color: Colors.grey[100], indent: 20, endIndent: 20),
            ],
          );
        }),
      ),
    );
  }
}

// ── Premium Header ─────────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final Color primaryColor;
  final Color secondaryColor;

  const _ProfileHeader({required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withValues(alpha: 0.08), secondaryColor.withValues(alpha: 0.05), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Avatar with circular progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 108,
                  height: 108,
                  child: CustomPaint(painter: _CircleProgressPainter(progress: 0.85, color: primaryColor)),
                ),
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: const DecorationImage(
                      image: AssetImage('assets/profileImage.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.4), blurRadius: 8)],
                    ),
                    child: const Text('85%', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 700.ms).scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),

            const SizedBox(height: 14),

            const Text(
              'Kader Molla',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

            const SizedBox(height: 4),

            Text(
              'kader@gmail.com',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

            const SizedBox(height: 12),

            // Tags
            Wrap(
              spacing: 8,
              children: [
                _TagChip(label: '28 Years', icon: Icons.cake_outlined),
                _TagChip(label: 'Dhaka, BD', icon: Icons.location_on_outlined),
                _TagChip(label: 'Engineer', icon: Icons.work_outline),
              ],
            ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 8),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.85,
                      minHeight: 6,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Profile 85% complete', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 500.ms),
          ],
        ),
      ),
    );
  }
}

// ── Circular Progress Painter ──────────────────────────────────────────────────
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;

    final bgPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── Stat Pill ─────────────────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatPill({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ── Tag Chip ──────────────────────────────────────────────────────────────────
class _TagChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TagChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}

// ── Item Data Model ───────────────────────────────────────────────────────────
class _ItemData {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool? isCompleted; // null = arrow only
  final String? statusText;
  final VoidCallback? onTap;

  _ItemData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.statusText,
    this.onTap,
  });
}

// ── Profile List Tile ─────────────────────────────────────────────────────────
class _ProfileListTile extends StatelessWidget {
  final _ItemData data;
  final Color primaryColor;
  final Color secondaryColor;

  const _ProfileListTile({required this.data, required this.primaryColor, required this.secondaryColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onTap,
      borderRadius: BorderRadius.circular(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: data.iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: data.iconColor, size: 20),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B))),
                  const SizedBox(height: 2),
                  Text(data.subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),

            // Trailing
            if (data.isCompleted == null)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
            else if (data.isCompleted == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 12),
                    const SizedBox(width: 4),
                    Text('Done', style: TextStyle(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.w600)),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.statusText ?? '',
                  style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
