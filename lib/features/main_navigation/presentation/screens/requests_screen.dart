import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/match_card.dart';
import '../widgets/privacy_banner.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Requests', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
              Text('Manage your requests here', style: TextStyle(color: Colors.black54, fontSize: 12)),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.6), // Adjust color to match screenshot (pinkish)
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black87,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: 'Received'),
                      Tab(text: 'Sent'),
                      Tab(text: 'Matches'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildReceivedTab(context),
            _buildSentTab(context),
            _buildMatchesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivedTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PrivacyBanner(subtitle: 'Photos are hidden and contact details are shared only after mutual approval'),
        const SizedBox(height: 24),
        MatchCard(
          username: 'MM005',
          age: '28 Years old',
          height: '5\'6"',
          profession: 'Software Engineer',
          photoCount: 5,
          lockMessage: 'Photos will be revealed after mutual interest',
          onDecline: () => _showDeclineDialog(context),
          onAccept: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match Accepted!')));
          },
        ),
        const SizedBox(height: 16),
        MatchCard(
          username: 'Mj003',
          age: '22 Years old',
          height: '5\'4"',
          profession: 'Student',
          photoCount: 4,
          lockMessage: 'Photos will be revealed after mutual interest',
          onDecline: () => _showDeclineDialog(context),
          onAccept: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match Accepted!')));
          },
        ),
      ],
    );
  }

  Widget _buildSentTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PrivacyBanner(subtitle: 'Photos are hidden and contact details are shared only after mutual approval'),
        const SizedBox(height: 24),
        MatchCard(
          username: 'Mm005',
          age: '28 Years old',
          height: '5\'6"',
          profession: 'Software Engineer',
          photoCount: 5,
          lockMessage: 'Photos will be revealed after mutual interest',
          onCancelRequest: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Cancelled!')));
          },
          onViewProfile: () => context.push('/profile-view-details'),
        ),
        const SizedBox(height: 16),
        MatchCard(
          username: 'Mj003',
          age: '22 Years old',
          height: '5\'4"',
          profession: 'Student',
          photoCount: 4,
          lockMessage: 'Photos will be revealed after mutual interest',
          onCancelRequest: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Cancelled!')));
          },
          onViewProfile: () => context.push('/profile-view-details'),
        ),
      ],
    );
  }

  Widget _buildMatchesTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        MatchCard(
          username: 'Marium Sultana',
          age: '28 Years old',
          height: '5\'6"',
          profession: 'Software Engineer',
          photoCount: 5,
          lockMessage: '',
          isLocked: false,
          isMatched: true,
          isBlurred: false,
          matchedButtonText: 'View all details',
          onMatchedButtonPressed: () => context.push('/matched-profile-view'),
        ),
        const SizedBox(height: 16),
        MatchCard(
          username: 'Shehnaz Khan',
          age: '22 Years old',
          height: '5\'4"',
          profession: 'Student',
          photoCount: 4,
          lockMessage: '',
          isLocked: false,
          isMatched: true,
          isBlurred: false,
          matchedButtonText: 'View all details',
          onMatchedButtonPressed: () => context.push('/matched-profile-view'),
        ),
      ],
    );
  }

  void _showDeclineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure you want to decline this match?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.4),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE54B5E), // Reddish
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Yes, decline match', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2E6EC), // Light gray
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text('No, go back', style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
