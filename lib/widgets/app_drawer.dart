import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';

typedef DrawerNavCallback = void Function(String routeKey);

class AppDrawer extends StatelessWidget {
  final String? email;
  final DrawerNavCallback? onNavigate;

  const AppDrawer({super.key, this.email, this.onNavigate});

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Close drawer then navigate to login
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Row(children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.primary),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.black, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(email ?? 'Guest', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('View profile', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ]),
                ),
              ]),
            ),

            // Items
            _buildTile(icon: Icons.account_balance_wallet, title: 'Wallet', onTap: () => onNavigate?.call('wallet')),
            _buildTile(icon: Icons.swap_horiz, title: 'Exchange', onTap: () => onNavigate?.call('exchange')),
            _buildTile(icon: Icons.payment, title: 'Pay Bills', onTap: () => onNavigate?.call('pay_bills')),
            _buildTile(icon: Icons.timeline, title: 'Activity', onTap: () => onNavigate?.call('activity')),
            _buildTile(icon: Icons.person, title: 'Profile', onTap: () => onNavigate?.call('profile')),

            const Divider(color: Colors.white12, height: 28, thickness: 1),
            _buildTile(icon: Icons.settings, title: 'Settings', onTap: () => onNavigate?.call('settings')),
            _buildTile(icon: Icons.help_outline, title: 'Help Center', onTap: () => Navigator.pushNamed(context, '/settings')),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () => _handleLogout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({required IconData icon, required String title, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}