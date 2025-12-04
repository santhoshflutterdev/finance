import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import 'dashboard_page.dart';
import 'exchange_page.dart';
import 'qr_scan_page.dart';
import 'activity_page.dart';
import 'profile_page.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});
  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> {
  int _index = 0;
  final List<Widget> _pages = const [
    DashboardPage(),
    ExchangePage(),
    QRScanPage(),
    ActivityPage(),
    ProfilePage(),
  ];

  User? get _user => FirebaseAuth.instance.currentUser;

  void _selectIndex(int idx) {
    setState(() => _index = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add the drawer here
      drawer: AppDrawer(
        email: _user?.email,
        onNavigate: (route) {
          Navigator.pop(context); // close drawer
          // simple route handling for some routes that are internal pages
          switch (route) {
            case 'wallet':
              _selectIndex(0);
              break;
            case 'exchange':
              _selectIndex(1);
              break;
            case 'scan':
              _selectIndex(2);
              break;
            case 'activity':
              _selectIndex(3);
              break;
            case 'profile':
              _selectIndex(4);
              break;
            case 'settings':
              Navigator.pushNamed(context, '/settings');
              break;
            case 'pay_bills':
              Navigator.pushNamed(context, '/pay_bills');
              break;
            default:
              break;
          }
        },
      ),

      // Keep AppBar transparent to match dark theme
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.person, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),

      body: _pages[_index],

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: AppTheme.surface,
        notchMargin: 6,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem(icon: Icons.account_balance_wallet, label: 'Wallet', i: 0),
              _buildItem(icon: Icons.swap_horiz, label: 'Exchange', i: 1),
              const SizedBox(width: 64), // gap for FAB
              _buildItem(icon: Icons.timeline, label: 'Activity', i: 3),
              _buildItem(icon: Icons.person, label: 'Profile', i: 4),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () => _selectIndex(2), // center = QR
        child: const Icon(Icons.qr_code_scanner, color: Colors.black),
      ),
    );
  }

  Widget _buildItem({required IconData icon, required String label, required int i}) {
    final selected = _index == i;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectIndex(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 22, color: selected ? AppTheme.primary : Colors.white70),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: selected ? AppTheme.primary : Colors.white54)),
          ]),
        ),
      ),
    );
  }
}