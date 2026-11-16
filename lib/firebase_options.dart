// Firebase app config for project `a-muslim-matchmaker` (same values as
// google-services.json / GoogleService-Info.plist). These are public client
// identifiers, not secrets. Used only for push notifications (FCM).

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// Null on platforms without a registered Firebase app (web, desktop).
  static FirebaseOptions? get currentPlatform {
    if (kIsWeb) return null;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return null;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIBoHU4E4IFJzP8DCeTAA3h9MIhnxtPmU',
    appId: '1:628950763605:android:c6a77dc3c315a21d10acdc',
    messagingSenderId: '628950763605',
    projectId: 'a-muslim-matchmaker',
    storageBucket: 'a-muslim-matchmaker.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDhs0bYorJdS8mTLdOi9YJENqZis29Ejo',
    appId: '1:628950763605:ios:b900b9a662e6ef9210acdc',
    messagingSenderId: '628950763605',
    projectId: 'a-muslim-matchmaker',
    storageBucket: 'a-muslim-matchmaker.firebasestorage.app',
    iosBundleId: 'com.muslimmatchmaker.app',
  );
}
