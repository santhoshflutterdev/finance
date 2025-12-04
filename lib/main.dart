import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_page/pages/wallet_page.dart';
import 'firebase_options.dart';

// theme
import 'theme/app_theme.dart';

// pages (make sure these files exist under lib/pages/)
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/enter_code_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/exchange_page.dart';
import 'pages/qr_scan_page.dart';
import 'pages/activity_page.dart';
import 'pages/profile_page.dart';
import 'pages/pay_bills_page.dart';
import 'pages/bill_payment_page.dart';
import 'pages/loans_page.dart';
import 'pages/budget_page.dart';
import 'pages/settings_page.dart';
import 'pages/contacts_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // start at splash
      initialRoute: '/',
      routes: {
        // core
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignUpPage(),
        '/forgot': (_) => const ForgotPasswordPage(),
        '/enter_code': (_) => const EnterCodePage(),

        // main app pages (each page is a standalone route)
        '/dashboard': (_) => const DashboardPage(),
        '/wallet': (_) => const WalletPage(),
        '/exchange': (_) => const ExchangePage(),
        '/scan': (_) => const QRScanPage(),
        '/activity': (_) => const ActivityPage(),
        '/profile': (_) => const ProfilePage(),
        '/pay_bills': (_) => const PayBillsPage(),
        '/bill_payment': (_) => const BillPaymentPage(),
        '/loans': (_) => const LoansPage(),
        '/budget': (_) => const BudgetPage(),
        '/settings': (_) => const SettingsPage(),
        '/contacts': (_) => const ContactsPage(),
      },

      // fallback for unknown routes
      onUnknownRoute: (settings) => MaterialPageRoute(builder: (_) => const SplashPage()),
    );
  }
}