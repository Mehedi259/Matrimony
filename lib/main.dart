import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'core/services/storage_service.dart';
import 'providers/auth_provider.dart';
import 'providers/matches_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Initialize AuthProvider and check authentication state
  final authProvider = AuthProvider();
  await authProvider.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MatrimonyApp(),
    ),
  );
}
