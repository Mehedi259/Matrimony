import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/matches_provider.dart';
import '../widgets/header_action_buttons.dart';
import '../widgets/match_card.dart';
import '../widgets/upgrade_subscription_dialog.dart';
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
  String? _filterLastActivity;
  String? _filterSect;
  String? _filterMaritalStatus;
  String? _filterCountry;
  String? _filterEthnicity;
  String? _filterNationality;
  String? _filterHasChildren;
  String? _filterPrefMaritalStatus;
  bool _enablePrefAgeFilter = false;
  RangeValues _filterPrefAgeRange = const RangeValues(18, 50);
  String? _filterPrefEthnicity;
  Map<String, dynamic>? _currentApiFilters;
  Duration? _currentMaxLastActiveAge;

  static const Map<String, Duration> _lastActivityDurations = {
    'online': Duration(minutes: 5),
    '24h': Duration(hours: 24),
    '7d': Duration(days: 7),
    '30d': Duration(days: 30),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfiles(includeConnections: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles({
    Map<String, dynamic>? filters,
    Duration? maxLastActiveAge,
    bool updateFilterState = false,
    bool includeConnections = false,
  }) async {
    if (updateFilterState) {
      _currentApiFilters = filters;
      _currentMaxLastActiveAge = maxLastActiveAge;
    }

    final effectiveFilters = updateFilterState ? filters : _currentApiFilters;
    final effectiveMaxAge =
        updateFilterState ? maxLastActiveAge : _currentMaxLastActiveAge;

    final matchesProvider = context.read<MatchesProvider>();
    final role = context.read<AuthProvider>().currentUser?.role;
    if (includeConnections) {
      await Future.wait([
        matchesProvider.loadWishlists(),
        matchesProvider.loadConnectionRequestsForRole(role),
        matchesProvider.loadMatches(),
        matchesProvider.fetchConnectionUsage(),
      ]);
    }
    if (!mounted) return;
    await matchesProvider.loadDirectory(
      filters: effectiveFilters,
      maxLastActiveAge: effectiveMaxAge,
    );
  }

  Future<void> _applyFilter(String filter) async {
    setState(() {
      _selectedFilter = filter;
    });

    Map<String, dynamic>? filters;
    Duration? maxAge;
    switch (filter) {
      case 'online':
        filters = {'online': 'true'};
        maxAge = const Duration(minutes: 5);
        break;
      case 'new':
        filters = {'new': 'true'};
        break;
      default:
        filters = null;
    }

    await _loadProfiles(
      filters: filters,
      maxLastActiveAge: maxAge,
      updateFilterState: true,
    );
  }

  Future<void> _handleSendInterest(String userId) async {
    final matchesProvider = context.read<MatchesProvider>();

    if (matchesProvider.isCurrentUserProfileLocked) {
      Get.showSnackbar(
        const GetSnackBar(
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 8,
          duration: Duration(seconds: 3),
          messageText: Text(
            'Your profile is locked in an active Wali discussion.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurple,
        ),
      );
      return;
    }

    final success = await matchesProvider.sendConnectionRequest(userId);

    if (!mounted) return;

    if (success) {
      SnackBarHelper.showRequestSent(context);
      if (matchesProvider.justExhaustedRequests) {
        showUpgradeSubscriptionDialog(context);
      }
    } else if (matchesProvider.lastSendFailedDueToLimit) {
      showUpgradeSubscriptionDialog(
        context,
        subtitle: matchesProvider.errorMessage,
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

  Widget _buildFilterDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String?>(
              value: value,
              isExpanded: true,
              hint: Text(hint),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showAdvancedFiltersBottomSheet() {
    RangeValues tempAgeRange = _filterAgeRange;
    String? tempLastActivity = _filterLastActivity;
    String? tempSect = _filterSect;
    String? tempMaritalStatus = _filterMaritalStatus;
    String? tempCountry = _filterCountry;
    String? tempEthnicity = _filterEthnicity;
    String? tempNationality = _filterNationality;
    String? tempHasChildren = _filterHasChildren;
    String? tempPrefMaritalStatus = _filterPrefMaritalStatus;
    bool tempEnablePrefAgeFilter = _enablePrefAgeFilter;
    RangeValues tempPrefAgeRange = _filterPrefAgeRange;
    String? tempPrefEthnicity = _filterPrefEthnicity;

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        final maxSheetHeight =
            MediaQuery.of(bottomSheetContext).size.height * 0.85;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(bottomSheetContext).viewInsets.bottom + 16,
                    top: 16,
                    left: 24,
                    right: 24,
                  ),
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Advanced Filters',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempAgeRange = const RangeValues(18, 70);
                                tempLastActivity = null;
                                tempSect = null;
                                tempMaritalStatus = null;
                                tempCountry = null;
                                tempEthnicity = null;
                                tempNationality = null;
                                tempHasChildren = null;
                                tempPrefMaritalStatus = null;
                                tempEnablePrefAgeFilter = false;
                                tempPrefAgeRange = const RangeValues(18, 50);
                                tempPrefEthnicity = null;
                              });
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Color(0xFFE54B5E),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Age Range',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${tempAgeRange.start.round()} - ${tempAgeRange.end.round()} yrs',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE54B5E),
                                    ),
                                  ),
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
                                  setModalState(() => tempAgeRange = values);
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildFilterDropdown(
                                label: 'Last Activity',
                                hint: 'Any Time',
                                value: tempLastActivity,
                                items: const [
                                  DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Time'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: 'online',
                                    child: Text('Active Now (last 5 mins)'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: '24h',
                                    child: Text('Last 24 Hours'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: '7d',
                                    child: Text('Last 7 Days'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: '30d',
                                    child: Text('Last 30 Days'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempLastActivity = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Religion / Sect',
                                hint: 'Any Sect',
                                value: tempSect,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Sect'),
                                  ),
                                  ...DropdownOptions.religionSect.map(
                                    (s) => DropdownMenuItem<String?>(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempSect = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Marital Status',
                                hint: 'Any Marital Status',
                                value: tempMaritalStatus,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Marital Status'),
                                  ),
                                  ...DropdownOptions.maritalStatus.map(
                                    (s) => DropdownMenuItem<String?>(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  ),
                                ],
                                onChanged: (val) => setModalState(
                                  () => tempMaritalStatus = val,
                                ),
                              ),
                              _buildFilterDropdown(
                                label: 'Country',
                                hint: 'Any Country',
                                value: tempCountry,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Country'),
                                  ),
                                  ...DropdownOptions.countries.map(
                                    (c) => DropdownMenuItem<String?>(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempCountry = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Ethnicity',
                                hint: 'Any Ethnicity',
                                value: tempEthnicity,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Ethnicity'),
                                  ),
                                  ...DropdownOptions.ethnicities.map(
                                    (e) => DropdownMenuItem<String?>(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempEthnicity = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Nationality',
                                hint: 'Any Nationality',
                                value: tempNationality,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Nationality'),
                                  ),
                                  ...DropdownOptions.nationalities.map(
                                    (n) => DropdownMenuItem<String?>(
                                      value: n,
                                      child: Text(n),
                                    ),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempNationality = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Do you have children?',
                                hint: 'Any',
                                value: tempHasChildren,
                                items: const [
                                  DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: 'true',
                                    child: Text('Yes'),
                                  ),
                                  DropdownMenuItem<String?>(
                                    value: 'false',
                                    child: Text('No'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setModalState(() => tempHasChildren = val),
                              ),
                              _buildFilterDropdown(
                                label: 'Preferred Marital Status',
                                hint: 'Any Preferred Marital Status',
                                value: tempPrefMaritalStatus,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Preferred Marital Status'),
                                  ),
                                  ...DropdownOptions.maritalStatus.map(
                                    (s) => DropdownMenuItem<String?>(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  ),
                                ],
                                onChanged: (val) => setModalState(
                                  () => tempPrefMaritalStatus = val,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Preferred Age Range',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        tempEnablePrefAgeFilter
                                            ? '${tempPrefAgeRange.start.round()} - ${tempPrefAgeRange.end.round()} yrs'
                                            : 'Any',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: tempEnablePrefAgeFilter
                                              ? const Color(0xFFE54B5E)
                                              : Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Switch.adaptive(
                                        value: tempEnablePrefAgeFilter,
                                        activeTrackColor:
                                            const Color(0xFFE54B5E),
                                        onChanged: (enabled) {
                                          setModalState(() {
                                            tempEnablePrefAgeFilter = enabled;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              if (tempEnablePrefAgeFilter)
                                RangeSlider(
                                  values: tempPrefAgeRange,
                                  min: 18,
                                  max: 75,
                                  divisions: 57,
                                  activeColor: const Color(0xFFE54B5E),
                                  inactiveColor: Colors.grey[200],
                                  onChanged: (values) {
                                    setModalState(
                                      () => tempPrefAgeRange = values,
                                    );
                                  },
                                ),
                              const SizedBox(height: 8),
                              _buildFilterDropdown(
                                label: 'Preferred Ethnicity',
                                hint: 'Any Preferred Ethnicity',
                                value: tempPrefEthnicity,
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text('Any Preferred Ethnicity'),
                                  ),
                                  ...DropdownOptions.ethnicities.map(
                                    (e) => DropdownMenuItem<String?>(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  ),
                                ],
                                onChanged: (val) => setModalState(
                                  () => tempPrefEthnicity = val,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(bottomSheetContext).pop();
                            setState(() {
                              _filterAgeRange = tempAgeRange;
                              _filterLastActivity = tempLastActivity;
                              _filterSect = tempSect;
                              _filterMaritalStatus = tempMaritalStatus;
                              _filterCountry = tempCountry;
                              _filterEthnicity = tempEthnicity;
                              _filterNationality = tempNationality;
                              _filterHasChildren = tempHasChildren;
                              _filterPrefMaritalStatus = tempPrefMaritalStatus;
                              _enablePrefAgeFilter = tempEnablePrefAgeFilter;
                              _filterPrefAgeRange = tempPrefAgeRange;
                              _filterPrefEthnicity = tempPrefEthnicity;
                              if (tempLastActivity == 'online') {
                                _selectedFilter = 'online';
                              } else {
                                _selectedFilter = 'all';
                              }
                            });

                            final filters = <String, dynamic>{
                              'ordering': '-last_active',
                            };
                            if (tempAgeRange.start.round() > 18 ||
                                tempAgeRange.end.round() < 70) {
                              filters['min_age'] =
                                  tempAgeRange.start.round().toString();
                              filters['max_age'] =
                                  tempAgeRange.end.round().toString();
                            }
                            if (tempLastActivity == 'online') {
                              filters['online'] = 'true';
                            }
                            if (tempSect != null) {
                              filters['sect'] = ChoiceMappings.displayToKey(
                                tempSect!,
                                ChoiceMappings.sectDisplayToKey,
                              );
                            }
                            if (tempMaritalStatus != null) {
                              filters['marital_status'] =
                                  ChoiceMappings.displayToKey(
                                tempMaritalStatus!,
                                ChoiceMappings.maritalStatusDisplayToKey,
                              );
                            }
                            if (tempCountry != null && tempCountry!.isNotEmpty) {
                              filters['country'] = tempCountry;
                            }
                            if (tempEthnicity != null) {
                              filters['ethnicity'] =
                                  ChoiceMappings.displayToKey(
                                tempEthnicity!,
                                ChoiceMappings.ethnicityDisplayToKey,
                              );
                            }
                            if (tempNationality != null) {
                              filters['nationality'] =
                                  ChoiceMappings.displayToKey(
                                tempNationality!,
                                ChoiceMappings.nationalityDisplayToKey,
                              );
                            }
                            if (tempHasChildren != null) {
                              filters['has_children'] = tempHasChildren;
                            }
                            if (tempPrefMaritalStatus != null) {
                              filters['pref_marital_status'] =
                                  ChoiceMappings.displayToKey(
                                tempPrefMaritalStatus!,
                                ChoiceMappings.maritalStatusDisplayToKey,
                              );
                            }
                            if (tempEnablePrefAgeFilter) {
                              filters['pref_age_min'] =
                                  tempPrefAgeRange.start.round().toString();
                              filters['pref_age_max'] =
                                  tempPrefAgeRange.end.round().toString();
                            }
                            if (tempPrefEthnicity != null) {
                              filters['pref_ethnicity'] =
                                  ChoiceMappings.displayToKey(
                                tempPrefEthnicity!,
                                ChoiceMappings.ethnicityDisplayToKey,
                              );
                            }
                            final Duration? maxAge = tempLastActivity != null
                                ? _lastActivityDurations[tempLastActivity!]
                                : null;
                            _loadProfiles(
                              filters: filters,
                              maxLastActiveAge: maxAge,
                              updateFilterState: true,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE54B5E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
          const SettingsActionButton()
              .animate()
              .fadeIn(duration: 600.ms, delay: 100.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const NotificationBellButton()
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadProfiles(includeConnections: true),
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
                  final trimmed = value.trim();
                  _loadProfiles(
                    filters: trimmed.isNotEmpty ? {'search': trimmed} : null,
                    updateFilterState: true,
                  );
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
                  final isSaved = matchesProvider.wishlists.any(
                    (w) => (w['user_id'] ?? w['id']) == profile.id,
                  );
                  final isConnected =
                      matchesProvider.hasActiveConnectionWith(profile.id);
                  final isRequestSent = !isConnected &&
                      matchesProvider.hasPendingSentRequestTo(profile.id);
                  final canSendRequest = user?.role == 'male';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: MatchCard(
                      username: profile.codename,
                      isVerified: profile.isVerified,
                      age: profile.age != null
                          ? '${profile.age} Years old'
                          : 'N/A',
                      ethnicity: profile.ethnicity ?? 'N/A',
                      country: profile.country ?? 'N/A',
                      imageUrl: null,
                      photos: profile.photos,
                      lockMessage: profile.isProfileLocked && !isConnected
                          ? 'Currently locked in an active Wali discussion'
                          : isConnected
                              ? 'Open profile to view photos safely'
                              : 'Photos will be revealed after mutual interest',
                      isLocked: true,
                      isBlurred: true,
                      isWishlisted: isSaved,
                      isRequestSent: isRequestSent,
                      isConnected: isConnected,
                      onWishlistToggle: () async {
                        if (isSaved) {
                          await matchesProvider.removeFromWishlist(profile.id);
                        } else {
                          await matchesProvider.addToWishlist(profile.id);
                        }
                      },
                      onViewProfile: () {
                        context.push('/matches/directory/${profile.id}').then(
                          (_) {
                            if (mounted) _loadProfiles(includeConnections: true);
                          },
                        );
                      },
                      onSendInterest: canSendRequest
                          ? () {
                              if (profile.isProfileLocked) {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    snackPosition: SnackPosition.TOP,
                                    margin: EdgeInsets.all(16),
                                    borderRadius: 8,
                                    duration: Duration(seconds: 3),
                                    messageText: Text(
                                      'This profile is currently locked in an active Wali discussion.',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                );
                                return;
                              }
                              _handleSendInterest(profile.id);
                            }
                          : null,
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
