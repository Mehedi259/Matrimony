import 'package:flutter/foundation.dart';
import '../data/models/profile/basic_info_model.dart';
import '../data/models/profile/wali_profile_model.dart';
import '../data/repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository = ProfileRepository();

  BasicInfoModel? _basicInfo;
  WaliProfileModel? _waliProfile;
  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  String? _errorMessage;

  BasicInfoModel? get basicInfo => _basicInfo;
  WaliProfileModel? get waliProfile => _waliProfile;
  List<PhotoModel> get photos => _photos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get profileCompletionPercentage {
    return _basicInfo?.completionPercentage ?? 0;
  }

  bool get isProfileComplete {
    return profileCompletionPercentage >= 80;
  }

  // ========== CLEAR DATA ==========

  void clearData() {
    _basicInfo = null;
    _waliProfile = null;
    _photos = [];
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ========== BASIC INFO ==========

  Future<bool> loadBasicInfo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _basicInfo = await _profileRepository.getBasicInfo();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateBasicInfo(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _basicInfo = await _profileRepository.updateBasicInfo(data);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========== PHOTOS ==========

  Future<bool> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _photos = await _profileRepository.getPhotos();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadPhoto(String imagePath, {bool isPrimary = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final photo = await _profileRepository.uploadPhoto(
        imagePath: imagePath,
        isPrimary: isPrimary,
      );
      _photos.add(photo);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePhoto(String photoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _profileRepository.deletePhoto(photoId);
      _photos.removeWhere((photo) => photo.id == photoId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setPrimaryPhoto(String photoId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedPhoto = await _profileRepository.setPrimaryPhoto(photoId);
      
      // Update all photos - set others to non-primary
      _photos = _photos.map((photo) {
        if (photo.id == photoId) {
          return updatedPhoto;
        } else {
          return PhotoModel(
            id: photo.id,
            imageUrl: photo.imageUrl,
            isPrimary: false,
            uploadedAt: photo.uploadedAt,
          );
        }
      }).toList();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loadWaliProfile() async {
    try {
      _waliProfile = await _profileRepository.getWaliProfile();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateWaliProfile(Map<String, dynamic> data) async {
    _errorMessage = null;
    try {
      _waliProfile = await _profileRepository.updateWaliProfile(data);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
