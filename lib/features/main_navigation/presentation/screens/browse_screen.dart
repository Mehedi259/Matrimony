import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/match_card.dart';
import '../../../../core/utils/snackbar_helper.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'A Muslim Matchmaker',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by your preferences',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400], size: 22),
                suffixIcon: GestureDetector(
                  onTap: () {
                    SnackBarHelper.showInfo(context, 'Filter settings opened');
                  },
                  child: Icon(Icons.tune_rounded, color: Colors.grey[400], size: 20),
                ),
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
            const SizedBox(height: 16),

            // Chips
            Row(
              children: [
                _FilterChip(label: 'All', isSelected: true, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 12),
                const _FilterChip(label: 'Online', isSelected: false),
                const SizedBox(width: 12),
                const _FilterChip(label: 'New', isSelected: false),
              ],
            ).animate()
                .fadeIn(duration: 600.ms, delay: 300.ms)
                .slideX(begin: -0.2, end: 0),
            const SizedBox(height: 24),

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
                SnackBarHelper.showSuccess(context, 'Interest Sent!');
              },
            ).animate()
                .fadeIn(duration: 700.ms, delay: 500.ms)
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
                SnackBarHelper.showSuccess(context, 'Interest Sent!');
              },
            ).animate()
                .fadeIn(duration: 700.ms, delay: 700.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;

  const _FilterChip({required this.label, required this.isSelected, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        SnackBarHelper.showInfo(context, 'Filtered by $label');
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
