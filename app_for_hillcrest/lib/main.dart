import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'firebase_options.dart';

import 'app.dart';

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
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
    }
  }

  runApp(HillcrestRidesApp(firebaseAvailable: firebaseAvailable));
}
