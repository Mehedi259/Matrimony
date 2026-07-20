import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/matches_provider.dart';
import '../../../../data/models/matches/match_profile_model.dart';
import 'package:get/get.dart';

class ProfileViewDetailsScreen extends StatefulWidget {
  final String userId;
  
  const ProfileViewDetailsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewDetailsScreen> createState() => _ProfileViewDetailsScreenState();
}

class _ProfileViewDetailsScreenState extends State<ProfileViewDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  MatchProfileModel? _profile;
  bool _isLoading = true;
  String? _errorMessage;

  final List<String> _tabLabels = ['Basic Info', 'About Me', 'Preferences'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
    // Use addPostFrameCallback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.getProfileDetails(widget.userId);

    if (success && matchesProvider.selectedProfile != null) {
      setState(() {
        _profile = matchesProvider.selectedProfile;
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = matchesProvider.errorMessage ?? 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSendInterest() async {
    if (_profile == null) return;

    final matchesProvider = context.read<MatchesProvider>();
    final success = await matchesProvider.sendConnectionRequest(_profile!.id);

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
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _profile == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Profile not found',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadProfileData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: CustomScrollView(
        slivers: [
          // ── Hero SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
            ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.7, 0.7)),
            actions: [
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms).scale(begin: const Offset(0.7, 0.7)),
              PopupMenuButton<String>(
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_horiz, color: Colors.white, size: 20),
                ),
                onSelected: (value) {
                  // Handle menu actions
                  Get.showSnackbar(
                    GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          duration: const Duration(seconds: 3),
          messageText: Text('$value selected')),
                  );
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'Hide Profile', child: Text('Hide Profile')),
                  const PopupMenuItem<String>(value: 'Block Profile', child: Text('Block Profile')),
                  const PopupMenuItem<String>(value: 'Report Profile', child: Text('Report Profile')),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImageSection(
                primaryColor: primaryColor,
                photoBlurred: _profile!.photoBlurred,
                codename: _profile!.codename,
              ),
            ),
          ),

          // ── Profile Header Info ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _profile!.codename,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_profile!.age ?? 'N/A'} years • ${_profile!.city ?? 'Unknown'}, ${_profile!.country ?? ''}',
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (_profile!.isOnline)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),

                  // Quick info chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_profile!.occupation != null)
                        _InfoChip(
                          icon: Icons.work_outline,
                          label: _profile!.occupation!,
                          color: Colors.blue,
                        ),
                      if (_profile!.height != null)
                        _InfoChip(
                          icon: Icons.height,
                          label: _profile!.height!,
                          color: Colors.orange,
                        ),
                      if (_profile!.maritalStatus != null)
                        _InfoChip(
                          icon: Icons.star_outline,
                          label: _profile!.maritalStatus!,
                          color: Colors.purple,
                        ),
                      if (_profile!.sect != null)
                        _InfoChip(
                          icon: Icons.menu_book_outlined,
                          label: _profile!.sect!,
                          color: Colors.teal,
                        ),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 350.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 20),

                  // Send Interest Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _handleSendInterest,
                      icon: const Icon(Icons.favorite_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        'Send Interest',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),

                  // Privacy notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: secondaryColor.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: secondaryColor, size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Full name, photos & contact details are shared only at the appropriate stage.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 550.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Custom Tab Bar ─────────────────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: _tabController,
              labels: _tabLabels,
              selectedIndex: _selectedTab,
              primaryColor: primaryColor,
              onTap: (i) {
                setState(() => _selectedTab = i);
                _tabController.animateTo(i);
              },
            ),
          ),

          // ── Tab Content ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: ValueKey(_selectedTab),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: _selectedTab == 0
                    ? _buildBasicInfoTab(primaryColor)
                    : _selectedTab == 1
                        ? _buildAboutMeTab(primaryColor)
                        : _buildPreferencesTab(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Basic Info ────────────────────────────────────────────────────────
  Widget _buildBasicInfoTab(Color primaryColor) {
    final fields = [
      ['Codename', _profile!.codename],
      ['Age', _profile!.age?.toString() ?? 'N/A'],
      ['City', _profile!.city ?? 'N/A'],
      ['Country', _profile!.country ?? 'N/A'],
      ['Sect', _profile!.sect ?? 'N/A'],
      ['Marital Status', _profile!.maritalStatus ?? 'N/A'],
      ['Ethnicity', _profile!.ethnicity ?? 'N/A'],
      ['Height', _profile!.height ?? 'N/A'],
      ['Occupation', _profile!.occupation ?? 'N/A'],
      ['Education', _profile!.education ?? 'N/A'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (i) {
        return _InfoRow(
          label: fields[i][0],
          value: fields[i][1],
          primaryColor: primaryColor,
        ).animate()
            .fadeIn(duration: 400.ms, delay: Duration(milliseconds: i * 40))
            .slideX(begin: 0.1, end: 0);
      }),
    );
  }

  // ── About Me ──────────────────────────────────────────────────────────
  Widget _buildAboutMeTab(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: 'About',
          value: _profile!.bio ?? 'No information provided',
          primaryColor: primaryColor,
          multiLine: true,
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
        
        if (_profile!.languages != null && _profile!.languages!.isNotEmpty)
          _InfoRow(
            label: 'Languages',
            value: _profile!.languages!,
            primaryColor: primaryColor,
          ).animate().fadeIn(duration: 400.ms, delay: 50.ms).slideX(begin: 0.1, end: 0),
      ],
    );
  }

  // ── Preferences ───────────────────────────────────────────────────────
  Widget _buildPreferencesTab(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile preferences will be visible after mutual match',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ).animate().fadeIn(duration: 400.ms),
      ],
    );
  }
}

// ── Hero Image Section ─────────────────────────────────────────────────────────
class _HeroImageSection extends StatelessWidget {
  final Color primaryColor;
  final bool photoBlurred;
  final String codename;

  const _HeroImageSection({
    required this.primaryColor,
    required this.photoBlurred,
    required this.codename,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Profile image (blurred if needed)
        Image.asset(
          photoBlurred ? 'assets/blurredProfile1.png' : 'assets/profileImage.png',
          fit: BoxFit.cover,
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.1),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.5),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        
        // Lock message if photo is blurred
        if (photoBlurred)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Photos revealed after mutual interest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ── Sticky Tab Bar Delegate ────────────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> labels;
  final int selectedIndex;
  final Color primaryColor;
  final ValueChanged<int> onTap;

  _TabBarDelegate({
    required this.tabController,
    required this.labels,
    required this.selectedIndex,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF6F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFEBEDF2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: List.generate(labels.length, (i) {
            final isSelected = i == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [BoxShadow(color: primaryColor.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? primaryColor : Colors.grey[500],
                    ),
                    child: Text(labels[i]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex;
}

// ── Info Row ──────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color primaryColor;
  final bool multiLine;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.primaryColor,
    this.multiLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: multiLine ? null : 1,
                overflow: multiLine ? null : TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Chip ─────────────────────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
