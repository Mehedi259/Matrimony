import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../data/repositories/matches_repository.dart';
import '../data/models/matches/match_profile_model.dart';

class MatchesProvider extends ChangeNotifier {
  final MatchesRepository _matchesRepository = MatchesRepository();

  List<MatchProfileModel> _directoryProfiles = [];
  List<ConnectionRequestModel> _sentRequests = [];
  List<ConnectionRequestModel> _receivedRequests = [];
  List<MatchModel> _matches = [];
  List<dynamic> _wishlists = [];
  List<dynamic> _profileViewers = [];

  bool _isLoading = false;
  bool _isLoadingProfileViewers = false;
  String? _errorMessage;
  String? _selectedProfileError;
  String? _profileViewersError;
  Map<String, dynamic>? _connectionUsage;
  bool _justExhaustedRequests = false;
  bool _lastSendFailedDueToLimit = false;

  // Getters
  List<MatchProfileModel> get directoryProfiles => _directoryProfiles;
  List<ConnectionRequestModel> get sentRequests => _sentRequests;
  List<ConnectionRequestModel> get receivedRequests => _receivedRequests;
  List<MatchModel> get matches => _matches;
  List<dynamic> get wishlists => _wishlists;
  List<dynamic> get profileViewers => _profileViewers;
  bool get isLoading => _isLoading;
  bool get isLoadingProfileViewers => _isLoadingProfileViewers;
  String? get errorMessage => _errorMessage;
  String? get selectedProfileError => _selectedProfileError;
  String? get profileViewersError => _profileViewersError;
  Map<String, dynamic>? get connectionUsage => _connectionUsage;
  bool get justExhaustedRequests => _justExhaustedRequests;
  bool get lastSendFailedDueToLimit => _lastSendFailedDueToLimit;

  int? get requestsRemaining =>
      (_connectionUsage?['requests_remaining'] as num?)?.toInt();

  String? get usageSubscriptionPlan =>
      _connectionUsage?['subscription_plan']?.toString();

  bool get hasExhaustedRequests {
    final plan = usageSubscriptionPlan;
    final remaining = requestsRemaining;
    return remaining != null &&
        remaining <= 0 &&
        (plan == 'free' || plan == 'monthly');
  }

  /// Whether either user is currently locked into an approved Wali discussion.
  bool get isCurrentUserProfileLocked =>
      _matches.any((m) => m.isDiscussionLocked);

  MatchModel? get lockedDiscussionMatch =>
      _matches.where((m) => m.isDiscussionLocked).firstOrNull;

  // Selected profile for viewing details
  MatchProfileModel? _selectedProfile;
  MatchProfileModel? get selectedProfile => _selectedProfile;

  // ========== CLEAR DATA ==========

  void clearData() {
    _directoryProfiles = [];
    _sentRequests = [];
    _receivedRequests = [];
    _matches = [];
    _wishlists = [];
    _profileViewers = [];
    _selectedProfile = null;
    _connectionUsage = null;
    _justExhaustedRequests = false;
    _lastSendFailedDueToLimit = false;
    _errorMessage = null;
    _selectedProfileError = null;
    _profileViewersError = null;
    _isLoading = false;
    _isLoadingProfileViewers = false;
    notifyListeners();
  }

  // ========== DIRECTORY ==========

  Future<bool> loadDirectory({
    Map<String, dynamic>? filters,
    int page = 1,
    Duration? maxLastActiveAge,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      var profiles = await _matchesRepository.getDirectory(
        filters: filters,
        page: page,
      );
      if (maxLastActiveAge != null) {
        final cutoff = DateTime.now().toUtc().subtract(maxLastActiveAge);
        profiles = profiles.where((profile) {
          final lastActive = profile.lastActive?.toUtc();
          return lastActive != null && !lastActive.isBefore(cutoff);
        }).toList();
      }
      _directoryProfiles = profiles;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  /// Returns the active match for [userId], if one exists.
  MatchModel? activeMatchForUser(String userId) {
    return _matches
        .where((m) => m.matchedUserId == userId && m.isActiveConnection)
        .firstOrNull;
  }

  /// Whether there is an active/approved match with [userId].
  bool hasActiveConnectionWith(String userId) {
    return activeMatchForUser(userId) != null;
  }

  /// Whether a pending connection request has already been sent to [userId].
  bool hasPendingSentRequestTo(String userId) {
    return _sentRequests.any((req) => req.receiverId == userId);
  }

  /// Whether a pending connection request was received from [userId].
  bool hasPendingReceivedRequestFrom(String userId) {
    return _receivedRequests.any((req) => req.otherUser['id'] == userId);
  }

  static String? _joinListField(dynamic value) {
    if (value == null) return null;
    if (value is List) {
      final parts = value
          .map((e) => e?.toString().trim() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
      return parts.isEmpty ? null : parts.join(', ');
    }
    return value.toString();
  }

  /// Merges the nested `{"profile": ..., "basic_info": ...}` API payload into
  /// a [MatchProfileModel] without relying on raw string casts.
  static MatchProfileModel parseDirectoryProfileDetail(
    Map<String, dynamic> profileData,
  ) {
    final profileSection = profileData['profile'];
    final profileJson = Map<String, dynamic>.from(
      profileSection is Map ? profileSection : profileData,
    );

    final basicInfoRaw = profileData['basic_info'];
    if (basicInfoRaw is Map) {
      final basicInfo = Map<String, dynamic>.from(basicInfoRaw);
      profileJson['photos'] = basicInfo['photos'];
      profileJson['ethnicity'] = _joinListField(basicInfo['ethnicity']);
      profileJson['ethnicity_list'] = basicInfo['ethnicity'];
      profileJson['education'] = basicInfo['education'];
      profileJson['occupation'] = basicInfo['employment'];
      profileJson['bio'] = basicInfo['about_yourself'] ?? basicInfo['about'];
      profileJson['languages'] = _joinListField(basicInfo['languages_spoken']);
      profileJson['languages_list'] = basicInfo['languages_spoken'];
      profileJson['about'] = basicInfo['about'];
      profileJson['about_yourself'] = basicInfo['about_yourself'];
      profileJson['envision_marriage'] = basicInfo['envision_marriage'];
      profileJson['relationship_with_islam'] =
          basicInfo['relationship_with_islam'];
      profileJson['role_as_spouse'] = basicInfo['role_as_spouse'];
      profileJson['envision_spouse'] = basicInfo['envision_spouse'];
      profileJson['spouse_religious_status_pref'] =
          basicInfo['spouse_religious_status_pref'];
      profileJson['open_to_relocate_details'] =
          basicInfo['open_to_relocate_details'];
      profileJson['other_preferences'] = basicInfo['other_preferences'];
      profileJson['pref_age_min'] = basicInfo['pref_age_min'];
      profileJson['pref_age_max'] = basicInfo['pref_age_max'];
      profileJson['pref_marital_status'] = basicInfo['pref_marital_status'];
      profileJson['pref_ethnicity'] = basicInfo['pref_ethnicity'];
      profileJson['pref_country_of_residence'] =
          basicInfo['pref_country_of_residence'];
      profileJson['preferred_dress'] = basicInfo['preferred_dress'];
      profileJson['dress'] = basicInfo['dress'];
      profileJson['nationality'] = _joinListField(basicInfo['nationality']);
      profileJson['pray_5x'] = basicInfo['pray_5x'];
      profileJson['open_to_relocate'] = basicInfo['open_to_relocate'];

      profileJson['height'] ??= basicInfo['height'];
    }

    return MatchProfileModel.fromJson(profileJson);
  }

  Future<bool> getProfileDetails(String userId) async {
    _setLoading(true);
    _clearError();
    _selectedProfileError = null;

    try {
      final profileData = await _matchesRepository.getDirectoryProfile(userId);
      _selectedProfile = parseDirectoryProfileDetail(profileData);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _handleError(e);
      _selectedProfileError = _errorMessage;
      _selectedProfile = null;
      notifyListeners();
      return false;
    }
  }

  // ========== CONNECTION REQUESTS ==========

  Future<Map<String, dynamic>?> fetchConnectionUsage() async {
    try {
      _connectionUsage = await _matchesRepository.getConnectionUsage();
      notifyListeners();
      return _connectionUsage;
    } catch (_) {
      return _connectionUsage;
    }
  }

  Future<bool> sendConnectionRequest(String targetUserId) async {
    _justExhaustedRequests = false;
    _lastSendFailedDueToLimit = false;
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.sendConnectionRequest(targetUserId);
      await Future.wait([
        loadSentRequests(),
        fetchConnectionUsage(),
      ]);
      if (hasExhaustedRequests) {
        _justExhaustedRequests = true;
      }
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _handleError(e);
      final msg = (_errorMessage ?? '').toLowerCase();
      if (msg.contains('limit') ||
          msg.contains('free users can send') ||
          msg.contains('monthly')) {
        _lastSendFailedDueToLimit = true;
        await fetchConnectionUsage();
        notifyListeners();
      }
      return false;
    }
  }

  Future<bool> loadSentRequests() async {
    _setLoading(true);
    _clearError();

    try {
      _sentRequests = await _matchesRepository.getSentRequests();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      if ((e is ApiException && e.statusCode == 403) ||
          (e is DioException && e.response?.statusCode == 403)) {
        // Access restricted for non-male users, handle gracefully
        _sentRequests = [];
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _handleError(e);
      return false;
    }
  }

  Future<bool> loadReceivedRequests() async {
    _setLoading(true);
    _clearError();

    try {
      _receivedRequests = await _matchesRepository.getReceivedRequests();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      if ((e is ApiException && e.statusCode == 403) ||
          (e is DioException && e.response?.statusCode == 403)) {
        // Access restricted for male users, handle gracefully
        _receivedRequests = [];
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _handleError(e);
      return false;
    }
  }

  /// Loads only the connection request list applicable to [role] to avoid
  /// role-restricted 403 responses from the backend.
  Future<void> loadConnectionRequestsForRole(String? role) async {
    final normalized = role?.toLowerCase().trim();
    if (normalized == 'male') {
      _receivedRequests = [];
      await loadSentRequests();
    } else if (normalized == 'female' || normalized == 'wali') {
      _sentRequests = [];
      await loadReceivedRequests();
    } else {
      await Future.wait([
        loadSentRequests(),
        loadReceivedRequests(),
      ]);
    }
  }

  Future<bool> respondToRequest({
    required String requestId,
    required bool accept,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.respondToRequest(
        requestId: requestId,
        action: accept ? 'accept' : 'decline',
      );
      await loadReceivedRequests(); // Refresh received requests
      if (accept) {
        await loadMatches(); // Refresh matches if accepted
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> cancelRequest(String requestId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.cancelRequest(requestId);
      await loadSentRequests(); // Refresh sent requests
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // ========== MATCHES ==========

  Future<bool> loadMatches({String? status}) async {
    _setLoading(true);
    _clearError();

    try {
      _matches = await _matchesRepository.getMatches(status: status);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> cancelMatch(String matchId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.cancelMatch(matchId);
      await loadMatches(); // Refresh matches to get updated status
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // ========== WALI & LOCK LIFECYCLE ==========

  Future<bool> requestWaliDetails(String matchId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.requestWaliDetails(matchId);
      await loadMatches();
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> respondToWaliRequest({
    required String matchId,
    required bool accept,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.respondToWaliRequest(
        matchId: matchId,
        action: accept ? 'accept' : 'decline',
      );
      await loadMatches();
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> unlockMatch(String matchId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.unlockMatch(matchId);
      await loadMatches();
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  // ========== MATCH PHOTOS ==========

  Future<bool> requestPhotoView(String matchId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.requestPhotoView(matchId);
      await loadMatches(); // Refresh matches to get updated status
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> respondToPhotoRequest({
    required String matchId,
    required bool accept,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.respondToPhotoRequest(
        matchId: matchId,
        action: accept ? 'approve' : 'decline',
      );
      await loadMatches(); // Refresh matches to get updated status
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<bool> markPhotosViewed(String matchId) async {
    // Silently mark as viewed without loading indicator
    try {
      await _matchesRepository.markPhotosViewed(matchId);
      
      // Update local state
      final index = _matches.indexWhere((m) => m.id == matchId);
      if (index != -1) {
        _matches[index] = _matches[index].copyWith(
          photosCurrentlyVisible: false,
          photoRequestStatus: 'none',
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      debugPrint('Failed to mark photos viewed: $e');
      return false;
    }
  }

  // ========== WISHLISTS ==========

  Future<bool> loadWishlists() async {
    try {
      _wishlists = await _matchesRepository.getWishlists();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> loadProfileViewers() async {
    _isLoadingProfileViewers = true;
    _profileViewersError = null;
    notifyListeners();

    try {
      _profileViewers = await _matchesRepository.getProfileViewers();
      _isLoadingProfileViewers = false;
      notifyListeners();
      return true;
    } catch (e) {
      _profileViewers = [];
      _isLoadingProfileViewers = false;
      if (e is ApiException) {
        _profileViewersError = e.message.trim().isNotEmpty
            ? e.message
            : 'Failed to load profile views';
      } else if (e is DioException && e.response?.data is Map) {
        final data = e.response!.data as Map;
        _profileViewersError = (data['error'] ??
                data['detail'] ??
                data['message'] ??
                'Failed to load profile views')
            .toString();
      } else {
        _profileViewersError = 'Failed to load profile views';
      }
      notifyListeners();
      return false;
    }
  }

  Future<bool> addToWishlist(String targetUserId) async {
    _clearError();
    final fakeWishlist = {'user_id': targetUserId, 'id': targetUserId};
    _wishlists.add(fakeWishlist);
    notifyListeners();

    try {
      await _matchesRepository.addToWishlist(targetUserId);
      await loadWishlists(); // Refresh wishlists silently
      return true;
    } catch (e) {
      _wishlists.remove(fakeWishlist);
      notifyListeners();
      _handleError(e);
      return false;
    }
  }

  Future<bool> removeFromWishlist(String targetUserId) async {
    _clearError();
    final removedItems = _wishlists.where((w) => (w['user_id'] ?? w['id']) == targetUserId).toList();
    _wishlists.removeWhere((w) => (w['user_id'] ?? w['id']) == targetUserId);
    notifyListeners();

    try {
      await _matchesRepository.removeFromWishlist(targetUserId);
      await loadWishlists(); // Refresh wishlists silently
      return true;
    } catch (e) {
      _wishlists.addAll(removedItems);
      notifyListeners();
      _handleError(e);
      return false;
    }
  }

  // ========== MATCHMAKING ==========

  Future<bool> createMatchmakingRequest() async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.createMatchmakingRequest();
      _setLoading(false);
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getMyMatchmakingRequest() async {
    _setLoading(true);
    _clearError();

    try {
      final request = await _matchesRepository.getMyMatchmakingRequest();
      _setLoading(false);
      return request;
    } catch (e) {
      _handleError(e);
      return null;
    }
  }

  // ========== HELPER METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _handleError(dynamic e) {
    if (e is ApiException) {
      _errorMessage = e.message;
    } else if (e is DioException && e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map) {
        if (data.containsKey('error')) {
          _errorMessage = data['error'].toString();
        } else if (data.containsKey('detail')) {
          _errorMessage = data['detail'].toString();
        } else if (data.containsKey('message')) {
          _errorMessage = data['message'].toString();
        } else {
          _errorMessage = e.message ?? e.toString();
        }
      } else {
        _errorMessage = e.message ?? e.toString();
      }
    } else {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
