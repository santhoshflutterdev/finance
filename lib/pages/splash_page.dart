import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Wait a little for the splash look — safe & short
    await Future.delayed(const Duration(milliseconds: 900));

    // Check current Firebase auth user
    final user = FirebaseAuth.instance.currentUser;

    // Ensure widget still mounted before navigation
    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // If you are using "pure page navigation" use '/dashboard'.
      // If you use the bottom-nav route use '/main' or whichever you defined.
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: const [
            Icon(Icons.account_balance_wallet, size: 72, color: AppTheme.primary),
            SizedBox(height: 12),
            Text('Finance', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 6),
            Text('All Your Finances Inside one App', style: TextStyle(color: Colors.white70)),
          ]),
        ),
      ),
    );
  }
}