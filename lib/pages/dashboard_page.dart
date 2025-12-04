// lib/pages/dashboard_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final double _balance = 29000.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer is provided and its items now navigate correctly
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Use Builder so Scaffold.of(context) finds the Scaffold
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: Colors.white, size: 26),
          )
        ],
      ),
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppTheme.pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                const Text(
                  "Hi, User",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text("Welcome back", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),

                // Balance card
                _buildBalanceCard(context),

                const SizedBox(height: 20),

                const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),

                // Transactions list (example items)
                _buildTransaction("Salary", "Company Inc", 2500.00),
                const SizedBox(height: 12),
                _buildTransaction("Groceries", "Walmart", -54.20),
                const SizedBox(height: 12),
                _buildTransaction("Freelance", "Design work", 120.00),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Drawer ------------------
  // Note: this function needs the BuildContext to perform navigation and close drawer.
  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayEmail = user?.email ?? 'Guest';

    return Drawer(
      backgroundColor: AppTheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with user info
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Row(children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme.primary),
                  child: const Icon(Icons.person, color: Colors.black, size: 36),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(displayEmail, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text("View profile", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ]),
                ),
              ]),
            ),

            // Navigation items
            _drawerTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context); // close drawer
                // navigate to profile route
                Navigator.pushNamed(context, '/profile');
              },
            ),
            _drawerTile(
              icon: Icons.account_balance_wallet,
              title: 'Wallet',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dashboard'); // or '/wallet' if you have separate
              },
            ),
            _drawerTile(
              icon: Icons.swap_horiz,
              title: 'Exchange',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/exchange');
              },
            ),
            _drawerTile(
              icon: Icons.payment,
              title: 'Pay Bills',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pay_bills');
              },
            ),
            const Divider(color: Colors.white12, height: 28, thickness: 1),
            _drawerTile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            _drawerTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/help'); // create a '/help' page or change route
              },
            ),

            const Spacer(),

            // Logout button at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () async {
                  // Close drawer first
                  Navigator.pop(context);

                  // Sign out from Firebase
                  await FirebaseAuth.instance.signOut();

                  // Remove all routes and go to login (replace with your login route)
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      visualDensity: VisualDensity.compact,
    );
  }

  // ---------------- Balance Card ------------------
  Widget _buildBalanceCard(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Balance', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text('\$${_balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 14),

          // Chart placeholder box
          Container(
            height: 110,
            decoration: BoxDecoration(color: const Color(0xFF0D0D0D), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const Text('Chart placeholder', style: TextStyle(color: Colors.white24)),
          ),

          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/pay_bills'), // wire to send flow or contacts
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppTheme.primary, width: 1.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('SEND'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/contacts'), // request flow
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: AppTheme.primary, width: 1.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('REQUEST'),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  // ---------------- Transactions ------------------
  Widget _buildTransaction(String title, String subtitle, double amount) {
    final isIncome = amount >= 0;
    final amountText = '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}';

    return Container(
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: isIncome ? Colors.green.shade700 : Colors.red.shade700,
          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          ]),
        ),
        Text(amountText, style: TextStyle(color: isIncome ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}