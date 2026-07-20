import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/match_card.dart';
import 'package:get/get.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfiles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles({Map<String, dynamic>? filters}) async {
    final matchesProvider = context.read<MatchesProvider>();
    await matchesProvider.loadDirectory(filters: filters);
  }

  Future<void> _applyFilter(String filter) async {
    setState(() {
      _selectedFilter = filter;
    });

    Map<String, dynamic>? filters;
    switch (filter) {
      case 'online':
        filters = {'online': 'true'};
        break;
      case 'new':
        filters = {'new': 'true'};
        break;
      default:
        filters = null;
    }

    await _loadProfiles(filters: filters);
  }

  Future<void> _handleSendInterest(String userId) async {
    final matchesProvider = context.read<MatchesProvider>();

    final success = await matchesProvider.sendConnectionRequest(userId);

    if (!mounted) return;

    if (success) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Interest sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      Get.showSnackbar(
        GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text(matchesProvider.errorMessage ?? 'Failed to send interest'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchesProvider = context.watch<MatchesProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Browse Profiles',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined,
                color: Theme.of(context).primaryColor),
            onPressed: () => context.push('/settings'),
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms).scale(
              begin: const Offset(0.8, 0.8)),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none,
                    color: Theme.of(context).colorScheme.secondary, size: 28),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle),
                    constraints:
                        const BoxConstraints(minWidth: 12, minHeight: 12),
                  ),
                ),
              ],
            ),
            onPressed: () => context.push('/notifications'),
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(
              begin: const Offset(0.8, 0.8)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadProfiles(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by your preferences',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: Colors.grey[400], size: 22),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // TODO: Open filter dialog
                      Get.showSnackbar(
                          const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('Advanced filters coming soon')));
                    },
                    child: Icon(Icons.tune_rounded, color: Colors.grey[400], size: 20),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                    borderSide: BorderSide(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.4),
                        width: 1.5),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _loadProfiles(filters: {'search': value});
                  }
                },
              ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(
                  begin: -0.2, end: 0),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedFilter == 'all',
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: () => _applyFilter('all'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'Online',
                    isSelected: _selectedFilter == 'online',
                    onTap: () => _applyFilter('online'),
                  ),
                  const SizedBox(width: 12),
                  _FilterChip(
                    label: 'New',
                    isSelected: _selectedFilter == 'new',
                    onTap: () => _applyFilter('new'),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideX(
                  begin: -0.2, end: 0),
              const SizedBox(height: 24),

              // Loading or Profile Cards
              if (matchesProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (matchesProvider.directoryProfiles.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No profiles found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...matchesProvider.directoryProfiles.map((profile) {
                  final index =
                      matchesProvider.directoryProfiles.indexOf(profile);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MatchCard(
                      username: profile.codename,
                      age: profile.age != null
                          ? '${profile.age} Years old'
                          : 'N/A',
                      height: profile.height ?? 'N/A',
                      profession: profile.city ?? 'N/A',
                      imageUrl: profile.photos.isNotEmpty ? profile.photos.first['image'] : null,
                      photos: profile.photos,
                      lockMessage: profile.photoBlurred
                          ? 'Photos will be revealed after mutual interest'
                          : '',
                      isLocked: profile.photoBlurred,
                      onViewProfile: () {
                        context.push('/matches/directory/${profile.id}');
                      },
                      onSendInterest: () => _handleSendInterest(profile.id),
                    )
                        .animate()
                        .fadeIn(
                            duration: 700.ms, delay: (500 + index * 200).ms)
                        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback? onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? Theme.of(context).primaryColor) : Colors.grey[200],
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
