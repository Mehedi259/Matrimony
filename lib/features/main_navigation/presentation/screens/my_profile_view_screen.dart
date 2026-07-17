import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/profile_provider.dart';

class MyProfileViewScreen extends StatefulWidget {
  const MyProfileViewScreen({super.key});

  @override
  State<MyProfileViewScreen> createState() => _MyProfileViewScreenState();
}

class _MyProfileViewScreenState extends State<MyProfileViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  bool _isLoading = true;

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final profileProvider = context.read<ProfileProvider>();
    await Future.wait([
      profileProvider.loadBasicInfo(),
      profileProvider.loadPhotos(),
    ]);
    if (mounted) {
      setState(() => _isLoading = false);
    }
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
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final user = authProvider.currentUser;
    final basicInfo = profileProvider.basicInfo;
    final photos = profileProvider.photos;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: BackButton(onPressed: () => context.pop()),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final displayName = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    final ageText = basicInfo?.age != null ? '${basicInfo!.age} years' : '';
    final cityText = basicInfo?.city ?? '';
    final countryText = basicInfo?.country ?? '';
    final locationText = [cityText, countryText]
        .where((s) => s.isNotEmpty && s.toLowerCase() != 'string')
        .join(', ');
    final subtitle = [ageText, locationText].where((s) => s.isNotEmpty).join(' • ');

    // Primary photo URL
    String? primaryPhotoUrl;
    if (photos.isNotEmpty) {
      final primary = photos.where((p) => p.isPrimary).toList();
      primaryPhotoUrl = primary.isNotEmpty ? primary.first.imageUrl : photos.first.imageUrl;
    }
    primaryPhotoUrl ??= user?.profilePicture;

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
            title: Text(
              'Your Profile Preview',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
            flexibleSpace: FlexibleSpaceBar(
              background: _MyHeroImageSection(
                primaryColor: primaryColor,
                photoUrl: primaryPhotoUrl,
                photoCount: photos.length,
              ),
            ),
          ),

          // ── "View As" Banner ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor.withValues(alpha: 0.12), primaryColor.withValues(alpha: 0.04)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove_red_eye_outlined, color: primaryColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Preview Mode',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'This is how others see your profile',
                            style: TextStyle(fontSize: 11, color: primaryColor.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 150.ms).slideY(begin: -0.2, end: 0),
            ),
          ),

          // ── Profile Name + Info ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Online badge
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName.isNotEmpty ? displayName : 'No Name',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 4),
                            if (subtitle.isNotEmpty)
                              Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
                            Container(
                              width: 8, height: 8,
                              decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                            ),
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
                      if (basicInfo?.employment != null && basicInfo!.employment!.isNotEmpty)
                        _InfoChip(icon: Icons.work_outline, label: _formatText(basicInfo!.employment!), color: Colors.blue),
                      if (basicInfo?.height != null && basicInfo!.height!.isNotEmpty)
                        _InfoChip(icon: Icons.height, label: basicInfo!.height!, color: Colors.orange),
                      if (basicInfo?.maritalStatus != null && basicInfo!.maritalStatus!.isNotEmpty)
                        _InfoChip(icon: Icons.star_outline, label: _formatText(basicInfo!.maritalStatus!), color: Colors.purple),
                      if (basicInfo?.sect != null && basicInfo!.sect!.isNotEmpty)
                        _InfoChip(icon: Icons.menu_book_outlined, label: _formatText(basicInfo!.sect!), color: Colors.teal),
                    ],
                  ).animate().fadeIn(duration: 600.ms, delay: 350.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 20),

                  // Send Interest button (disabled — it's your own profile)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: Icon(Icons.favorite_rounded, size: 18, color: Colors.grey[400]),
                      label: Text(
                        'Send Interest',
                        style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        disabledBackgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 450.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 10),

                  // "This is your own profile" note
                  Center(
                    child: Text(
                      '* You cannot send interest to yourself',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400], fontStyle: FontStyle.italic),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                  const SizedBox(height: 16),

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

          // ── Sticky Custom Tab Bar ──────────────────────────────────────
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
                    ? _buildBasicInfoTab(primaryColor, basicInfo, user)
                    : _selectedTab == 1
                        ? _buildAboutMeTab(primaryColor, basicInfo)
                        : _buildPreferencesTab(primaryColor, basicInfo),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatText(String text) {
    if (text.isEmpty) return text;
    final formatted = text.replaceAll('_', ' ');
    return formatted.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  // ── Basic Info ────────────────────────────────────────────────────────
  Widget _buildBasicInfoTab(Color primaryColor, basicInfo, user) {
    final fields = <List<String>>[];

    final name = '${user?.firstName ?? ''} ${user?.lastName ?? ''}'.trim();
    if (name.isNotEmpty) fields.add(['Name', name]);
    if (basicInfo?.dateOfBirth != null) fields.add(['Date of Birth', basicInfo!.dateOfBirth!]);
    if (basicInfo?.city != null) fields.add(['City', basicInfo!.city!]);
    if (basicInfo?.country != null) fields.add(['Country', basicInfo!.country!]);
    if (basicInfo?.sect != null) fields.add(['Sect', _formatText(basicInfo!.sect!)]);
    if (basicInfo?.maritalStatus != null) fields.add(['Marital Status', _formatText(basicInfo!.maritalStatus!)]);
    if (basicInfo?.ethnicity != null && basicInfo!.ethnicity.isNotEmpty) fields.add(['Ethnicity', basicInfo!.ethnicity.map((e) => _formatText(e)).join(', ')]);
    if (basicInfo?.nationality != null && basicInfo!.nationality.isNotEmpty) fields.add(['Nationality / Citizenship', basicInfo!.nationality.map((e) => _formatText(e)).join(', ')]);
    if (basicInfo?.hasChildren != null) fields.add(['Do you have children?', basicInfo!.hasChildren! ? 'Yes' : 'No']);
    if (basicInfo?.height != null) fields.add(['Height', basicInfo!.height!]);
    if (basicInfo?.weight != null) fields.add(['Weight', basicInfo!.weight!]);
    if (basicInfo?.pray5x != null) fields.add(['Prayer 5x a day?', _formatText(basicInfo!.pray5x!)]);
    if (basicInfo?.openToRelocate != null) fields.add(['Open to relocating?', _formatText(basicInfo!.openToRelocate!)]);
    if (basicInfo?.preferredDress != null) fields.add(['How do you dress?', _formatText(basicInfo!.preferredDress!)]);
    if (basicInfo?.employment != null) fields.add(['Employment', _formatText(basicInfo!.employment!)]);
    if (basicInfo?.education != null) fields.add(['Education', _formatText(basicInfo!.education!)]);
    if (basicInfo?.income != null) fields.add(['Income', basicInfo!.income!]);
    if (basicInfo?.frame != null) fields.add(['Frame', _formatText(basicInfo!.frame!)]);
    if (basicInfo?.languagesSpoken != null && basicInfo!.languagesSpoken.isNotEmpty) fields.add(['Languages Spoken', basicInfo!.languagesSpoken.join(', ')]);

    if (fields.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No basic info added yet.', style: TextStyle(color: Colors.grey[500])),
        ),
      );
    }

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
  Widget _buildAboutMeTab(Color primaryColor, basicInfo) {
    final fields = <List<String>>[];

    if (basicInfo?.envisionMarriage != null && basicInfo!.envisionMarriage!.isNotEmpty) fields.add(['Idea of marriage', basicInfo!.envisionMarriage!]);
    if (basicInfo?.relationshipWithIslam != null && basicInfo!.relationshipWithIslam!.isNotEmpty) fields.add(['Relationship with Islam', basicInfo!.relationshipWithIslam!]);
    if (basicInfo?.roleAsSpouse != null && basicInfo!.roleAsSpouse!.isNotEmpty) fields.add(['Role as a spouse', basicInfo!.roleAsSpouse!]);
    if (basicInfo?.aboutYourself != null && basicInfo!.aboutYourself!.isNotEmpty) fields.add(['About yourself', basicInfo!.aboutYourself!]);
    if (basicInfo?.envisionSpouse != null && basicInfo!.envisionSpouse!.isNotEmpty) fields.add(['Envision your spouse', basicInfo!.envisionSpouse!]);
    if (basicInfo?.spouseReligiousStatusPref != null && basicInfo!.spouseReligiousStatusPref!.isNotEmpty) fields.add(['Religious preference', basicInfo!.spouseReligiousStatusPref!]);
    if (basicInfo?.otherPreferences != null && basicInfo!.otherPreferences!.isNotEmpty) fields.add(['Other preferences', basicInfo!.otherPreferences!]);

    if (fields.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No about me info added yet.', style: TextStyle(color: Colors.grey[500])),
        ),
      );
    }

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
  Widget _buildPreferencesTab(Color primaryColor, basicInfo) {
    final List<Widget> children = [];

    if (basicInfo?.prefAgeMin != null && basicInfo?.prefAgeMax != null) {
      children.add(
        _InfoRow(label: 'Preferred Age Range', value: '${basicInfo!.prefAgeMin}-${basicInfo!.prefAgeMax}', primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0),
      );
    }

    if (basicInfo?.prefMaritalStatus != null && basicInfo!.prefMaritalStatus.isNotEmpty) {
      children.add(
        _InfoRow(label: 'Preferred Marital Status', value: basicInfo!.prefMaritalStatus.join(', '), primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms, delay: 50.ms).slideX(begin: 0.1, end: 0),
      );
    }

    if (basicInfo?.prefCountryOfResidence != null && basicInfo!.prefCountryOfResidence.isNotEmpty) {
      children.add(
        _InfoRow(label: 'Country of Residence', value: basicInfo!.prefCountryOfResidence.join(', '), primaryColor: primaryColor)
            .animate().fadeIn(duration: 400.ms, delay: 100.ms).slideX(begin: 0.1, end: 0),
      );
    }

    if (basicInfo?.prefEthnicity != null && basicInfo!.prefEthnicity.isNotEmpty) {
      children.add(const SizedBox(height: 4));
      children.add(
        Text('Preferred Ethnicity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600]))
            .animate().fadeIn(duration: 400.ms, delay: 150.ms),
      );
      children.add(const SizedBox(height: 10));
      children.add(
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: basicInfo!.prefEthnicity.asMap().entries.map<Widget>((e) {
            return _PreferenceChip(label: e.value, primaryColor: primaryColor)
                .animate()
                .fadeIn(duration: 400.ms, delay: Duration(milliseconds: (200 + e.key * 60).toInt()))
                .scale(begin: const Offset(0.8, 0.8));
          }).toList(),
        ),
      );
    }

    if (children.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No preferences added yet.', style: TextStyle(color: Colors.grey[500])),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// ── My Hero Image Section ─────────────────────────────────────────────────────
class _MyHeroImageSection extends StatelessWidget {
  final Color primaryColor;
  final String? photoUrl;
  final int photoCount;

  const _MyHeroImageSection({
    required this.primaryColor,
    this.photoUrl,
    required this.photoCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (photoUrl != null)
          Image.network(photoUrl!, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.person, size: 80, color: Colors.white),
            ),
          )
        else
          Container(
            color: Colors.grey[300],
            child: const Icon(Icons.person, size: 80, color: Colors.white),
          ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.0),
                Colors.black.withValues(alpha: 0.55),
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
        ),
        // Lock message (bottom)
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
                Text(
                  'Photos revealed after mutual interest',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        // Photo count (top right area)
        Positioned(
          top: kToolbarHeight + MediaQuery.of(context).padding.top - 4,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo_library_outlined, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text('$photoCount', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
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

  @override double get minExtent => 60;
  @override double get maxExtent => 60;

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
