import 'package:flutter/material.dart';

class TranslationService {
  static final ValueNotifier<String> currentLanguage = ValueNotifier('English (US)');

  static final Map<String, Map<String, String>> _localizedValues = {
    'English (US)': {
      'settings': 'Settings',
      'account_settings': 'Account Settings',
      'account_details': 'Account Details',
      'account_details_sub': 'Change your name and profile details',
      'change_password': 'Change Password',
      'change_password_sub': 'Update account password securely',
      'preferences': 'Preferences',
      'notifications': 'Notifications',
      'notifications_sub': 'Choose how ride updates are delivered',
      'language': 'Language',
      'danger_zone': 'Danger Zone',
      'delete_account': 'Delete Account',
      'delete_account_sub': 'Permanently delete this account',
      'developed_by': 'Developed by Uchechi Ejiogu and Soham Patel',
      'save_changes': 'Save Changes',
      'update_password': 'Update Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm New Password',
    },
    'American Spanish': {
      'settings': 'Ajustes',
      'account_settings': 'Configuración de la cuenta',
      'account_details': 'Detalles de la cuenta',
      'account_details_sub': 'Cambia tu nombre y detalles del perfil',
      'change_password': 'Cambiar contraseña',
      'change_password_sub': 'Actualizar contraseña de forma segura',
      'preferences': 'Preferencias',
      'notifications': 'Notificaciones',
      'notifications_sub': 'Elige cómo se entregan las actualizaciones',
      'language': 'Idioma',
      'danger_zone': 'Zona de Peligro',
      'delete_account': 'Eliminar cuenta',
      'delete_account_sub': 'Eliminar esta cuenta permanentemente',
      'developed_by': 'Desarrollado por Uchechi Ejiogu y Soham Patel',
      'save_changes': 'Guardar cambios',
      'update_password': 'Actualizar contraseña',
      'current_password': 'Contraseña actual',
      'new_password': 'Nueva contraseña',
      'confirm_password': 'Confirmar nueva contraseña',
    },
  };

  static String translate(String key) {
    return _localizedValues[currentLanguage.value]?[key] ?? key;
  }
}
