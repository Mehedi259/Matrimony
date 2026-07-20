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

  // ========== WISHLISTS ==========

  Future<bool> loadWishlists() async {
    _setLoading(true);
    _clearError();

    try {
      _wishlists = await _matchesRepository.getWishlists();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> loadProfileViewers() async {
    _setLoading(true);
    _clearError();

    try {
      _profileViewers = await _matchesRepository.getProfileViewers();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> addToWishlist(String targetUserId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.addToWishlist(targetUserId);
      await loadWishlists(); // Refresh wishlists
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> removeFromWishlist(String wishlistId) async {
    _setLoading(true);
    _clearError();

    try {
      await _matchesRepository.removeFromWishlist(wishlistId);
      await loadWishlists(); // Refresh wishlists
      _setLoading(false);
      return true;
    } catch (e) {
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
