import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileViewDetailsScreen extends StatefulWidget {
  const ProfileViewDetailsScreen({super.key});

  @override
  State<ProfileViewDetailsScreen> createState() => _ProfileViewDetailsScreenState();
}

class _ProfileViewDetailsScreenState extends State<ProfileViewDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

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
              onTap: () => context.pop(),
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
              // Settings
              GestureDetector(
                onTap: () => context.push('/settings'),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms).scale(begin: const Offset(0.7, 0.7)),
              // Notifications
              GestureDetector(
                onTap: () => context.push('/notifications'),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                      Positioned(
                        right: 0, top: 0,
                        child: Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 150.ms).scale(begin: const Offset(0.7, 0.7)),
              // More options
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
                onSelected: (value) {},
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(value: 'hide', child: Text('Hide Profile')),
                  const PopupMenuItem<String>(value: 'block', child: Text('Block Profile')),
                  const PopupMenuItem<String>(value: 'report', child: Text('Report Profile')),
                ],
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroImageSection(primaryColor: primaryColor),
            ),
          ),

          // ── Profile Header Info ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + ID Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'mm31',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 4),
                            Text('28 years • London, UK', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            const Text('Online', style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600)),
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
                      _InfoChip(icon: Icons.work_outline, label: 'Software Engineer', color: Colors.blue),
                      _InfoChip(icon: Icons.height, label: "5'6\"", color: Colors.orange),
                      _InfoChip(icon: Icons.star_outline, label: 'Single', color: Colors.purple),
                      _InfoChip(icon: Icons.menu_book_outlined, label: 'Shia', color: Colors.teal),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 350.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 20),

                  // Send Interest Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_rounded, size: 18, color: Colors.white),
                      label: const Text('Send Interest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                            style: TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.5),
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
      ['Name', 'mm31'],
      ['Age', '28 Years old'],
      ['City', 'London'],
      ['Country', 'United Kingdom'],
      ['Sect', 'Shia'],
      ['Marital Status', 'Single'],
      ['Ethnicity', 'Arab'],
      ['Nationality / Citizenship', 'British citizenship'],
      ['Do you have children?', 'No'],
      ['Height', "5'6 ft"],
      ['Weight', '58 kg'],
      ['Prayer 5x a day?', 'Mostly'],
      ['Open to relocating?', 'Mostly'],
      ['How do you dress?', 'Modestly'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (i) {
        return _InfoRow(label: fields[i][0], value: fields[i][1], primaryColor: primaryColor)
            .animate()
            .fadeIn(duration: 400.ms, delay: Duration(milliseconds: i * 40))
            .slideX(begin: 0.1, end: 0);
      }),
    );
  }

  // ── About Me ──────────────────────────────────────────────────────────
  Widget _buildAboutMeTab(Color primaryColor) {
    final fields = [
      ['Idea of marriage', 'Discover the endless possibilities with our innovative platform designed to simplify your daily tasks and boost productivity.'],
      ['Relationship with Islam', 'Life is a continuous journey filled with moments of spiritual growth and challenges, through various experiences.'],
      ['Role as a spouse', 'Sure! Here\'s a detailed answer for the heading you provided. Please share the heading so I can tailor the content accordingly.'],
      ['About yourself', 'Lorem ipsum dolor sit amet consectetur. Condimentum massa nec tortor turpis. Proin adipiscing duis nam accumsan mattis ante.'],
      ['Envision your spouse', 'Lorem ipsum dolor sit amet consectetur. Adipiscing donec sem tortor magna. Mi dui in enim eu consequat libero convallis proin.'],
      ['Envision your marriage', 'Lorem ipsum dolor sit amet consectetur. Aliquam vel adipiscing mattis lacus lacus. Pretium proin porttitor in cursus luctus eu sit.'],
      ['Religious preference', 'Lorem ipsum dolor sit amet consectetur. Neque dui amet volutpat vehicula urna a enim.'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(fields.length, (i) {
        return _InfoRow(label: fields[i][0], value: fields[i][1], primaryColor: primaryColor, multiLine: true)
            .animate()
            .fadeIn(duration: 400.ms, delay: Duration(milliseconds: i * 50))
            .slideX(begin: 0.1, end: 0);
      }),
    );
  }

  // ── Preferences ───────────────────────────────────────────────────────
  Widget _buildPreferencesTab(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Preferred Age Range', value: '22-35', primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
        _InfoRow(label: 'Preferred Marital Status', value: 'Never been married', primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms, delay: 50.ms).slideX(begin: 0.1, end: 0),
        _InfoRow(label: 'Country of Residence', value: 'United Kingdom', primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.1, end: 0),
        const SizedBox(height: 4),
        Text('Preferred Ethnicity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600]))
            .animate().fadeIn(duration: 400.ms, delay: 150.ms),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Pakistani', 'Arab', 'Turkish'].asMap().entries.map((e) {
            return _PreferenceChip(label: e.value, primaryColor: primaryColor)
                .animate()
                .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 200 + e.key * 60))
                .scale(begin: const Offset(0.8, 0.8));
          }).toList(),
        ),
      ],
    );
  }
}

// ── Hero Image Section ─────────────────────────────────────────────────────────
class _HeroImageSection extends StatelessWidget {
  final Color primaryColor;
  const _HeroImageSection({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/blurredProfile1.png', fit: BoxFit.cover),
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
        // Lock & photo count overlay (bottom)
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.lock_outline_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Photos revealed after mutual interest',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Photo count (top right)
        Positioned(
          top: kToolbarHeight + MediaQuery.of(context).padding.top - 8,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.photo_library_outlined, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('5', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
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

  const _InfoChip({required this.icon, required this.label, required this.color});

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
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Preference Chip ───────────────────────────────────────────────────────────
class _PreferenceChip extends StatelessWidget {
  final String label;
  final Color primaryColor;

  const _PreferenceChip({required this.label, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Text(label, style: TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.w600)),
    );
  }
}
