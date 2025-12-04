import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final contacts = ['Alex Ventura','Ashton Levin Berk','Axel Viztek','Ben Burnley'];
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Contacts')),
      body: Padding(padding: AppTheme.pagePadding, child: Column(children: [
        TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search for...')),
        const SizedBox(height: 12),
        Expanded(child: ListView.separated(itemBuilder: (c,i) => Card(child: ListTile(title: Text(contacts[i]))), separatorBuilder: (_,__) => const SizedBox(height: 8), itemCount: contacts.length))
      ])),
    );
  }
}