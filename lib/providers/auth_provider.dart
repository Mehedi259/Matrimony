import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';
import '../data/models/user_model.dart';
import '../data/models/auth/register_response.dart';
import '../data/models/auth/login_response.dart';
import '../data/models/auth/password_reset_response.dart';
import '../core/services/storage_service.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final StorageService _storageService = StorageService();

  AuthState _authState = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get authState => _authState;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  // Registration flow
  String? _pendingEmail;
  String? _pendingRole;

  String? get pendingEmail => _pendingEmail;
  String? get pendingRole => _pendingRole;

  // Password reset flow
  String? _resetEmail;
  String? _resetToken;

  String? get resetEmail => _resetEmail;
  String? get resetToken => _resetToken;

  // ========== INITIALIZATION ==========

  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // Check if user is already logged in
      final isLoggedIn = await _authRepository.isLoggedIn();
      
      if (isLoggedIn) {
        // Try to get stored user data
        final storedUser = await _authRepository.getStoredUser();
        
        if (storedUser != null) {
          _currentUser = storedUser;
          _authState = AuthState.authenticated;
        } else {
          // Token exists but no user data, fetch from server
          try {
            _currentUser = await _authRepository.getProfile();
            _authState = AuthState.authenticated;
          } catch (e) {
            // Failed to fetch user, logout
            await logout();
            _authState = AuthState.unauthenticated;
          }
        }
      } else {
        _authState = AuthState.unauthenticated;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _authState = AuthState.error;
    } finally {
      _setLoading(false);
    }
  }

  // ========== REGISTRATION ==========

  Future<bool> registerInitiate({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.registerInitiate(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
      );

      // Store email and role for OTP verification step
      _pendingEmail = email;
      _pendingRole = role;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> registerVerify({
    required String email,
    required String otp,
    required String role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.registerVerify(
        email: email,
        otp: otp,
        role: role,
      );

      _currentUser = response.user;
      _authState = AuthState.authenticated;

      // Clear pending data
      _pendingEmail = null;
      _pendingRole = null;

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> resendOtp({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.resendOtp(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ========== LOGIN ==========

  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.login(
        email: email,
        password: password,
        role: role,
      );

      _currentUser = response.user;
      _authState = AuthState.authenticated;

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ========== LOGOUT ==========

  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authRepository.logout();
    } catch (e) {
      // Continue with local logout even if server call fails
    } finally {
      _currentUser = null;
      _authState = AuthState.unauthenticated;
      _pendingEmail = null;
      _pendingRole = null;
      _resetEmail = null;
      _resetToken = null;
      _setLoading(false);
      notifyListeners();
    }
  }

  // ========== PASSWORD RESET ==========

  Future<bool> passwordResetInitiate({required String email}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.passwordResetInitiate(email: email);
      _resetEmail = email;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> passwordResetVerify({
    required String email,
    required String otp,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authRepository.passwordResetVerify(
        email: email,
        otp: otp,
      );
      _resetToken = response.resetToken;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> passwordResetConfirm({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.passwordResetConfirm(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      // Clear reset data
      _resetEmail = null;
      _resetToken = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ========== PASSWORD CHANGE ==========

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // ========== PROFILE OPERATIONS ==========

  Future<bool> refreshProfile() async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authRepository.getProfile();
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authRepository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> updateProfilePicture({required String imagePath}) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authRepository.updateProfilePicture(
        imagePath: imagePath,
      );
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deactivateAccount() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.deactivateAccount();
      
      // Clear local state
      _currentUser = null;
      _authState = AuthState.unauthenticated;
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.deleteAccount();
      
      // Clear local state
      _currentUser = null;
      _authState = AuthState.unauthenticated;
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> submitWhyLeaving({
    required String reason,
    String? feedback,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.submitWhyLeaving(
        reason: reason,
        feedback: feedback,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
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
    _authState = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  // Get user role helper
  String? getUserRole() {
    return _currentUser?.role ?? _authRepository.getUserRole();
  }

  // Check if profile is complete
  bool isProfileComplete() {
    return _storageService.isProfileCompleted();
  }

  // Set profile completion status
  Future<void> setProfileComplete(bool value) async {
    await _storageService.setProfileCompleted(value);
    notifyListeners();
  }
}
