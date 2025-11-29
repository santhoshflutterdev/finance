import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  final double _balance = 29000.45;
  final List<_DummyTxn> _txns = const [
    _DummyTxn(title: 'Groceries', subtitle: 'Walmart • Today', amount: -54.20),
    _DummyTxn(
      title: 'Salary',
      subtitle: 'Company Inc • 2 days ago',
      amount: 2500.00,
    ),
    _DummyTxn(
      title: 'Coffee',
      subtitle: 'Cafe Latte • Yesterday',
      amount: -3.50,
    ),
    _DummyTxn(
      title: 'Freelance',
      subtitle: 'Design work • 5 days ago',
      amount: 120.00,
    ),
  ];

  final List<double> _chartValues = const [1200, 800, 1800, 900, 2400, 1500];

  String _fmt(double v) {
    final sign = v < 0 ? '-' : '';
    final abs = v.abs().toStringAsFixed(2);
    return '$sign\$${abs}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.pagePadding,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.primary,
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 28,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Balance',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${29000.45.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('SEND'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('REQUEST'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _createBars(_chartValues),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          _chartValues.length,
                          (i) => Text(
                            'M${i + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: const [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: _txns.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final t = _txns[index];
                    final isIncome = t.amount >= 0;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isIncome
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          t.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          t.subtitle,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          _fmt(t.amount),
                          style: TextStyle(
                            color: isIncome
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  // Fixed: ensure barHeight is a double (clamp returns num)
  List<Widget> _createBars(List<double> values) {
    final max = values.reduce((a, b) => a > b ? a : b);
    return values.map((v) {
      final heightFactor = max == 0 ? 0.1 : (v / max);
      // clamp returns num — convert to double
      final double barHeight = (heightFactor * 100).clamp(10, 100).toDouble();
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: barHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _DummyTxn {
  final String title;
  final String subtitle;
  final double amount;
  const _DummyTxn({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
}
