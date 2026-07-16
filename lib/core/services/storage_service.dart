import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;

  StorageService._internal();

  // SharedPreferences for non-sensitive data
  static SharedPreferences? _prefs;
  
  // FlutterSecureStorage for sensitive data (tokens)
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyCsrfToken = 'csrf_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserRole = 'user_role';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyProfileCompleted = 'profile_completed';

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // ========== TOKEN MANAGEMENT (Secure Storage) ==========

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  Future<void> saveCsrfToken(String token) async {
    await _secureStorage.write(key: _keyCsrfToken, value: token);
  }

  Future<String?> getCsrfToken() async {
    return await _secureStorage.read(key: _keyCsrfToken);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _secureStorage.delete(key: _keyCsrfToken);
  }

  // ========== USER DATA (SharedPreferences) ==========

  Future<void> saveUserId(String userId) async {
    await prefs.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return prefs.getString(_keyUserId);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await prefs.setString(_keyUserData, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final data = prefs.getString(_keyUserData);
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveUserRole(String role) async {
    await prefs.setString(_keyUserRole, role);
  }

  String? getUserRole() {
    return prefs.getString(_keyUserRole);
  }

  // ========== AUTH STATE ==========

  Future<void> setLoggedIn(bool value) async {
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // ========== ONBOARDING & PROFILE ==========

  Future<void> setOnboardingCompleted(bool value) async {
    await prefs.setBool(_keyOnboardingCompleted, value);
  }

  bool isOnboardingCompleted() {
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setProfileCompleted(bool value) async {
    await prefs.setBool(_keyProfileCompleted, value);
  }

  bool isProfileCompleted() {
    return prefs.getBool(_keyProfileCompleted) ?? false;
  }

  // ========== CLEAR ALL DATA ==========

  Future<void> clearAll() async {
    await clearTokens();
    await prefs.clear();
  }

  // ========== GENERIC METHODS ==========

  Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  Future<void> setInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return prefs.getInt(key);
  }

  Future<void> remove(String key) async {
    await prefs.remove(key);
  }
}
