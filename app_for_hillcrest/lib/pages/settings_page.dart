import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../data/translations.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'account_details_page.dart';
import 'change_password_page.dart';
import 'intro_page.dart';
import 'manage_users_page.dart';
import 'app_stats_page.dart';
import 'broadcast_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _authService = AuthService();

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          TranslationService.translate('delete_confirm_title'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(TranslationService.translate('delete_confirm_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              TranslationService.translate('cancel'),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showPasswordPrompt();
            },
            child: Text(
              TranslationService.translate('yes_delete'),
              style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordPrompt() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          TranslationService.translate('confirm_identity'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(TranslationService.translate('password_confirm_msg')),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: TranslationService.translate('password'),
                filled: true,
                fillColor: AppTheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              TranslationService.translate('cancel'),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          TextButton(
            onPressed: () async {
              final password = controller.text;
              if (password.isEmpty) return;

              final error = await _authService.deleteAccount(password);
              if (mounted) {
                Navigator.pop(context);
                if (error == null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const IntroPage()),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                }
              }
            },
            child: Text(
              TranslationService.translate('confirm'),
              style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('English (US)'),
            _languageOption('American Spanish'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String lang) {
    return ListTile(
      title: Text(lang, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: TranslationService.currentLanguage.value == lang
          ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen)
          : null,
      onTap: () async {
        Navigator.pop(context);
        final error = await _authService.updateUserLanguage(lang);
        if (mounted) {
          if (error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Language changed successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _authService.userModelStream,
      builder: (context, userSnapshot) {
        final user = userSnapshot.data;
        final bool isAdmin = user?.isAdmin ?? false;

        return ValueListenableBuilder(
          valueListenable: TranslationService.currentLanguage,
          builder: (context, lang, _) {
            return Scaffold(
              backgroundColor: AppTheme.background,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            TranslationService.translate('settings'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        children: [
                          if (isAdmin) ...[
                            _buildSectionHeader(TranslationService.translate('admin_options')),
                            _buildSettingsCard(
                              items: [
                                _buildSettingsItem(
                                  icon: Icons.people_outline_rounded,
                                  title: TranslationService.translate('manage_users'),
                                  subtitle: TranslationService.translate('manage_users_sub'),
                                  iconColor: Colors.teal,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ManageUsersPage()),
                                  ),
                                ),
                                _buildSettingsItem(
                                  icon: Icons.analytics_outlined,
                                  title: TranslationService.translate('app_stats'),
                                  subtitle: TranslationService.translate('app_stats_sub'),
                                  iconColor: Colors.indigo,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AppStatsPage()),
                                  ),
                                ),
                                _buildSettingsItem(
                                  icon: Icons.campaign_outlined,
                                  title: TranslationService.translate('broadcast'),
                                  subtitle: TranslationService.translate('broadcast_sub'),
                                  iconColor: Colors.pinkAccent,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const BroadcastPage()),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          _buildSectionHeader(TranslationService.translate('account_settings')),
                          _buildSettingsCard(
                            items: [
                              _buildSettingsItem(
                                icon: Icons.person_outline_rounded,
                                title: TranslationService.translate('account_details'),
                                subtitle: TranslationService.translate('account_details_sub'),
                                iconColor: Colors.blueAccent,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AccountDetailsPage()),
                                ),
                              ),
                              _buildSettingsItem(
                                icon: Icons.lock_outline_rounded,
                                title: TranslationService.translate('change_password'),
                                subtitle: TranslationService.translate('change_password_sub'),
                                iconColor: Colors.orangeAccent,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionHeader(TranslationService.translate('preferences')),
                          _buildSettingsCard(
                            items: [
                              _buildSettingsItem(
                                icon: Icons.notifications_none_rounded,
                                title: TranslationService.translate('notifications'),
                                subtitle: TranslationService.translate('notifications_sub'),
                                iconColor: AppTheme.primaryGreen,
                                trailing: Switch(
                                  value: true,
                                  onChanged: (val) {},
                                  activeColor: AppTheme.primaryGreen,
                                ),
                              ),
                              _buildSettingsItem(
                                icon: Icons.language_rounded,
                                title: TranslationService.translate('language'),
                                subtitle: lang,
                                iconColor: Colors.purpleAccent,
                                onTap: _showLanguageDialog,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionHeader(TranslationService.translate('danger_zone')),
                          _buildSettingsCard(
                            items: [
                              _buildSettingsItem(
                                icon: Icons.delete_outline_rounded,
                                title: TranslationService.translate('delete_account'),
                                subtitle: TranslationService.translate('delete_account_sub'),
                                iconColor: Colors.redAccent,
                                titleColor: Colors.redAccent,
                                onTap: _showDeleteDialog,
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Center(
                            child: Text(
                              'App Version 1.0.0',
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              TranslationService.translate('developed_by'),
                              style: const TextStyle(
                                color: Colors.black26,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppTheme.primaryGreen.withOpacity(0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: titleColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black45,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.black26),
      onTap: onTap,
    );
  }
}
