import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 240, height: 240, color: const Color(0xFF0C0C0C), child: const Center(child: Icon(Icons.qr_code, size: 120, color: Colors.white24))),
        const SizedBox(height: 12),
        const Text('Scanning QR Code...', style: TextStyle(color: Colors.white70)),
      ])),
    );
  }
}