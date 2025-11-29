import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _phoneCtr = TextEditingController();
  final _dobCtr = TextEditingController();
  final _stateCtr = TextEditingController();
  final _cityCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _phoneCtr.dispose();
    _dobCtr.dispose();
    _stateCtr.dispose();
    _cityCtr.dispose();
    _passwordCtr.dispose();
    super.dispose();
  }

  String? _validateName(String? v) => (v == null || v.trim().length < 2) ? 'Enter name' : null;
  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter email';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(v.trim()) ? null : 'Enter valid email';
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter phone';
    if (!RegExp(r'^\d{10}$').hasMatch(v.trim())) return 'Enter 10-digit phone';
    return null;
  }

  String? _validateDob(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter DOB (YYYY-MM-DD)';
    try {
      final dob = DateTime.parse(v.trim());
      final now = DateTime.now();
      final age = now.year - dob.year - ((now.month < dob.month || (now.month == dob.month && now.day < dob.day)) ? 1 : 0);
      if (age < 13) return 'Must be at least 13 years old';
      return null;
    } catch (_) {
      return 'Enter DOB in ISO format: YYYY-MM-DD';
    }
  }

  String? _validateNonEmpty(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      // Guard: ensure Firebase was initialized successfully
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase not initialized. Check that lib/firebase_options.dart exists and main.dart calls Firebase.initializeApp().');
      }

      final email = _emailCtr.text.trim();
      final password = _passwordCtr.text;
      final name = _nameCtr.text.trim();
      final phone = _phoneCtr.text.trim();
      final dob = _dobCtr.text.trim();
      final state = _stateCtr.text.trim();
      final city = _cityCtr.text.trim();

      // Create user
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      // Save profile to Firestore
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob,
        'state': state,
        'city': city,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      // Success - navigate
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup successful')));
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e, st) {
      debugPrint('FirebaseAuthException: ${e.code} ${e.message}\n$st');
      _showErrorDialog('Firebase Auth Error', '${e.code}: ${e.message ?? 'No message'}');
    } on FirebaseException catch (e, st) {
      // General Firebase errors (e.g., Firestore)
      debugPrint('FirebaseException: ${e.code} ${e.message}\n$st');
      _showErrorDialog('Firebase Error', '${e.code}: ${e.message ?? e.toString()}');
    } catch (e, st) {
      debugPrint('Signup error: $e\n$st');
      _showErrorDialog('Error', e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showErrorDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(controller: _nameCtr, decoration: const InputDecoration(labelText: 'Name'), validator: _validateName),
                const SizedBox(height: 8),
                TextFormField(controller: _emailCtr, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email'), validator: _validateEmail),
                const SizedBox(height: 8),
                TextFormField(controller: _phoneCtr, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (10 digits)'), validator: _validatePhone),
                const SizedBox(height: 8),
                TextFormField(controller: _dobCtr, decoration: const InputDecoration(labelText: 'DOB (YYYY-MM-DD)'), validator: _validateDob),
                const SizedBox(height: 8),
                TextFormField(controller: _stateCtr, decoration: const InputDecoration(labelText: 'State'), validator: _validateNonEmpty),
                const SizedBox(height: 8),
                TextFormField(controller: _cityCtr, decoration: const InputDecoration(labelText: 'City'), validator: _validateNonEmpty),
                const SizedBox(height: 8),
                TextFormField(controller: _passwordCtr, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: _validatePassword),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _submitSignup,
                  child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign Up'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}