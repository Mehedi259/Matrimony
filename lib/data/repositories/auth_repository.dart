import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../../core/services/storage_service.dart';
import '../models/auth/register_response.dart';
import '../models/auth/login_response.dart';
import '../models/auth/password_reset_response.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();
  final StorageService _storageService = StorageService();

  // ========== REGISTRATION ==========

  /// Step 1: Initiate registration - sends OTP to email
  Future<RegisterInitiateResponse> registerInitiate({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String role, // 'male', 'female', 'wali'
  }) async {
    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.maleRegisterInitiate;
        break;
      case 'female':
        endpoint = ApiConstants.femaleRegisterInitiate;
        break;
      case 'wali':
        endpoint = ApiConstants.waliRegisterInitiate;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.post(
      endpoint,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    return RegisterInitiateResponse.fromJson(response.data);
  }

  /// Step 2: Verify OTP and complete registration
  Future<LoginResponse> registerVerify({
    required String email,
    required String otp,
    required String role, // 'male', 'female', 'wali'
  }) async {
    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.maleRegisterVerify;
        break;
      case 'female':
        endpoint = ApiConstants.femaleRegisterVerify;
        break;
      case 'wali':
        endpoint = ApiConstants.waliRegisterVerify;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.post(
      endpoint,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    final loginResponse = LoginResponse.fromJson(response.data);

    // Save tokens and user data
    await _saveAuthData(loginResponse);

    return loginResponse;
  }

  /// Resend OTP during registration
  Future<RegisterInitiateResponse> resendOtp({
    required String email,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.resendOtp,
      data: {'email': email},
    );

    return RegisterInitiateResponse.fromJson(response.data);
  }

  // ========== LOGIN ==========

  Future<LoginResponse> login({
    required String email,
    required String password,
    required String role, // 'male', 'female', 'wali'
  }) async {
    String endpoint;
    switch (role.toLowerCase()) {
      case 'male':
        endpoint = ApiConstants.maleLogin;
        break;
      case 'female':
        endpoint = ApiConstants.femaleLogin;
        break;
      case 'wali':
        endpoint = ApiConstants.waliLogin;
        break;
      default:
        throw Exception('Invalid role: $role');
    }

    final response = await _apiClient.post(
      endpoint,
      data: {
        'email': email,
        'password': password,
      },
    );

    final loginResponse = LoginResponse.fromJson(response.data);

    // Save tokens and user data
    await _saveAuthData(loginResponse);

    return loginResponse;
  }

  // ========== LOGOUT ==========

  Future<void> logout() async {
    try {
      // Call logout endpoint to invalidate token on server
      await _apiClient.post(ApiConstants.logout);
    } catch (e) {
      // Continue with local logout even if server call fails
    } finally {
      // Clear all local data
      await _storageService.clearAll();
    }
  }

  // ========== PASSWORD RESET ==========

  /// Step 1: Initiate password reset - sends OTP to email
  Future<PasswordResetInitiateResponse> passwordResetInitiate({
    required String email,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.passwordResetInitiate,
      data: {'email': email},
    );

    return PasswordResetInitiateResponse.fromJson(response.data);
  }

  /// Step 2: Verify OTP and get reset token
  Future<PasswordResetVerifyResponse> passwordResetVerify({
    required String email,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.passwordResetVerify,
      data: {
        'email': email,
        'otp': otp,
      },
    );

    return PasswordResetVerifyResponse.fromJson(response.data);
  }

  /// Step 3: Set new password using reset token
  Future<PasswordResetConfirmResponse> passwordResetConfirm({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.passwordResetConfirm,
      data: {
        'reset_token': resetToken,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    return PasswordResetConfirmResponse.fromJson(response.data);
  }

  // ========== PASSWORD CHANGE ==========

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.changePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    return response.data;
  }

  // ========== PROFILE OPERATIONS ==========

  Future<UserModel> getProfile() async {
    final response = await _apiClient.get(ApiConstants.profile);
    final user = UserModel.fromJson(response.data);
    
    // Update stored user data
    await _storageService.saveUserData(response.data);
    
    return user;
  }

  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;

    final response = await _apiClient.patch(
      ApiConstants.profile,
      data: data,
    );

    final user = UserModel.fromJson(response.data);
    
    // Update stored user data
    await _storageService.saveUserData(response.data);
    
    return user;
  }

  Future<UserModel> updateProfilePicture({
    required String imagePath,
  }) async {
    final response = await _apiClient.uploadFile(
      ApiConstants.profilePicture,
      filePath: imagePath,
      fieldName: 'profile_picture',
    );

    final user = UserModel.fromJson(response.data);
    
    // Update stored user data
    await _storageService.saveUserData(response.data);
    
    return user;
  }

  Future<Map<String, dynamic>> deactivateAccount() async {
    final response = await _apiClient.post(ApiConstants.deactivate);
    
    // Clear local data after deactivation
    await _storageService.clearAll();
    
    return response.data;
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await _apiClient.delete(ApiConstants.profile);
    
    // Clear all local data after deletion
    await _storageService.clearAll();
    
    return response.data;
  }

  Future<Map<String, dynamic>> submitWhyLeaving({
    required String reason,
    String? feedback,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.whyLeaving,
      data: {
        'reason': reason,
        if (feedback != null) 'feedback': feedback,
      },
    );

    return response.data;
  }

  // ========== HELPER METHODS ==========

  /// Save authentication data locally
  Future<void> _saveAuthData(LoginResponse loginResponse) async {
    await _storageService.saveTokens(
      accessToken: loginResponse.accessToken,
      refreshToken: loginResponse.refreshToken,
    );
    await _storageService.saveUserId(loginResponse.user.id);
    await _storageService.saveUserRole(loginResponse.user.role);
    await _storageService.saveUserData(loginResponse.user.toJson());
    await _storageService.setLoggedIn(true);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Get stored user data
  Future<UserModel?> getStoredUser() async {
    final userData = _storageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  /// Get user role
  String? getUserRole() {
    return _storageService.getUserRole();
  }
}
