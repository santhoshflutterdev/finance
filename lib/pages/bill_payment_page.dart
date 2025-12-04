import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BillPaymentPage extends StatelessWidget {
  const BillPaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Buy Airline Ticket')),
      body: Padding(
        padding: AppTheme.pagePadding,
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('SELECT A DATE', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.primary.withOpacity(0.4))), child: const Text('Oct 21')),
                const SizedBox(height: 12),
                const Text('GUESTS', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Row(children: [Expanded(child: _counter('Adults')), const SizedBox(width: 8), Expanded(child: _counter('Kids'))]),
                const SizedBox(height: 12),
                const Text('LOCATION', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)), child: const Text('Madrid, Spain')),
                const SizedBox(height: 12),
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: const Text('BUY TICKET'))),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  static Widget _counter(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(onPressed: () {}, icon: const Icon(Icons.remove_circle_outline)), const Text('2', style: TextStyle(fontSize: 16)), IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline))]),
      ]),
    );
  }
}