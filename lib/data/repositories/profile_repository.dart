import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/storage_service.dart';
import '../models/profile/basic_info_model.dart';

class ProfileRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  // ========== BASIC INFO ==========

  /// Get basic info based on user role
  Future<BasicInfoModel> getBasicInfo() async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.maleBasicInfo;
        break;
      case 'female':
        endpoint = ApiConstants.femaleBasicInfo;
        break;
      case 'wali':
        endpoint = ApiConstants.waliBasicInfo;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.get(endpoint);
    return BasicInfoModel.fromJson(response.data);
  }

  /// Update basic info based on user role
  Future<BasicInfoModel> updateBasicInfo(Map<String, dynamic> data) async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.maleBasicInfo;
        break;
      case 'female':
        endpoint = ApiConstants.femaleBasicInfo;
        break;
      case 'wali':
        endpoint = ApiConstants.waliBasicInfo;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.patch(endpoint, data: data);
    return BasicInfoModel.fromJson(response.data);
  }

  // ========== PHOTOS ==========

  /// Get all photos
  Future<List<PhotoModel>> getPhotos() async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.malePhotos;
        break;
      case 'female':
        endpoint = ApiConstants.femalePhotos;
        break;
      case 'wali':
        endpoint = ApiConstants.waliPhotos;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.get(endpoint);
    return (response.data as List)
        .map((photo) => PhotoModel.fromJson(photo))
        .toList();
  }

  /// Upload a photo
  Future<PhotoModel> uploadPhoto({
    required String imagePath,
    bool isPrimary = false,
  }) async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.malePhotos;
        break;
      case 'female':
        endpoint = ApiConstants.femalePhotos;
        break;
      case 'wali':
        endpoint = ApiConstants.waliPhotos;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.uploadFile(
      endpoint,
      filePath: imagePath,
      fieldName: 'image',
      additionalData: {
        'is_primary': isPrimary.toString(),
      },
    );

    return PhotoModel.fromJson(response.data);
  }

  /// Delete a photo
  Future<void> deletePhoto(String photoId) async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = '${ApiConstants.malePhotos}$photoId/';
        break;
      case 'female':
        endpoint = '${ApiConstants.femalePhotos}$photoId/';
        break;
      case 'wali':
        endpoint = '${ApiConstants.waliPhotos}$photoId/';
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    await _apiClient.delete(endpoint);
  }

  /// Set photo as primary
  Future<PhotoModel> setPrimaryPhoto(String photoId) async {
    final role = _storageService.getUserRole();
    if (role == null) {
      throw Exception('User role not found');
    }

    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = '${ApiConstants.malePhotos}$photoId/';
        break;
      case 'female':
        endpoint = '${ApiConstants.femalePhotos}$photoId/';
        break;
      case 'wali':
        endpoint = '${ApiConstants.waliPhotos}$photoId/';
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.patch(
      endpoint,
      data: {'is_primary': true},
    );

    return PhotoModel.fromJson(response.data);
  }

  // ========== HELPER METHODS ==========

  /// Check if profile is complete (>= 80%)
  Future<bool> isProfileComplete() async {
    try {
      final basicInfo = await getBasicInfo();
      return basicInfo.completionPercentage >= 80;
    } catch (e) {
      return false;
    }
  }

  /// Get profile completion percentage
  Future<int> getProfileCompletionPercentage() async {
    try {
      final basicInfo = await getBasicInfo();
      return basicInfo.completionPercentage;
    } catch (e) {
      return 0;
    }
  }
}
