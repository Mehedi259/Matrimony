import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/match_card.dart';

class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('A Muslim Matchmaker', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.tune, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter settings opened')));
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
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
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filtered by $label')));
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
