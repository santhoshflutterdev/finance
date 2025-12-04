import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});
  @override
  State<EnterCodePage> createState() => _EnterCodePageState();
}

class _EnterCodePageState extends State<EnterCodePage> {
  final List<String> _digits = ['', '', '', ''];
  int _pos = 0;

  void _onKey(String k) {
    setState(() {
      if (k == 'del') {
        if (_pos > 0) {
          _pos--;
          _digits[_pos] = '';
        }
      } else {
        if (_pos < _digits.length) {
          _digits[_pos] = k;
          _pos++;
        }
      }
    });
  }

  void _verify() {
    final code = _digits.join();
    if (code.length == 4) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 4-digit code')));
    }
  }

  Widget _buildKey(String label) {
    return InkWell(
      onTap: () => _onKey(label),
      borderRadius: BorderRadius.circular(40),
      child: Container(width: 72, height: 72, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF1B1B1B)), child: label == 'del' ? const Icon(Icons.backspace_outlined, color: Colors.white54) : Text(label, style: const TextStyle(fontSize: 22, color: Colors.white70))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          Align(alignment: Alignment.topLeft, child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white70))),
          const SizedBox(height: 12),
          const Center(child: Text('Enter Code', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700))),
          const SizedBox(height: 8),
          const Text('Please enter code sent to your phone. Code will expire in 29s', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_digits.length, (i) {
            final ch = _digits[i];
            return Container(margin: const EdgeInsets.symmetric(horizontal: 10), width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: ch.isEmpty ? Colors.white24 : AppTheme.primary, width: 2), color: ch.isEmpty ? Colors.transparent : AppTheme.primary));
          })),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            decoration: const BoxDecoration(color: Color(0xFF101010), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
            child: Column(children: [
              Wrap(spacing: 20, runSpacing: 20, alignment: WrapAlignment.center, children: [
                for (var k in ['1','2','3','4','5','6','7','8','9']) _buildKey(k),
                _buildKey('0'),
                _buildKey('del'),
              ]),
              const SizedBox(height: 18),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _verify, child: const Text('Verify'))),
            ]),
          ),
        ]),
      ),
    );
  }
}