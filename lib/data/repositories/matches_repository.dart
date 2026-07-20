import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/matches/match_profile_model.dart';
import '../models/profile/basic_info_model.dart';

class MatchesRepository {
  final ApiClient _apiClient = ApiClient();

  // ========== DIRECTORY (Browse Profiles) ==========

  Future<List<MatchProfileModel>> getDirectory({
    Map<String, dynamic>? filters,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'page_size': pageSize.toString(),
      if (filters != null) ...filters,
    };

    final response = await _apiClient.get(
      ApiConstants.matchesDirectory,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((profile) => MatchProfileModel.fromJson(profile))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> getDirectoryProfile(String userId) async {
    final response = await _apiClient.get(
      '${ApiConstants.matchesDirectory}$userId/',
    );
    return response.data;
  }

  // ========== CONNECTION REQUESTS ==========

  Future<Map<String, dynamic>> sendConnectionRequest(String targetUserId) async {
    final response = await _apiClient.post(
      ApiConstants.sendRequest,
      data: {'target_user_id': targetUserId},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> resendConnectionRequest(String requestId) async {
    final response = await _apiClient.post(
      ApiConstants.resendRequest,
      data: {'request_id': requestId},
    );
    return response.data;
  }

  Future<List<ConnectionRequestModel>> getSentRequests() async {
    final response = await _apiClient.get(ApiConstants.sentRequests);
    
    if (response.data is List) {
      return (response.data as List)
          .map((req) => ConnectionRequestModel.fromJson(req))
          .toList();
    }
    return [];
  }

  Future<List<ConnectionRequestModel>> getReceivedRequests() async {
    final response = await _apiClient.get(ApiConstants.receivedRequests);
    
    if (response.data is List) {
      return (response.data as List)
          .map((req) => ConnectionRequestModel.fromJson(req))
          .toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> respondToRequest({
    required String requestId,
    required String action, // 'accept' or 'decline'
  }) async {
    final response = await _apiClient.patch(
      '${ApiConstants.respondRequest}$requestId/respond/',
      queryParameters: {'action': action},
    );
    return response.data;
  }

  Future<void> cancelRequest(String requestId) async {
    await _apiClient.delete(
      '${ApiConstants.cancelRequest}$requestId/cancel/',
    );
  }

  // ========== MATCHES ==========

  Future<List<MatchModel>> getMatches({String? status}) async {
    final queryParams = status != null ? {'status': status} : null;
    
    final response = await _apiClient.get(
      ApiConstants.matches,
      queryParameters: queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((match) => MatchModel.fromJson(match))
          .toList();
    }
    return [];
  }

  // ========== MATCHMAKING ==========

  Future<Map<String, dynamic>> createMatchmakingRequest() async {
    final response = await _apiClient.post(
      ApiConstants.myMatchmakingRequest,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getMyMatchmakingRequest() async {
    final response = await _apiClient.get(
      ApiConstants.myMatchmakingRequest,
    );
    return response.data;
  }

  // ========== WISHLISTS (Saved Profiles) ==========

  Future<List<dynamic>> getWishlists() async {
    final response = await _apiClient.get(ApiConstants.wishlists);
    return response.data as List;
  }

  Future<List<dynamic>> getProfileViewers() async {
    final response = await _apiClient.get(ApiConstants.profileViewers);
    if (response.data is List) {
      return response.data as List;
    }
    return [];
  }

  Future<Map<String, dynamic>> addToWishlist(String targetUserId) async {
    final response = await _apiClient.post(
      ApiConstants.wishlists,
      data: {'target_user_id': targetUserId},
    );
    return response.data;
  }

  Future<void> removeFromWishlist(String wishlistId) async {
    await _apiClient.delete('${ApiConstants.wishlists}$wishlistId/');
  }
}
