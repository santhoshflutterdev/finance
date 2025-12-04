// lib/pages/pay_bills_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PayBillsPage extends StatefulWidget {
  const PayBillsPage({super.key});
  @override
  State<PayBillsPage> createState() => _PayBillsPageState();
}

class _PayBillsPageState extends State<PayBillsPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  final _amount = TextEditingController();
  bool _sending = false;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    if (_uid == null) return;
    final value = double.tryParse(_amount.text.trim()) ?? 0.0;
    if (value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid amount')));
      return;
    }

    setState(() => _sending = true);
    final userDoc = FirebaseFirestore.instance.collection('users').doc(_uid);
    final txCol = userDoc.collection('transactions');

    final batch = FirebaseFirestore.instance.batch();
    final txRef = txCol.doc();
    batch.set(txRef, {
      'title': _title.text.trim(),
      'note': _note.text.trim(),
      'amount': -value,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // deduct balance safely using transaction
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snap = await transaction.get(userDoc);
        final data = snap.data();
        double current = 0;
        if (data != null && data['balance'] != null) {
          current = (data['balance'] as num).toDouble();
        }
        final newBalance = current - value;
        transaction.update(userDoc, {'balance': newBalance});
        transaction.set(txRef, {
          'title': _title.text.trim(),
          'note': _note.text.trim(),
          'amount': -value,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bill paid successfully')));
        Navigator.pop(context); // return to wallet/dashboard
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Pay Bills')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: Form(
            key: _form,
            child: Column(children: [
              TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Payee / Title'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _note, decoration: const InputDecoration(labelText: 'Note (optional)')),
              const SizedBox(height: 12),
              TextFormField(controller: _amount, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount'), validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _sending ? null : _submit, child: _sending ? const CircularProgressIndicator() : const Text('PAY')),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}