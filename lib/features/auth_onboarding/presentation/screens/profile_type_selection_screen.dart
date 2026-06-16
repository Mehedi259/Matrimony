import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileTypeSelectionScreen extends StatelessWidget {
  const ProfileTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final cardWidth = (screenWidth - (horizontalPadding * 2) - 16) / 2; // For two cards side by side
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                
                // Logo
                Image.asset(
                  'assets/mainlogo.png',
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
                
                const SizedBox(height: 16),
                
                // Title
                Text(
                  'Select Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 20),
                
                // Male and Female Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _ProfileCard(
                        title: 'Male',
                        subtitle: 'Looking for myself',
                        color: const Color(0xFF7685C2),
                        cardWidth: cardWidth,
                        onTap: () => context.push('/onboarding/basic-info?profileType=brother&gender=Male'),
                      ).animate()
                          .fadeIn(duration: 600.ms, delay: 300.ms)
                          .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ProfileCard(
                        title: 'Female',
                        subtitle: 'Looking for myself',
                        color: const Color(0xFFD48B91),
                        cardWidth: cardWidth,
                        onTap: () => context.push('/onboarding/basic-info?profileType=sister&gender=Female'),
                      ).animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Wali Profile Card (Centered)
                Center(
                  child: SizedBox(
                    width: cardWidth,
                    child: _ProfileCard(
                      title: 'Wali Profile',
                      subtitle: 'Guardian registering',
                      color: const Color(0xFFF2D76E),
                      cardWidth: cardWidth,
                      onTap: () => context.push('/onboarding/wali-info?profileType=wali&gender=Female'),
                    ).animate()
                        .fadeIn(duration: 600.ms, delay: 500.ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;
  final double cardWidth;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.title,
    this.subtitle,
    required this.color,
    required this.cardWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Square image + text height
    final imageSize = cardWidth - 20; // Subtract padding
    final totalHeight = imageSize + 60; // Image + text space (increased more)
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: totalHeight,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Square Image Container
            Flexible(
              child: Container(
                width: imageSize,
                height: imageSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _getProfileImage(title),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1.1,
              ),
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  height: 1.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getProfileImage(String title) {
    String assetPath;
    
    if (title == 'Male') {
      assetPath = 'assets/male.png';
    } else if (title == 'Female') {
      assetPath = 'assets/female.png';
    } else {
      assetPath = 'assets/waliProfile.png';
    }
    
    return Image.asset(
      assetPath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to placeholder if image not found
        return Container(
          color: Colors.white,
          child: Center(
            child: Icon(
              title == 'Male' 
                ? Icons.person 
                : title == 'Female' 
                  ? Icons.person_outline 
                  : Icons.people_outline,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
        );
      },
    );
  }
}
