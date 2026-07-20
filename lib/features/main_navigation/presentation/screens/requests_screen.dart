import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/match_card.dart';
import '../widgets/privacy_banner.dart';
import 'package:get/get.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedIndex = _tabController.index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final matchesProvider = context.read<MatchesProvider>();
    await Future.wait([
      matchesProvider.loadReceivedRequests(),
      matchesProvider.loadSentRequests(),
      matchesProvider.loadMatches(),
    ]);
  }

  Future<void> _handleAcceptRequest(String requestId) async {
    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.respondToRequest(requestId: requestId, accept: true);
    
    if (!mounted) return;
    
    if (success) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Match Accepted!'), backgroundColor: Colors.green),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(matchesProvider.errorMessage ?? 'Failed to accept'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDeclineRequest(String requestId) async {
    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.respondToRequest(requestId: requestId, accept: false);
    
    if (!mounted) return;
    
    if (success) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Request Declined'), backgroundColor: Colors.orange),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(matchesProvider.errorMessage ?? 'Failed to decline'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleCancelRequest(String requestId) async {
    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.cancelRequest(requestId);
    
    if (!mounted) return;
    
    if (success) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Request Cancelled!'), backgroundColor: Colors.orange),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(matchesProvider.errorMessage ?? 'Failed to cancel'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final matchesProvider = context.watch<MatchesProvider>();

    final photoRequests = matchesProvider.matches.where(
      (m) => m.photoRequestStatus == 'requested' && m.photoRequestedByOtherUser
    ).toList();

    final tabs = [
      _TabItem(
        label: 'Received',
        icon: Icons.move_to_inbox_outlined,
        count: matchesProvider.receivedRequests.length + photoRequests.length,
      ),
      _TabItem(
        label: 'Sent',
        icon: Icons.send_outlined,
        count: matchesProvider.sentRequests.length,
      ),
      _TabItem(
        label: 'Matches',
        icon: Icons.favorite_outline,
        count: matchesProvider.matches.length,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Requests', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 22)),
            Text('Manage your connections', style: TextStyle(color: Colors.black38, fontSize: 11)),
          ],
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: primaryColor),
            onPressed: () => context.push('/settings'),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms).scale(begin: const Offset(0.8, 0.8)),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: secondaryColor, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
            onPressed: () => context.push('/notifications'),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _CustomTabBar(
              tabs: tabs,
              selectedIndex: _selectedIndex,
              primaryColor: primaryColor,
              onTap: (i) {
                setState(() => _selectedIndex = i);
                _tabController.animateTo(i);
              },
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 0.3, end: 0),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReceivedTab(context, primaryColor, matchesProvider),
          _buildSentTab(context, matchesProvider),
          _buildMatchesTab(context, matchesProvider),
        ],
      ),
    );
  }

  Widget _buildReceivedTab(BuildContext context, Color primaryColor, MatchesProvider matchesProvider) {
    if (matchesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    final photoRequests = matchesProvider.matches.where(
      (m) => m.photoRequestStatus == 'requested' && m.photoRequestedByOtherUser
    ).toList();

    if (matchesProvider.receivedRequests.isEmpty && photoRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No received requests', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await matchesProvider.loadReceivedRequests();
        await matchesProvider.loadMatches();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          const PrivacyBanner(subtitle: 'Photos are hidden and contact details are shared only after mutual approval')
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms),
          const SizedBox(height: 20),
          
          // Show Photo Requests
          ...photoRequests.map((match) {
            final index = photoRequests.indexOf(match);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MatchCard(
                username: match.matchedUserCodename,
                age: match.matchedUserAge != null ? '${match.matchedUserAge} Years old' : 'N/A',
                height: match.matchedUserHeight ?? 'N/A',
                profession: match.matchedUserCity ?? 'N/A',
                imageUrl: match.matchedUserPhotos.isNotEmpty ? match.matchedUserPhotos.first['image'] : null,
                photos: match.matchedUserPhotos,
                lockMessage: '',
                isLocked: false,
                isMatched: true,
                isBlurred: true,
                matchedButtonText: 'Review Photo Request',
                onMatchedButtonPressed: () => context.push('/matches/${match.matchedUserId}'),
              ).animate().fadeIn(duration: 700.ms, delay: (400 + index * 200).ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            );
          }).toList(),
          
          // Show Connection Requests
          ...matchesProvider.receivedRequests.map((request) {
            final index = matchesProvider.receivedRequests.indexOf(request);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MatchCard(
                username: request.senderCodename,
                age: request.senderAge != null ? '${request.senderAge} Years old' : 'N/A',
                height: request.senderHeight ?? 'N/A',
                profession: request.senderCity ?? 'N/A',
                imageUrl: request.otherUserPhotos.isNotEmpty ? request.otherUserPhotos.first['image'] : null,
                photos: request.otherUserPhotos,
                lockMessage: 'Photos will be revealed after mutual interest',
                onDecline: () => _showDeclineDialog(context, request.id),
                onAccept: () => _handleAcceptRequest(request.id),
              ).animate().fadeIn(duration: 700.ms, delay: (500 + index * 200).ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSentTab(BuildContext context, MatchesProvider matchesProvider) {
    if (matchesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (matchesProvider.sentRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No sent requests', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => matchesProvider.loadSentRequests(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          const PrivacyBanner(subtitle: 'Photos are hidden and contact details are shared only after mutual approval')
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms),
          const SizedBox(height: 20),
          ...matchesProvider.sentRequests.map((request) {
            final index = matchesProvider.sentRequests.indexOf(request);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: MatchCard(
                username: request.receiverCodename,
                age: request.receiverAge != null ? '${request.receiverAge} Years old' : 'N/A',
                height: request.receiverHeight ?? 'N/A',
                profession: request.receiverCity ?? 'N/A',
                imageUrl: request.otherUserPhotos.isNotEmpty ? request.otherUserPhotos.first['image'] : null,
                photos: request.otherUserPhotos,
                lockMessage: 'Photos will be revealed after mutual interest',
                onCancelRequest: () => _showCancelDialog(context, request.id),
                onViewProfile: () => context.push('/matches/directory/${request.receiverId}'),
              ).animate().fadeIn(duration: 700.ms, delay: (500 + index * 200).ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMatchesTab(BuildContext context, MatchesProvider matchesProvider) {
    if (matchesProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (matchesProvider.matches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No matches yet', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => matchesProvider.loadMatches(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: matchesProvider.matches.map((match) {
          final index = matchesProvider.matches.indexOf(match);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: MatchCard(
              username: match.matchedUserCodename,
              age: match.matchedUserAge != null ? '${match.matchedUserAge} Years old' : 'N/A',
              height: match.matchedUserHeight ?? 'N/A',
              profession: match.matchedUserCity ?? 'N/A',
              imageUrl: match.matchedUserPhotos.isNotEmpty ? match.matchedUserPhotos.first['image'] : null,
              photos: match.matchedUserPhotos,
              lockMessage: '',
              isLocked: false,
              isMatched: true,
              isBlurred: false,
              matchedButtonText: (match.photoRequestStatus == 'requested' && match.photoRequestedByOtherUser) 
                  ? 'Review Photo Request' 
                  : 'View photos',
              onMatchedButtonPressed: () => context.push('/matches/${match.matchedUserId}'),
            ).animate().fadeIn(duration: 700.ms, delay: (400 + index * 200).ms).slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
          );
        }).toList(),
      ),
    );
  }

  void _showDeclineDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, color: Color(0xFFE54B5E), size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Decline Match?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to decline this match request?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.5),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleDeclineRequest(requestId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE54B5E),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text('Yes, decline', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No, go back', style: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.cancel_outlined, color: Color(0xFFE57C04), size: 32),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cancel Request?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to cancel this request?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500], height: 1.5),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleCancelRequest(requestId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE57C04),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text('Yes, cancel', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('No, go back', style: TextStyle(color: Color(0xFF1E293B), fontSize: 15, fontWeight: FontWeight.w600)),
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

// ── Tab Item Model ─────────────────────────────────────────────────────────────
class _TabItem {
  final String label;
  final IconData icon;
  final int count;

  const _TabItem({required this.label, required this.icon, required this.count});
}

// ── Custom Tab Bar ─────────────────────────────────────────────────────────────
class _CustomTabBar extends StatelessWidget {
  final List<_TabItem> tabs;
  final int selectedIndex;
  final Color primaryColor;
  final ValueChanged<int> onTap;

  const _CustomTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          final tab = tabs[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [BoxShadow(color: primaryColor.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 3))]
                      : [],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      scale: isSelected ? 1.0 : 0.85,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        tab.icon,
                        size: 16,
                        color: isSelected ? primaryColor : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 5),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? primaryColor : Colors.grey[500],
                      ),
                      child: Text(tab.label),
                    ),
                    if (tab.count > 0) ...[
                      const SizedBox(width: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor : Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${tab.count}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
