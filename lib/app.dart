import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/intro_page.dart';
import 'pages/dashboard_shell.dart';
import 'theme/app_theme.dart';
import 'data/translations.dart';

class HillcrestRidesApp extends StatefulWidget {
  const HillcrestRidesApp({super.key, this.firebaseAvailable = true});

  final bool firebaseAvailable;

  @override
  State<HillcrestRidesApp> createState() => _HillcrestRidesAppState();
}

class _HillcrestRidesAppState extends State<HillcrestRidesApp> {
  @override
  void initState() {
    super.initState();
    if (widget.firebaseAvailable) {
      _loadUserLanguage();
    }
  }

  Future<void> _loadUserLanguage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final lang = doc.data()?['selectedLanguage'];
        if (lang != null) {
          TranslationService.currentLanguage.value = lang;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hillcrest Rides',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: widget.firebaseAvailable 
        ? StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasData) {
                return const DashboardShell();
              }
              return const IntroPage();
            },
          )
        : const IntroPage(), // Skip Firebase logic if initialization failed
    );
  }
}
