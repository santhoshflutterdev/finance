import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});
  @override
  Widget build(BuildContext context) {
    final events = [
      {'title':'Tony requested funds','amount':'\$100.00'},
      {'title':'Maria sent you funds','amount':'\$2000.00'},
      {'title':'Sarah requested a loan','amount':'\$680.00'},
    ];
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Activity')),
      body: Padding(padding: AppTheme.pagePadding, child: Column(children: [
        Expanded(child: ListView.separated(itemBuilder: (c,i) {
          final e = events[i];
          return Card(child: ListTile(title: Text(e['title']!), subtitle: Text('1h ago'), trailing: Text(e['amount']!)));
        }, separatorBuilder: (_,__) => const SizedBox(height: 8), itemCount: events.length)),
      ])),
    );
  }
}