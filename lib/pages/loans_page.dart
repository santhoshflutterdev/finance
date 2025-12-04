import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Loans')),
      body: Padding(
        padding: AppTheme.pagePadding,
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                const Text('Next Payment', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                const Text('\$655.00', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('TOP UP')))
              ]),
            ),
          ),
          const SizedBox(height: 12),
          const Text('All Loans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: List.generate(4, (i) => _loanCard(i))),
        ]),
      ),
    );
  }

  static Widget _loanCard(int i) {
    final titles = ['Student Loan','Car Loan','House Mortgage','Business Loan'];
    return SizedBox(width: 160, child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('${i+1}/6', style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(titles[i], style: const TextStyle(color: Colors.white70))]))));
  }
}