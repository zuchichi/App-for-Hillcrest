import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/help_page.dart';
import '../pages/intro_page.dart';
import '../pages/request_manage_ride_page.dart';
import '../pages/settings_page.dart';
import '../theme/app_theme.dart';
import '../data/translations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TranslationService.currentLanguage,
      builder: (context, lang, _) {
        return Drawer(
          backgroundColor: AppTheme.background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Modern Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'lib/assets/hillcrest-logo.png',
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hillcrest Rides',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      TranslationService.translate('driver_dashboard'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.home_rounded,
                      label: TranslationService.translate('home'),
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today_rounded,
                      label: TranslationService.translate('request_manage_ride_label'), // Fallback if missing
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const RequestManageRidePage(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings_rounded,
                      label: TranslationService.translate('settings'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.help_outline_rounded,
                      label: TranslationService.translate('help_faq'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const HelpPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Logout Section at Bottom
              Padding(
                padding: const EdgeInsets.all(24),
                child: ListTile(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const IntroPage()),
                        (route) => false,
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: Colors.redAccent.withOpacity(0.1),
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: Text(
                    TranslationService.translate('log_out'),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.black54, size: 24),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hoverColor: AppTheme.primaryGreen.withOpacity(0.1),
      ),
    );
  }
}
