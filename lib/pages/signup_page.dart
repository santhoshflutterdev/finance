import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _dob = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _dob.dispose();
    _state.dispose();
    _city.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email.text.trim(), password: _pass.text);
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'dob': _dob.text.trim(),
        'state': _state.text.trim(),
        'city': _city.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup successful')));
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? e.code);
    } catch (e) {
      _show('Unexpected error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppTheme.pagePadding,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width > 520 ? 520 : double.infinity),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Align(alignment: Alignment.topLeft, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white70))),
              const SizedBox(height: 6),
              const Center(child: Text('Get Started', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700))),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(controller: _name, decoration: const InputDecoration(hintText: 'Full name'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(hintText: 'Email'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: 'Phone number'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: TextFormField(controller: _state, decoration: const InputDecoration(hintText: 'State'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null)),
                        const SizedBox(width: 10),
                        Expanded(child: TextFormField(controller: _city, decoration: const InputDecoration(hintText: 'City'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null)),
                      ]),
                      const SizedBox(height: 10),
                      TextFormField(controller: _dob, decoration: const InputDecoration(hintText: 'DOB (YYYY-MM-DD)'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _pass, obscureText: true, decoration: const InputDecoration(hintText: 'Password'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                      const SizedBox(height: 16),
                      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _loading ? null : _signup, child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('CONFIRM'))),
                    ]),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}