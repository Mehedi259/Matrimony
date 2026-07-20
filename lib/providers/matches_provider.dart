import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  String? _errorMessage;

  // Getters
  List<MatchProfileModel> get directoryProfiles => _directoryProfiles;
  List<ConnectionRequestModel> get sentRequests => _sentRequests;
  List<ConnectionRequestModel> get receivedRequests => _receivedRequests;
  List<MatchModel> get matches => _matches;
  List<dynamic> get wishlists => _wishlists;
  List<dynamic> get profileViewers => _profileViewers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // ========== DIRECTORY ==========

  Future<bool> loadDirectory({
    Map<String, dynamic>? filters,
    int page = 1,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _directoryProfiles = await _matchesRepository.getDirectory(
        filters: filters,
        page: page,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> getProfileDetails(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final profileData = await _matchesRepository.getDirectoryProfile(userId);
      
      // API returns {"profile": {...}, "basic_info": {...}}
      // Extract the profile section for the MatchProfileModel
      final profileJson = profileData['profile'] as Map<String, dynamic>? ?? profileData;
      _selectedProfile = MatchProfileModel.fromJson(profileJson);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      _selectedProfile = null;
      notifyListeners();
      return false;
    }
  }

  // ========== CONNECTION REQUESTS ==========

  Future<bool> sendConnectionRequest(String targetUserId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.sendConnectionRequest(targetUserId);
      await loadSentRequests(); // Refresh sent requests
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
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
      if (e is DioException && e.response?.statusCode == 403) {
        // Access restricted for non-male users, handle gracefully
        _sentRequests = [];
        _setLoading(false);
        notifyListeners();
        return true;
      }
      _setError(e.toString());
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
      _setError(e.toString());
      return false;
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
      _setError(e.toString());
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
      _setError(e.toString());
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
      _setError(e.toString());
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
      _setError(e.toString());
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
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> markPhotosViewed(String matchId) async {
    // Silently mark as viewed without loading indicator
    try {
      await _matchesRepository.markPhotosViewed(matchId);
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
    try {
      _profileViewers = await _matchesRepository.getProfileViewers();
      notifyListeners();
      return true;
    } catch (e) {
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
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> removeFromWishlist(String targetUserId) async {
    _clearError();
    final removedItems = _wishlists.where((w) => (w['user_id'] ?? w['id']) == targetUserId).toList();
    _wishlists.removeWhere((w) => (w['user_id'] ?? w['id']) == targetUserId);
    notifyListeners();

    try {
      if (_matchesRepository == null) throw Exception('MatchesRepository not provided');
      await _matchesRepository.removeFromWishlist(targetUserId);
      await loadWishlists(); // Refresh wishlists silently
      return true;
    } catch (e) {
      _wishlists.addAll(removedItems);
      notifyListeners();
      _setError(e.toString());
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
      _setError(e.toString());
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
      _setError(e.toString());
      return null;
    }
  }

  // ========== HELPER METHODS ==========

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
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
