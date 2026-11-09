import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/match_card.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/constants/dropdown_options.dart';
import '../../../../core/constants/choice_mappings.dart';
import 'package:get/get.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();
  RangeValues _filterAgeRange = const RangeValues(18, 70);
  String? _filterSect;
  String? _filterMaritalStatus;
  String? _filterCountry;

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
      SnackBarHelper.showRequestSent(context);
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

  void _showAdvancedFiltersBottomSheet() {
    RangeValues tempAgeRange = _filterAgeRange;
    String? tempSect = _filterSect;
    String? tempMaritalStatus = _filterMaritalStatus;
    String? tempCountry = _filterCountry;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
                top: 20,
                left: 24,
                right: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Advanced Filters',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              tempAgeRange = const RangeValues(18, 70);
                              tempSect = null;
                              tempMaritalStatus = null;
                              tempCountry = null;
                            });
                          },
                          child: const Text('Reset', style: TextStyle(color: Color(0xFFE54B5E), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Age Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Age Range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${tempAgeRange.start.round()} - ${tempAgeRange.end.round()} yrs',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE54B5E))),
                      ],
                    ),
                    RangeSlider(
                      values: tempAgeRange,
                      min: 18,
                      max: 75,
                      divisions: 57,
                      activeColor: const Color(0xFFE54B5E),
                      inactiveColor: Colors.grey[200],
                      onChanged: (values) {
                        setModalState(() {
                          tempAgeRange = values;
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // Religion / Sect Dropdown
                    const Text('Religion / Sect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempSect,
                          isExpanded: true,
                          hint: const Text('Any Sect'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Any Sect')),
                            ...DropdownOptions.religionSect.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                          ],
                          onChanged: (val) => setModalState(() => tempSect = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Marital Status Dropdown
                    const Text('Marital Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempMaritalStatus,
                          isExpanded: true,
                          hint: const Text('Any Marital Status'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Any Marital Status')),
                            ...DropdownOptions.maritalStatus.map((s) => DropdownMenuItem(value: s, child: Text(s))),
                          ],
                          onChanged: (val) => setModalState(() => tempMaritalStatus = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Country Dropdown
                    const Text('Country', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: tempCountry,
                          isExpanded: true,
                          hint: const Text('Any Country'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Any Country')),
                            ...DropdownOptions.countries.map((c) => DropdownMenuItem(value: c, child: Text(c))),
                          ],
                          onChanged: (val) => setModalState(() => tempCountry = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(bottomSheetContext).pop();
                          setState(() {
                            _filterAgeRange = tempAgeRange;
                            _filterSect = tempSect;
                            _filterMaritalStatus = tempMaritalStatus;
                            _filterCountry = tempCountry;
                          });

                          final filters = <String, dynamic>{};
                          filters['min_age'] = tempAgeRange.start.round().toString();
                          filters['max_age'] = tempAgeRange.end.round().toString();
                          if (tempSect != null) {
                            filters['sect'] = ChoiceMappings.displayToKey(tempSect!, ChoiceMappings.sectDisplayToKey);
                          }
                          if (tempMaritalStatus != null) {
                            filters['marital_status'] = ChoiceMappings.displayToKey(tempMaritalStatus!, ChoiceMappings.maritalStatusDisplayToKey);
                          }
                          if (tempCountry != null && tempCountry!.isNotEmpty) {
                            filters['country'] = tempCountry;
                          }
                          _loadProfiles(filters: filters);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE54B5E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                    onTap: _showAdvancedFiltersBottomSheet,
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
                  
                  final user = context.watch<AuthProvider>().currentUser;
                  final isActuallyLocked = profile.photoBlurred;
                  final canSendRequest = user?.role == 'male';
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MatchCard(
                      username: profile.codename,
                      age: profile.age != null
                          ? '${profile.age} Years old'
                          : 'N/A',
                      ethnicity: profile.ethnicity ?? 'N/A',
                      country: profile.country ?? 'N/A',
                      imageUrl: profile.photos.isNotEmpty ? profile.photos.first['image'] : null,
                      photos: profile.photos,
                      lockMessage: isActuallyLocked
                          ? 'Photos will be revealed after mutual interest'
                          : '',
                      isLocked: isActuallyLocked,
                      isBlurred: isActuallyLocked,
                      onViewProfile: () {
                        context.push('/matches/directory/${profile.id}');
                      },
                      onSendInterest: canSendRequest ? () => _handleSendInterest(profile.id) : null,
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
