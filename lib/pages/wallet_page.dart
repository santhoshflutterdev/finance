// lib/pages/wallet_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? _uid;
  late final DocumentReference userDoc;
  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
    userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
  }

  Stream<DocumentSnapshot> get _balanceStream => userDoc.snapshots();
  Stream<QuerySnapshot> get _txnsStream => userDoc.collection('transactions').orderBy('timestamp', descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Wallet')),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.pagePadding,
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: _balanceStream,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                  final data = snap.data?.data() as Map<String, dynamic>? ?? {};
                  final balance = (data['balance'] ?? 0).toDouble();
                  return _balanceCard(balance);
                },
              ),
              const SizedBox(height: 12),
              const Align(alignment: Alignment.centerLeft, child: Text('Recent Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _txnsStream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    final docs = snap.data?.docs ?? [];
                    if (docs.isEmpty) return const Center(child: Text('No transactions yet', style: TextStyle(color: Colors.white70)));
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final d = docs[i].data() as Map<String, dynamic>;
                        final title = d['title'] ?? 'Transaction';
                        final subtitle = d['note'] ?? '';
                        final amount = (d['amount'] ?? 0).toDouble();
                        final ts = (d['timestamp'] as Timestamp?)?.toDate();
                        return _txnTile(title, subtitle, amount, ts);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _balanceCard(double balance) {
    return Card(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          CircleAvatar(radius: 30, backgroundColor: AppTheme.primary, child: const Icon(Icons.account_balance_wallet, color: Colors.black)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Current Balance', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text('\$${balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ])),
          ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/pay_bills'), child: const Text('SEND')),
        ]),
      ),
    );
  }

  Widget _txnTile(String title, String subtitle, double amount, DateTime? ts) {
    final income = amount >= 0;
    final time = ts == null ? '' : '${ts.day}/${ts.month}/${ts.year}';
    return Container(
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(children: [
        CircleAvatar(backgroundColor: income ? Colors.green.shade700 : Colors.red.shade700, child: Icon(income ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), if (subtitle.isNotEmpty) Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 13)), if (time.isNotEmpty) Text(time, style: const TextStyle(color: Colors.white54, fontSize: 12))])),
        Text('${income ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}', style: TextStyle(color: income ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}