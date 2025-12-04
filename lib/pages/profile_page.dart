// lib/pages/profile_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _dob = TextEditingController();
  final _state = TextEditingController();
  final _city = TextEditingController();
  bool _saving = false;
  bool _loading = true;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_uid == null) return;
    setState(() => _loading = true);
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      final data = doc.data();
      if (data != null) {
        _name.text = (data['name'] ?? '').toString();
        _phone.text = (data['phone'] ?? '').toString();
        _dob.text = (data['dob'] ?? '').toString();
        _state.text = (data['state'] ?? '').toString();
        _city.text = (data['city'] ?? '').toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_uid == null) return;
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'name': _name.text.trim(),
        'phone': _phone.text.trim(),
        'dob': _dob.text.trim(),
        'state': _state.text.trim(),
        'city': _city.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _dob.dispose();
    _state.dispose();
    _city.dispose();
    super.dispose();
  }

  // small date picker helper
  Future<void> _pickDob() async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 20));
    if (_dob.text.isNotEmpty) {
      try {
        initial = DateFormat('yyyy-MM-dd').parse(_dob.text);
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select DOB',
    );
    if (picked != null) {
      _dob.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: AppTheme.pagePadding,
                child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      CircleAvatar(radius: 48, backgroundColor: AppTheme.primary, child: const Icon(Icons.person, color: Colors.black, size: 36)),
                      const SizedBox(height: 12),
                      TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name'), validator: (v) => (v == null || v.trim().length < 2) ? 'Enter name' : null),
                      const SizedBox(height: 10),
                      TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter phone' : null),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _dob,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'DOB (YYYY-MM-DD)'),
                        onTap: _pickDob,
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: TextFormField(controller: _state, decoration: const InputDecoration(labelText: 'State'))),
                        const SizedBox(width: 10),
                        Expanded(child: TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'))),
                      ]),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}