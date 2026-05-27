import 'package:flutter/material.dart';

import 'pages/intro_page.dart';
import 'theme/app_theme.dart';

class HillcrestRidesApp extends StatelessWidget {
  const HillcrestRidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hillcrest Rides',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const IntroPage(),
    );
  }
}
