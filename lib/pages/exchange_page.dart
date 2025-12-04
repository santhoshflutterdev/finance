// lib/pages/exchange_page.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});
  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  final _amount = TextEditingController();
  String _from = 'USD';
  String _to = 'EUR';
  double _result = 0;
  // Example static rates map (1 USD -> 0.92 EUR)
  final Map<String, Map<String, double>> _rates = {
    'USD': {'EUR': 0.92, 'INR': 83.0, 'USD': 1.0},
    'EUR': {'USD': 1.09, 'INR': 90.0, 'EUR': 1.0},
    'INR': {'USD': 0.012, 'EUR': 0.011, 'INR': 1.0},
  };

  void _convert() {
    final v = double.tryParse(_amount.text.trim()) ?? 0.0;
    final rate = _rates[_from]?[_to] ?? 1.0;
    setState(() => _result = v * rate);
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = _rates.keys.toList();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Exchange')),
      body: SafeArea(
        child: Padding(
          padding: AppTheme.pagePadding,
          child: Column(children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  Row(children: [
                    Expanded(child: DropdownButtonFormField<String>(value: _from, items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _from = v ?? _from))),
                    const SizedBox(width: 12),
                    IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () { setState((){ final t = _from; _from = _to; _to = t; }); }),
                    const SizedBox(width: 12),
                    Expanded(child: DropdownButtonFormField<String>(value: _to, items: currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => setState(() => _to = v ?? _to))),
                  ]),
                  const SizedBox(height: 12),
                  TextField(controller: _amount, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(hintText: 'Amount')),
                  const SizedBox(height: 12),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _convert, child: const Text('CONVERT'))),
                  const SizedBox(height: 12),
                  if (_result != 0) Text('Result: ${_result.toStringAsFixed(2)} $_to', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}