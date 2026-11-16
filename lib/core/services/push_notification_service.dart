import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../firebase_options.dart';
import '../constants/api_constants.dart';
import '../network/api_client.dart';
import 'notification_router.dart';

/// System push notifications (Firebase Cloud Messaging).
///
/// Lifecycle:
///   * [initialize] once at startup (Firebase + tap handlers).
///   * [onLoggedIn] after login / on launch with a session: asks permission,
///     registers this phone's token with the backend, keeps it fresh.
///   * [onLoggingOut] before the session is cleared: unregisters the token so
///     this phone stops receiving the previous user's notifications.
///   * [attachRouter] once the GoRouter exists, so taps can navigate.
class PushNotificationService {
  PushNotificationService._();

  static bool _available = false;
  static GoRouter? _router;
  static RemoteMessage? _pendingTap;
  static String? _registeredToken;
  static StreamSubscription<String>? _tokenRefreshSub;

  /// Called for pushes received while the app is open (e.g. refresh lists).
  static VoidCallback? onForegroundMessage;

  static Future<void> initialize() async {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options == null) return;
    try {
      await Firebase.initializeApp(options: options);
      _available = true;
    } catch (e) {
      debugPrint('Push: Firebase init failed: $e');
      return;
    }

    final messaging = FirebaseMessaging.instance;
    // iOS: show the banner even while the app is in the foreground.
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((_) => onForegroundMessage?.call());
    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);

    // App launched from a terminated state by tapping a notification.
    final initial = await messaging.getInitialMessage();
    if (initial != null) _handleTap(initial);
  }

  static void attachRouter(GoRouter router) {
    _router = router;
    final pending = _pendingTap;
    if (pending != null) {
      _pendingTap = null;
      // Let the first frame (and the auth redirect) settle first.
      Future.delayed(const Duration(milliseconds: 500), () => _handleTap(pending));
    }
  }

  static void _handleTap(RemoteMessage message) {
    final router = _router;
    if (router == null) {
      _pendingTap = message;
      return;
    }
    final data = Map<String, dynamic>.from(message.data);
    final type = (data['notification_type'] ?? '').toString();
    final notificationId = data['notification_id']?.toString();
    if (notificationId != null && notificationId.isNotEmpty) {
      unawaited(_markRead(notificationId));
    }
    NotificationRouter.open(router, type, data);
  }

  static Future<void> _markRead(String notificationId) async {
    try {
      await ApiClient()
          .post('${ApiConstants.notifications}$notificationId/mark-read/');
    } catch (_) {
      // Not critical; the list marks it read when opened.
    }
  }

  static Future<void> onLoggedIn() async {
    if (!_available) return;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      if (Platform.isIOS) {
        // The FCM token needs the APNs token; it can take a moment.
        for (var i = 0; i < 10 && await messaging.getAPNSToken() == null; i++) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      final token = await messaging.getToken();
      if (token != null) await _register(token);

      _tokenRefreshSub ??= messaging.onTokenRefresh.listen(_register);
    } catch (e) {
      debugPrint('Push: registration failed: $e');
    }
  }

  static Future<void> _register(String token) async {
    await ApiClient().post(
      ApiConstants.notificationDevices,
      data: {
        'token': token,
        'platform': Platform.isIOS ? 'ios' : 'android',
      },
    );
    _registeredToken = token;
  }

  /// Must run while the user's access token is still valid.
  static Future<void> onLoggingOut() async {
    if (!_available) return;
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    try {
      final token = _registeredToken ?? await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await ApiClient().delete(
          ApiConstants.notificationDevices,
          data: {'token': token},
        );
      }
    } catch (e) {
      debugPrint('Push: unregister failed: $e');
    }
    _registeredToken = null;
  }
}
