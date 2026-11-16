import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/storage_service.dart';
import 'core/services/screen_protection_service.dart';
import 'core/services/push_notification_service.dart';
import 'providers/auth_provider.dart';
import 'providers/matches_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/notification_provider.dart';
import 'features/subscription/purchase_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  // Enable global screenshot and screen recording protection across the entire app
  await ScreenProtectionService.init();
  
  // Push notifications (Firebase Cloud Messaging)
  await PushNotificationService.initialize();

  // Initialize AuthProvider and check authentication state
  final authProvider = AuthProvider();
  await authProvider.initialize();

  // Register this phone for pushes whenever a user is signed in.
  final notificationProvider = NotificationProvider();
  PushNotificationService.onForegroundMessage =
      () => notificationProvider.refreshAll();
  var pushRegistered = false;
  void syncPushWithAuth() {
    if (authProvider.isAuthenticated && !pushRegistered) {
      pushRegistered = true;
      PushNotificationService.onLoggedIn();
    } else if (!authProvider.isAuthenticated) {
      pushRegistered = false;
    }
  }
  authProvider.addListener(syncPushWithAuth);
  syncPushWithAuth();

  // In-app purchases: start listening once a user is signed in, so purchases
  // left unfinished (app killed mid-purchase) are verified on the next launch.
  final purchaseProvider = PurchaseProvider();
  void syncPurchasesWithAuth() {
    if (authProvider.isAuthenticated) {
      purchaseProvider.init();
    } else {
      purchaseProvider.reset();
    }
  }
  authProvider.addListener(syncPurchasesWithAuth);
  syncPurchasesWithAuth();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider.value(value: notificationProvider),
        ChangeNotifierProvider.value(value: purchaseProvider),
      ],
      child: MatrimonyApp(),
    ),
  );
}
