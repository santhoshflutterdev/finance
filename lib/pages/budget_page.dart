import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Budget')),
      body: Padding(padding: AppTheme.pagePadding, child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [const Text('\$12,902', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('JANUARY', style: TextStyle(color: Colors.white70))]))),
        const SizedBox(height: 12),
        const Text('Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Column(children: [
          _expenseRow('Food & Drink','\$300.00 left'),
          _expenseRow('Transport','\$1,200.00 left'),
          _expenseRow('Investments','\$2,000.00 left'),
        ])
      ])),
    );
  }

  static Widget _expenseRow(String title, String sub) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: AppTheme.primary, child: const Icon(Icons.attach_money)), title: Text(title), subtitle: Text(sub)));
}