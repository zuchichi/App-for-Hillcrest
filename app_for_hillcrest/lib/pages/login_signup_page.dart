import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'dashboard_shell.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Signup')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              decoration: _fieldDecoration('Username', Icons.person_outline),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: _fieldDecoration('Password', Icons.lock_outline),
            ),
            const SizedBox(height: 16),
            if (isSignUp)
              TextField(
                obscureText: true,
                decoration: _fieldDecoration(
                  'Confirm Password',
                  Icons.lock_reset_outlined,
                ),
              ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const DashboardShell(),
                    ),
                    (_) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isSignUp ? 'Create Account' : 'Login'),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => isSignUp = !isSignUp),
              child: Text(
                isSignUp
                    ? 'Already have an account? Login'
                    : 'Need an account? Sign up',
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}
