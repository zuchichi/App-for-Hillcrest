import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, debugPrint, TargetPlatform;
import 'firebase_options.dart';
import 'services/notification_service.dart';

import 'app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here if needed
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool firebaseAvailable = false;
  
  // Guard against Linux which isn't configured in firebase_options.dart
  final bool isUnsupportedDesktop = !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

  if (!isUnsupportedDesktop) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseAvailable = true;
      
      // Initialize notifications
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      await NotificationService.initialize();

    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
    }
  }

  runApp(HillcrestRidesApp(firebaseAvailable: firebaseAvailable));
}
