import 'package:flutter/material.dart';

class NewNavigationBar extends StatefulWidget {
  const NewNavigationBar({super.key});

  @override
  State<NewNavigationBar> createState() => _NewNavigationBarState();
}

class _NewNavigationBarState extends State<NewNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final title = " Navigation Drawer";
    return Scaffold(
      appBar: AppBar(title: Text("Navigation Bar")),
      body: Center(child: Text("data")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(child: Text("Navigation")),
              decoration: BoxDecoration(color: Colors.lightBlue),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Spacer(), // 👈 Pushes Settings to the bottom
            // 👇 Settings at last
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Settings screen here
              },
            ),
          ],
        ),
      ),
    );
  }
}
